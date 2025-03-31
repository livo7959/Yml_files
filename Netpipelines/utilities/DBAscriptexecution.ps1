param (
    [string]$ScriptPath, # Specify the directory containing the SQL scripts
    [string]$SpecifiedScripts, # Comma-separated list of script names
    [string]$ServerName, # SQL Server instance name
    [string]$DatabaseName # Name of the database
)

$scripts = $SpecifiedScripts -split ',' | ForEach-Object { Join-Path -Path $ScriptPath -ChildPath $_ }

try {
    foreach ($script in $scripts) {
        Invoke-Sqlcmd -InputFile $script -ServerInstance $ServerName -Database $DatabaseName -MaxCharLength ([int]::MaxValue)
    }
}
catch {
    Write-Error "An error occurred while executing $($script):$_"
}
