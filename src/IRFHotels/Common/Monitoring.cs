using IRFHotels.DAL;
using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IRFHotels.Common
{
    public class Monitoring : IMonitoring
    {
        public static ConcurrentDictionary<int, DateTime> ActiveHotels = new ConcurrentDictionary<int, DateTime>();
        public static ConcurrentDictionary<int, DateTime> ActiveHotelsStart = new ConcurrentDictionary<int, DateTime>();
        /// <summary>
        /// Start time of the application
        /// </summary>
        public static DateTime StartTime = DateTime.Now;

        /// <summary>
        /// Number of recieved ImAlive messages since running
        /// </summary>
        public static int MsgsCount = 0;

        /// <summary>
        /// Number of recieved invalis ImAlive messages since running
        /// </summary>
        public static int InvalidMsgsCount = 0;

        /// <summary>
        /// Number of timeouts since running
        /// </summary>
        public static int TimeoutsCount = 0;

        /// <summary>
        /// When an active hotel times out, its active time is added to ActiveTimesCount
        /// </summary>
        public static TimeSpan ActiveTimesCount = new TimeSpan(0);

        /// <summary>
        /// The number of booking has been made since running
        /// </summary>
        public static int BookingsCount = 0;

        public void ImAlive(int id, int freeRoomCount)
        {
            MsgsCount++;
            if (!DataManager.CheckIsKnownHotel(id))
            {
                InvalidMsgsCount++;
                return;
            }
            if (ActiveHotels.ContainsKey(id))
            {
                ActiveHotels[id] = DateTime.Now;
                int dbFreeRoomCount = DataManager.GetFreeRoomCount(id);
                if (dbFreeRoomCount != freeRoomCount)
                {
                    DataManager.SetFreeRoomCount(id, freeRoomCount);
                    if (dbFreeRoomCount != -1 && freeRoomCount < dbFreeRoomCount)
                    {
                        BookingsCount += dbFreeRoomCount - freeRoomCount;
                    }
                }
            }
            else
            {
                if (ActiveHotels.TryAdd(id, DateTime.Now))
                {
                    /* Successfully added a new hotel to actives. */
                    DataManager.SetFreeRoomCount(id, freeRoomCount);
                    // Save the start time in ActiveHotelsStart
                    ActiveHotelsStart.TryAdd(id, DateTime.Now);
                }
                
            }
        }

        public static void CheckAliveHotels()
        {
            var timeToCheck = DateTime.Now;

            var timeout = TimeSpan.FromSeconds(5);

            foreach (var hotel in ActiveHotels)
            {
                if (hotel.Value < (timeToCheck - timeout))
                {
                    TimeoutsCount++;
                    DateTime startTime;
                    if (ActiveHotelsStart.TryGetValue(hotel.Key, out startTime))
                    {
                        ActiveTimesCount = ActiveTimesCount.Add(timeToCheck - startTime);
                    }

                    DateTime removedElement;
                    if (ActiveHotels.TryRemove(hotel.Key, out removedElement))
                    {
                        /* Successfully removed due to timeout. */
                        // Also remove from ActiveHotelsStart
                        ActiveHotelsStart.TryRemove(hotel.Key, out removedElement);
                    }
                }
            }
        }

        public static void ListAliveHotels()
        {
            Console.Clear();
            foreach (var h in ActiveHotels)
            {
                var hotel = DataManager.GetHotelById(h.Key);
                Console.WriteLine(hotel.Id + " - " + hotel.Name + " - available rooms: " + hotel.FreeRoomCount);
            }
            Console.Write("Press ENTER to continue...");
            Console.ReadLine();
        }

        /// <summary>
        /// Counts active hotels
        /// </summary>
        public static int CountActiveHotels()
        {
            CheckAliveHotels();
            return ActiveHotels.Count;
        }

        /// <summary>
        /// Counts the average of recieved ImAlive messages (both invalid and valid) per min
        /// </summary>
        public static double CountAvgAliveMessagesPerMin()
        {
            TimeSpan timeSpan = DateTime.Now - StartTime;
            return timeSpan.TotalMinutes == 0 ? 0 : MsgsCount / timeSpan.TotalMinutes;

        }

        /// <summary>
        /// Counts the number of timeouts that occured since the application has started running
        /// </summary>
        public static int CountTimeouts()
        {
            CheckAliveHotels();
            return TimeoutsCount;
        }

        /// <summary>
        /// Counts the rate of invalid / all ImAlive messages
        /// </summary>
        public static double CountRateOfInvalidAliveMessages()
        {
            return MsgsCount == 0 ? 0 : InvalidMsgsCount / (double)MsgsCount;
        }

        /// <summary>
        /// Returns how long the allpication has been running
        /// </summary>
        public static TimeSpan CountUpTime()
        {
            return DateTime.Now - StartTime;
        }

        /// <summary>
        /// Counts the average active time of a hotel
        /// </summary>
        public static TimeSpan CountAvgActiveTime()
        {
            CheckAliveHotels();
            return TimeoutsCount == 0 ? ActiveTimesCount : new TimeSpan(ActiveTimesCount.Ticks / (Int64)TimeoutsCount);
        }

        /// <summary>
        /// Counts the rate of booked active hotels / all active hotels
        /// </summary>
        public static double CountRateOfBookedActiveHotels()
        {
            int bookedHotels = 0;
            int activeHotels = CountActiveHotels();
            if (activeHotels == 0)
            {
                return 0;
            }
            foreach (var hotel in ActiveHotels)
            {
                if (DataManager.GetFreeRoomCount(hotel.Key) == 0)
                {
                    bookedHotels++;
                }
            }
            return bookedHotels / (double)activeHotels;
        }


        /// <summary>
        /// Counts the average room reservations per min
        /// </summary>
        public static double CountAvgRoomReservationsPerMin()
        {
            TimeSpan timeSpan = DateTime.Now - StartTime;
            return timeSpan.TotalMinutes == 0 ? 0 : BookingsCount / timeSpan.TotalMinutes;
        }
    }
}
