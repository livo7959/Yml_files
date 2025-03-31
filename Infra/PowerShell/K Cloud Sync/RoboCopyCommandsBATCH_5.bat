@echo off
ROBOCOPY "D:\ICER Production Support" "W:\ICER Production Support"  /DCOPY:DAT /XO /R:2 /W:1 /B /E /Z /MT:52 >> C:\_IT\Robocopy_Logs\ICER_Production_Support.txt
ROBOCOPY "D:\Inbound Faxes - Reimbursement" "W:\Inbound Faxes - Reimbursement"  /DCOPY:DAT /XO /R:2 /W:1 /B /E /Z /MT:52 >> C:\_IT\Robocopy_Logs\Inbound Faxes_Reimbursement.txt
ROBOCOPY "D:\LHICS Outliers" "W:\LHICS Outliers"  /DCOPY:DAT /XO /R:2 /W:1 /B /E /Z /MT:52 >> C:\_IT\Robocopy_Logs\LHICS_Outliers.txt
ROBOCOPY "D:\LogixAutomation Bots" "W:\LogixAutomation Bots" /DCOPY:DAT /XO /R:2 /W:1 /B /E /Z /MT:52 >> C:\_IT\Robocopy_Logs\LogixAutomation_Bots.txt
ROBOCOPY "D:\LogixAutomation Data" "W:\LogixAutomation Data"  /DCOPY:DAT /XO /R:2 /W:1 /B /E /Z /MT:52 >> C:\_IT\Robocopy_Logs\LogixAutomation_Data.txt
ROBOCOPY "D:\LogixHealth Site Content" "W:\LogixHealth Site Content" /DCOPY:DAT /XO /R:2 /W:1 /B /E /Z /MT:52 >> C:\_IT\Robocopy_Logs\LogixHealth_Site_Content.txt
ROBOCOPY "D:\LogixHealth Site Content - Restricted" "W:\LogixHealth Site Content - Restricted"  /DCOPY:DAT /XO /R:2 /W:1 /B /E /Z /MT:52 >> C:\_IT\Robocopy_Logs\LogixHealthSiteContent_Restricted.txt
ROBOCOPY "D:\MedData" "W:\MedData"  /DCOPY:DAT /XO /R:2 /W:1 /B /E /Z /MT:52 >> C:\_IT\Robocopy_Logs\MedData.txt