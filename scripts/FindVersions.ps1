Param(
    [string] $ReleasesApiUrl = "https://api.github.com/repos/EQAditu/AdvancedCombatTracker/releases",
    [string] $NugetApiUrl = "https://api.nuget.org/v3-flatcontainer/AdvancedCombatTracker/index.json"
)

Write-Output "Looking up releases at '$ReleasesApiUrl'"
$releases = Invoke-WebRequest $ReleasesApiUrl | ConvertFrom-Json 
$availableVersions = $releases | Select-Object -ExpandProperty tag_name
Write-Output "Found $($availableVersions.Count) releases."

Write-Output "Looking up nuget package versions at '$NugetApiUrl'"
$publishedVersions = (Invoke-WebRequest $NugetApiUrl | ConvertFrom-Json).versions
Write-Output "Found $($publishedVersions.Count) nuget package versions."

Write-Output "Computing release versions without a nuget package..."
$diff = $availableVersions | Where-Object {$publishedVersions -NotContains $_}
if ($diff.Count -eq 0) {
    Write-Output "All release versions have a nuget package."
    return
}

Write-Output "Found $($diff.count) release versions without a nuget package: $diff"
Write-Output "##vso[task.setvariable variable=versionsToPublish]$diff"