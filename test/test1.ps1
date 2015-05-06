Param(
  [Parameter(Mandatory=$True)]
  [string]$HotelClient
)

$out = 'test1.txt'
"Test1" > $out
"1 client running for 1 min" >> $out

$client = new-object System.Diagnostics.Process
$client.StartInfo.FileName = $HotelClient
$client.StartInfo.Arguments = " 1 4"
$client.StartInfo.CreateNoWindow = $true
$client.StartInfo.RedirectStandardInput = $true
$client.StartInfo.UseShellExecute = $false

"--- Before run ---" >> $out
Get-CimInstance IRF_Hotels -Namespace root/irfhf >> $out


$blabla = $client.Start()

"Client is running, waiting for 5 secs"
Start-Sleep -s 5
"--- After start ---" >> $out
Get-CimInstance IRF_Hotels -Namespace root/irfhf >> $out

"Waiting for 1 min"
Start-Sleep -s 60

"--- After 1 min ---" >> $out
Get-CimInstance IRF_Hotels -Namespace root/irfhf >> $out

$client.StandardInput.WriteLine(3)
$client.WaitForExit()
"Done"