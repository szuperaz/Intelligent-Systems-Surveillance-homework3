Param(
  [Parameter(Mandatory=$True)]
  [string]$HotelClient
)

$out = 'test2.txt'
"Test3" > $out
"4 cliens running, stopping one of them every 10 secs" >> $out
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
$client3.StartInfo.Arguments = " 3 4"
$client3.StartInfo.CreateNoWindow = $true
$client3.StartInfo.RedirectStandardInput = $true
$client3.StartInfo.UseShellExecute = $false

$client4 = new-object System.Diagnostics.Process
$client4.StartInfo.FileName = $HotelClient
$client4.StartInfo.Arguments = " 4 4"
$client4.StartInfo.CreateNoWindow = $true
$client4.StartInfo.RedirectStandardInput = $true
$client4.StartInfo.UseShellExecute = $false

"--- Before run ---" >> $out
Get-CimInstance IRF_Hotels -Namespace root/irfhf >> $out

$blabla = $client1.Start()
$blabla = $client2.Start()
$blabla = $client3.Start()
$blabla = $client4.Start()

"4 clients are running, waiting for 5 secs"
Start-Sleep -s 5
"--- After start ---" >> $out
Get-CimInstance IRF_Hotels -Namespace root/irfhf >> $out

"Waiting for 10 secs"
Start-Sleep -s 10
$client1.StandardInput.WriteLine(3)
$client1.WaitForExit()
"3 clients are running"

"Waiting for 10 secs"
Start-Sleep -s 6
"--- 3 clients are running ---" >> $out
Get-CimInstance IRF_Hotels -Namespace root/irfhf >> $out
Start-Sleep -s 4
$client2.StandardInput.WriteLine(3)
$client2.WaitForExit()
"2 clients are running"

"Waiting for 10 secs"
Start-Sleep -s 6
"--- 2 clients are running ---" >> $out
Get-CimInstance IRF_Hotels -Namespace root/irfhf >> $out
Start-Sleep -s 4
$client3.StandardInput.WriteLine(3)
$client3.WaitForExit()
"1 client is running"

"Waiting for 10 secs"
Start-Sleep -s 6
"--- 1 client is running ---" >> $out
Get-CimInstance IRF_Hotels -Namespace root/irfhf >> $out
Start-Sleep -s 4
$client4.StandardInput.WriteLine(3)
$client4.WaitForExit()
"0 client is running"
Start-Sleep -s 6
"--- 0 client is running ---" >> $out
Get-CimInstance IRF_Hotels -Namespace root/irfhf >> $out

"Done"