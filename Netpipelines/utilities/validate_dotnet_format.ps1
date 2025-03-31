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
        $parameters = @{
            ScriptBlock  = {
                Param ($param_filepath)
                dotnet format $param_filepath --verify-no-changes
                return $?
            }
            ArgumentList = "$($file.FullName)"
        }
        $success = Invoke-Command @parameters
        if (-not $success) {
            $exit_code = 1
            Write-Host "Format validation failed for $($file.FullName)" -ForegroundColor Red
        }
    }
}

exit $exit_code
