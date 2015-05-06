Param(
  [Parameter(Mandatory=$True)]
  [string]$HotelClient
)

$out = 'test3.txt'
"Test3" > $out
"4 cliens running for 1 min, 2 of them are not registered" >> $out
# lots of copy-paste, not nice
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
$client3.StartInfo.Arguments = " 6 4"
$client3.StartInfo.CreateNoWindow = $true
$client3.StartInfo.RedirectStandardInput = $true
$client3.StartInfo.UseShellExecute = $false

$client4 = new-object System.Diagnostics.Process
$client4.StartInfo.FileName = $HotelClient
$client4.StartInfo.Arguments = " 8 4"
$client4.StartInfo.CreateNoWindow = $true
$client4.StartInfo.RedirectStandardInput = $true
$client4.StartInfo.UseShellExecute = $false

"--- Before run ---" >> $out
Get-CimInstance IRF_Hotels -Namespace root/irfhf >> $out

$blabla = $client1.Start()
$blabla = $client2.Start()
$blabla = $client3.Start()
$blabla = $client4.Start()

"Clients are running, waiting for 5 secs"
Start-Sleep -s 5
"--- After start ---" >> $out
Get-CimInstance IRF_Hotels -Namespace root/irfhf >> $out

"Waiting for 1 min"
Start-Sleep -s 60

"--- After 1 min ---" >> $out
Get-CimInstance IRF_Hotels -Namespace root/irfhf >> $out

$client1.StandardInput.WriteLine(3)
$client1.WaitForExit()
$client2.StandardInput.WriteLine(3)
$client2.WaitForExit()
$client3.StandardInput.WriteLine(3)
$client3.WaitForExit()
$client4.StandardInput.WriteLine(3)
$client4.WaitForExit()

"Done"