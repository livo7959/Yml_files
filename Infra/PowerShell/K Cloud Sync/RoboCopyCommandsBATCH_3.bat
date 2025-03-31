@echo off
ROBOCOPY "D:\Charge Entry Logs US-LHI" "W:\Charge Entry Logs US-LHI"  /DCOPY:DAT /XO /R:2 /W:1 /B /E /Z /MT:52 >> C:\_IT\Robocopy_Logs\ChargeEntryLogs_Logs.txt
ROBOCOPY "D:\EDI 835 Raw Files" "W:\EDI 835 Raw Files"  /DCOPY:DAT /XO /R:2 /W:1 /B /E /Z /MT:52 >> C:\_IT\Robocopy_Logs\EDI_835_Logs.txt
ROBOCOPY "D:\EDI Faxes-Batch Basket" "W:\EDI Faxes-Batch Basket" /DCOPY:DAT /XO /R:2 /W:1 /B /E /Z /MT:52 >> C:\_IT\Robocopy_Logs\EDI_Faxes-BatchBasketLogs.txt
ROBOCOPY "D:\EDI Faxes-Unassigned" "W:\EDI Faxes-Unassigned"  /DCOPY:DAT /XO /R:2 /W:1 /B /E /Z /MT:52 >> C:\_IT\Robocopy_Logs\EDI_Faxes-Unassigned.txt
ROBOCOPY "D:\EDI LHI" "W:\EDI LHI" /DCOPY:DAT /XO /R:2 /W:1 /B /E /Z /MT:52 >> C:\_IT\Robocopy_Logs\EDILHI.txt
ROBOCOPY "D:\EDI Rejection Reports" "W:\EDI Rejection Reports"  /DCOPY:DAT /XO /R:2 /W:1 /B /E /Z /MT:52 >> C:\_IT\Robocopy_Logs\EDIRejectionReports.txt