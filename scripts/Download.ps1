Param(
    [string] $BaseUrl = "https://github.com/EQAditu/AdvancedCombatTracker/releases/download",
    [string] $Version = "3.4.0.260",
    [string] $File = "ACTv3.zip"
)

$uri = "$BaseUrl/$Version/$File"
$actExecutable = "Advanced Combat Tracker.exe"

Write-Output "Downloading $uri"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$wc = New-Object System.Net.WebClient
$wc.DownloadFile($uri, "act.zip")
Add-Type -AssemblyName System.IO.Compression.FileSystem

Write-Output "Extracting executable"
[System.IO.Compression.ZipFile]::ExtractToDirectory("act.zip", "act")

Write-Output "Copying executable to path"
Copy-Item -Path "act\\$actExecutable" -Destination $actExecutable

Write-Output "Done"