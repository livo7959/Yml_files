@echo off
ROBOCOPY "D:\835 Parser Program" "W:\835 Parser Program" /DCOPY:DAT /XO /R:2 /W:1 /B /E /Z /MT:52 >> C:\_IT\Robocopy_Logs\835ParserProgram.txt
ROBOCOPY "D:\ARCHIVED-5010" "W:\ARCHIVED-5010" /DCOPY:DAT /XO /R:2 /W:1 /B /E /Z /MT:52 >> C:\_IT\Robocopy_Logs\ARCHIVED-5010.txt
ROBOCOPY "D:\Automation Anywhere" "W:\Automation Anywhere" /DCOPY:DAT /XO /R:2 /W:1 /B /E /Z /MT:52>> C:\_IT\Robocopy_Logs\Automation_Any_Logs.txt
ROBOCOPY "D:\Automation Engine - Charge Entry" "W:\Automation Engine - Charge Entry" /DCOPY:DAT /XO /R:2 /W:1 /B /E /Z /MT:52 >> C:\_IT\Robocopy_Logs\AutoEng_Logs.txt
ROBOCOPY "D:\Automation Engine - Coding Quality" "W:\Automation Engine - Coding Quality"  /DCOPY:DAT /XO /R:2 /W:1 /B /E /Z /MT:52 >> C:\_IT\Robocopy_Logs\AutoE_CQ_Logs.txt
ROBOCOPY "D:\Automation Engine - EDI" "W:\Automation Engine - EDI"  /DCOPY:DAT /XO /R:2 /W:1 /B /E /Z /MT:52 >> C:\_IT\Robocopy_Logs\AE_EDI_Logs.txt
ROBOCOPY "D:\Automation Engine - Medical Records Administration" "W:\Automation Engine - Medical Records Administration" /MT:52 /DCOPY:DAT /XO /R:2 /W:1 /B /E /Z >> C:\_IT\Robocopy_Logs\AE_MRA_Logs.txt