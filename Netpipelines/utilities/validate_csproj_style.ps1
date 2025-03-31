param (
    [string[]]$directoryPaths
)

# Check if directoryPaths is empty
if (-not $directoryPaths) {
    Write-Error "No directory paths provided. Please provide at least one directory path."
    exit 1
}

$exit_code = 0

foreach ($directoryPath in $directoryPaths) {
    # Get all .csproj files in the directory
    $csprojFiles = Get-ChildItem -Path $directoryPath -Filter *.csproj -Recurse

    # Loop through each .csproj file
    foreach ($file in $csprojFiles) {
        $content = Get-Content $file.FullName
        $old_style = $content -match "xmlns=`"http://schemas.microsoft.com/developer/msbuild/2003`""
        if ($old_style) {
            Write-Host "Wrong style for $file" -ForegroundColor Red
            $exit_code = 1
            # Write-Host "dotnet migrate-2019 wizard -n -v diag $file"
        }
    }
}

exit $exit_code
