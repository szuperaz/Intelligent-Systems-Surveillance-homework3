Param(
  [Parameter(Mandatory=$True)]
  [string]$HotelClient
)

$out = 'test4.txt'
"Test4" > $out
"2 clients running for 2 mins, stop and restart them after 6 or 12 secs" >> $out

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

"--- Before run ---" >> $out
Get-CimInstance IRF_Hotels -Namespace root/irfhf >> $out


$blabla = $client1.Start()
$blabla = $client2.Start()

"Clients are running, waiting for 5 secs"
Start-Sleep -s 5
"--- After start ---" >> $out
Get-CimInstance IRF_Hotels -Namespace root/irfhf >> $out

"Running for ~2 mins"
for ($i= 0; $i -le 10; $i++)
{
    "Waiting for 6 secs"
    Start-Sleep -s 6
    "Client1 stops"
    $client1.StandardInput.WriteLine(3)
    $client1.WaitForExit()
    if ($client2.HasExited)
    {
        "Client2 starts"
        $blabla = $client2.Start()
    }

    "Waiting for 6 secs"
    Start-Sleep -s 6
    "Client1 starts"
    $blabla = $client1.Start()
    $mod = $i%2
    if ($mod = 0)
    {
        "Client2 stops"
        $client2.StandardInput.WriteLine(3)
        $client2.WaitForExit()
    }
}

Start-Sleep -s 6
"--- After 2 mins ---" >> $out
Get-CimInstance IRF_Hotels -Namespace root/irfhf >> $out

if (!$client1.HasExited)
{
    $client1.StandardInput.WriteLine(3)
    $client1.WaitForExit()
}
if (!$client2.HasExited)
{
    $client2.StandardInput.WriteLine(3)
    $client2.WaitForExit()
}

"Done"