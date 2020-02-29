Param(
    [string] $XmlDocUrl = "https://advancedcombattracker.com/apidoc/Advanced%20Combat%20Tracker.XML",
    [string] $XmlDocFilename = "Advanced Combat Tracker.XML",
    [string] $ArchiveUrl = "https://github.com/EQAditu/AdvancedCombatTracker/releases/download",
    [string] $ZipFile = "ACTv3.zip",
    [string] $Versions = ""
)

$versionsToDownload = $Versions.Split()

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$wc = New-Object System.Net.WebClient

Write-Output "Fetching latest XML doc '$XmlDocUrl'"
$wc.DownloadFile($XmlDocUrl, $XmlDocFilename)

Write-Output "Creating versions directory"
$versionDir = "$(Get-Location)\versions" 
Remove-Item $versionDir -Recurse -ErrorAction Ignore
New-Item -ItemType Directory -Path $versionDir | Out-Null

Write-Output "Fetching $($versionsToDownload.Count) executable versions: $versionsToDownload"

foreach ($version in $versionsToDownload) {
    $url = "$ArchiveUrl/$version/$ZipFile"
    $downloadedZipFile = "$versionDir\$version.zip"

    Write-Output "`nDownloading '$url'"
    $wc.DownloadFile($url, $downloadedZipFile)

    $extractedDir = "$versionDir\$version"
    Write-Output "Extracting to '$extractedDir'"

    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::ExtractToDirectory($downloadedZipFile, $extractedDir)

    Write-Output "Copying XML doc"
    Copy-Item -Path $XmlDocFilename -Destination $extractedDir

    Write-Output "Finished fetching version '$version'"
}

Write-Output "Done"