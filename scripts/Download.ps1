Param(
    [string] $XmlDocUrl = "https://advancedcombattracker.com/apidoc/Advanced%20Combat%20Tracker.XML",
    [string] $XmlDocFilename = "Advanced Combat Tracker.XML",
    [string] $ArchiveUrl = "https://github.com/EQAditu/AdvancedCombatTracker/releases/download",
    [string] $ZipFile = "ACTv3.zip",
    [string] $Versions = ""
)

if ($Versions -eq $null -or $Versions -eq "") {
    Write-Output "No versions were specified."
    return
}

$versionsToDownload = $Versions.Split()

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$wc = New-Object System.Net.WebClient

Write-Output "Fetching latest XML doc '$XmlDocUrl'"
try {
    $wc.DownloadFile($XmlDocUrl, $XmlDocFilename)
}
catch {
    Write-Error $_.Exception.ToString()
    exit 1
}

Write-Output "Creating versions directory"
$versionDir = "$(Get-Location)\versions" 
Remove-Item $versionDir -Recurse -ErrorAction Ignore
New-Item -ItemType Directory -Path $versionDir | Out-Null

Write-Output "Fetching $($versionsToDownload.Count) executable versions: $versionsToDownload"

foreach ($version in $versionsToDownload) {
    $url = "$ArchiveUrl/$version/$ZipFile"
    $downloadedZipFile = "$versionDir\$version.zip"

    Write-Output "`nDownloading '$url'"

    try {
        $wc.DownloadFile($url, $downloadedZipFile)
    }
    catch {
        Write-Error $_.Exception.ToString()
        exit 1
    }

    $extractedDir = "$versionDir\$version"
    Write-Output "Extracting to '$extractedDir'"

    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::ExtractToDirectory($downloadedZipFile, $extractedDir)

    Write-Output "Copying XML doc"
    Copy-Item -Path $XmlDocFilename -Destination $extractedDir

    Write-Output "Finished fetching version '$version'"
}

Write-Output "Done"