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
        # Read the content of the .csproj file
        $content = Get-Content $file.FullName

        # Check if TreatWarningsAsErrors option is enabled
        $treatWarningsAsErrorsDisabled = $content -match "<TreatWarningsAsErrors>false</TreatWarningsAsErrors>"
        if ($treatWarningsAsErrorsDisabled) {
            Write-Host "TreatWarningsAsErrors option is diabled in $($file.FullName)" -ForegroundColor Red
            $exit_code = 1
            continue
        }
        $treatWarningsAsErrorsEnabled = $content -match "<TreatWarningsAsErrors>true</TreatWarningsAsErrors>"
        if (-not $treatWarningsAsErrorsEnabled) {
            Write-Host "TreatWarningsAsErrors option is not enabled in $($file.FullName)" -ForegroundColor Red
            $exit_code = 1
            continue
        }

        # Check if AnalysisLevel option is enabled
        $analysisLevelEnabled = $content -match "<AnalysisLevel>latest-All</AnalysisLevel>"
        if (-not $analysisLevelEnabled) {
            Write-Host "AnalysisLevel option is not enabled in $($file.FullName)" -ForegroundColor Red
            $exit_code = 1
            continue
        }

        # Check for <NoWarn>
        $noWarnMatch = $content -match "<NoWarn>"
        if ($noWarnMatch) {
            Write-Host "NoWarn option is enabled in $($file.FullName)" -ForegroundColor Red
            $exit_code = 1
            continue
        }

        # Check for <WarningsNotAsErrors>
        $warningsNotAsErrorsEnabled = $content -match "<WarningsNotAsErrors>"
        if ($warningsNotAsErrorsEnabled) {
            Write-Host "WarningsNotAsErrors option is enabled in $($file.FullName)" -ForegroundColor Red
            $exit_code = 1
            continue
        }

        # Check that <WarningLevel> is not set to anything but 4
        $warningLevelIncorrect = $content -match "<WarningLevel>" -and -not $content -match "<WarningLevel>4</WarningLevel>"
        if ($warningLevelIncorrect) {
            Write-Host "WarningLevel not set to 4 $($file.FullName)" -ForegroundColor Red
            $exit_code = 1
            continue
        }

        Write-Host "Everything passing for $($file.FullName)" -ForegroundColor Green
    }
}

exit $exit_code
