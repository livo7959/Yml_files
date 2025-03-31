# RunBatchFiles.ps1

# Specify the path to your batch files
$batchFilesPath = "C:\_IT\Scripts"

# List of batch files (replace with your actual batch file names)
$batchFileList = @(
    "RoboCopyCommandsBATCH_1",
    "RoboCopyCommandsBATCH_2",
    "RoboCopyCommandsBATCH_3"
    "RoboCopyCommandsBATCH_4",
    "RoboCopyCommandsBATCH_5"
    "RoboCopyCommandsBATCH_6",
    "RoboCopyCommandsEDI-Batch_7"
)

# Loop through the list of batch files and execute them
foreach ($batchFile in $batchFileList) {
    $batchFilePath = Join-Path -Path $batchFilesPath -ChildPath $batchFile
    Start-Process -FilePath $batchFilePath
}
