Param(
    [string] $Versions = "",
    [string] $OutputDirectory = "."
)

$versionsToPack = $Versions.Split()
$versionDir = "$(Get-Location)\versions" 

foreach ($version in $versionsToPack) {
    $dir = "$versionDir\$version"

    ./nuget.exe pack -BasePath $dir -Version $version -OutputDirectory $OutputDirectory -Properties "ActVersion=$version"
}