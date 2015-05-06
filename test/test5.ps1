Param(
  [Parameter(Mandatory=$True)]
  [string]$HotelClient
)

$out = 'test5.txt'
"Test5" > $out
"Booking" >> $out

$client1 = new-object System.Diagnostics.Process
$client1.StartInfo.FileName = $HotelClient
$client1.StartInfo.Arguments = " 1 4"
$client1.StartInfo.CreateNoWindow = $true
$client1.StartInfo.RedirectStandardInput = $true
$client1.StartInfo.UseShellExecute = $false

$client2 = new-object System.Diagnostics.Process
$client2.StartInfo.FileName = $HotelClient
$client2.StartInfo.Arguments = " 2 4"
$client2.StartInfo.CreateNoWindow = $true
$client2.StartInfo.RedirectStandardInput = $true
$client2.StartInfo.UseShellExecute = $false

$client3 = new-object System.Diagnostics.Process
$client3.StartInfo.FileName = $HotelClient
$client3.StartInfo.Arguments = " 3 4"
$client3.StartInfo.CreateNoWindow = $true
$client3.StartInfo.RedirectStandardInput = $true
$client3.StartInfo.UseShellExecute = $false

"--- Before run ---" >> $out
Get-CimInstance IRF_Hotels -Namespace root/irfhf >> $out


$blabla = $client1.Start()
$blabla = $client2.Start()
$blabla = $client3.Start()

"Client is running, waiting for 5 secs"
Start-Sleep -s 5
"--- After start ---" >> $out
Get-CimInstance IRF_Hotels -Namespace root/irfhf >> $out

"Booking rooms"
# copy-paste, not nice
$client1.StandardInput.WriteLine(1)
$client1.StandardInput.WriteLine(1)
$client1.StandardInput.WriteLine(1)
$client1.StandardInput.WriteLine(1)
$client2.StandardInput.WriteLine(1)
$client2.StandardInput.WriteLine(1)
$client2.StandardInput.WriteLine(1)
$client2.StandardInput.WriteLine(1)
"2 clients are booked"
"Waiting for 30 secs"
Start-Sleep -s 30
"--- after 8 room reservations 2 clients are booked ---" >> $out
Get-CimInstance IRF_Hotels -Namespace root/irfhf >> $out

"Delete bookings"
$client2.StandardInput.WriteLine(2)
$client2.StandardInput.WriteLine(2)
"Only 1 client is booked"
"Waiting for 30 secs"
Start-Sleep -s 30
"--- 1 client is booked ---" >> $out
Get-CimInstance IRF_Hotels -Namespace root/irfhf >> $out

$client1.StandardInput.WriteLine(3)
$client1.WaitForExit()
$client2.StandardInput.WriteLine(3)
$client2.WaitForExit()
$client3.StandardInput.WriteLine(3)
$client3.WaitForExit()
"Done"