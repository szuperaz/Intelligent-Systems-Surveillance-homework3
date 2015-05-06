using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
//using System.Diagnostics;
using System.Management.Instrumentation;
using IRFHotels.Common;
using IRFHotels.DAL;

// Specify the WMI namespace and hosting model for the WMI provider
[assembly: WmiConfiguration("root/irfhf",
HostingModel = ManagementHostingModel.Decoupled, IdentifyLevel = false)]

namespace IRFHotels.Provider
{
    /// <summary>
    /// Decoupled, multi-instance WMI provider
    /// </summary>
    [ManagementEntity(Name = "IRF_Hotels")]
    [ManagementQualifier("Description", Value = "Provider for IRFHotels.")]
    public class IRFHotelsProvider
    {
        /// <summary>
        /// Key of the provider
        /// </summary>
        private int key;

        public IRFHotelsProvider()
        {
            // It's OK to use dummy key, beacuse there is only one instance of IRFHotels, and in it there is only one istance of the provider
            key = 1;
        }

        /// <summary>
        /// Gets the key of the provider
        /// </summary>
        [ManagementKey]
        [ManagementQualifier("Description", Value = "Key of the provider")]
        public int Key
        {
            get { return this.key; }
        }

        /// <summary>
        /// Counts active hotels
        /// </summary>
        [ManagementQualifier("Description", Value = "Number of active hotels")]
        [ManagementProbe]
        public int ActiveHotels
        {
            get { return Monitoring.CountActiveHotels(); }
        }

        /// <summary>
        /// Counts the rate of active hotels / all hotels
        /// </summary>
        [ManagementQualifier("Description", Value = "Rate of active hotels / all hotels")]
        [ManagementProbe]
        public double RateOfActiveHotels
        {
            
            get
            {
                double hotels = (double)DataManager.CountHotels();
                return hotels == 0 ? 0 : Math.Round(Monitoring.CountActiveHotels() / hotels, 2);
            }
        }

        /// <summary>
        /// Counts the average of recieved ImAlive messages (both invalid and valid) per min
        /// </summary>
        [ManagementQualifier("Description", Value = "Average of recivied ImAlive messages (both invalid and valid) per min")]
        [ManagementProbe]
        public double AvgAliveMessagesPerMin
        {
            get { return Math.Round(Monitoring.CountAvgAliveMessagesPerMin(), 2); }
        }

        /// <summary>
        /// Counts the number of timeouts that occured since the application has started running
        /// </summary>
        [ManagementQualifier("Description", Value = "The number of timeouts since running")]
        [ManagementProbe]
        public int TimeOuts
        {
            get { return Monitoring.CountTimeouts(); }
        }

        /// <summary>
        /// Counts the rate of invalid / all ImAlive messages
        /// </summary>
        [ManagementQualifier("Description", Value = "Rate of invalid / all ImAlive messages")]
        [ManagementProbe]
        public double RateOfInvalidAliveMessages
        {
            get { return Math.Round(Monitoring.CountRateOfInvalidAliveMessages(), 2);  }
        }

        /// <summary>
        /// Returns how long the allpication has been running
        /// </summary>
        [ManagementQualifier("Description", Value = "Shows how long the application has been running")]
        [ManagementProbe]
        public TimeSpan UpTime
        {
            get { return Monitoring.CountUpTime(); }
        }

        /// <summary>
        /// Counts the average active time of a hotel
        /// </summary>
        [ManagementQualifier("Description", Value = "Average time while a hotel is active")]
        [ManagementProbe]
        public TimeSpan AvgActiveTime
        {
            get { return Monitoring.CountAvgActiveTime(); }
        }

        /// <summary>
        /// Counts the rate of booked active hotels / all active hotels
        /// </summary>
        [ManagementQualifier("Description", Value = "Rate of booked active / all active hotels")]
        [ManagementProbe]
        public double RateOfBookedActiveHotels
        {
            get { return Math.Round(Monitoring.CountRateOfBookedActiveHotels(), 2); }
        }

        /// <summary>
        /// Counts the average room reservations per min
        /// </summary>
        [ManagementQualifier("Description", Value = "Average room reservations per min")]
        [ManagementProbe]
        public double AvgRoomReservationsPerMin
        {
            get { return Math.Round(Monitoring.CountAvgRoomReservationsPerMin(), 2); }
        }
    }
}
