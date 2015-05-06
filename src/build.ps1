C:\Windows\Microsoft.NET\Framework\v4.0.30319\MSBuild.exe IRFHotels.sln
c:\Windows\Microsoft.NET\Framework\v4.0.30319\InstallUtil.exe IRFHotels\bin\Debug\IRFHotels.exe
Get-Wmiobject -class WMI_Extension -namespace root\irfhf | % { $_.SecurityDescriptor = "O:WDG:WDD:(A;;0x1;;;WD)"; $_.Put() }
