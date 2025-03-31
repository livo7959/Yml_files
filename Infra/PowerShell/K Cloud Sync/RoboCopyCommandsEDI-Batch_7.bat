@echo off
robocopy "D:\EDI\_EDI INFORMATION" "W:\EDI_3.0\_EDI INFORMATION" /DCOPY:DAT /XO /R:2 /W:1 /B /E /Z /MT:52 >> C:\_IT\Robocopy_Logs\EDI_informatioon.txt
robocopy "D:\EDI\ARCHIVE for K Drive Cleanup" "W:\EDI_3.0\ARCHIVE for K Drive Cleanup" /DCOPY:DAT /XO /R:2 /W:1 /B /E /Z /MT:52 >> C:\_IT\Robocopy_Logs\EDI_ArchiveKdrive.txt
robocopy "D:\EDI\EZPRINT" "W:\EDI_3.0\EZPRINT" /DCOPY:DAT /XO /R:2 /W:1 /B /E /Z /MT:52 >> C:\_IT\Robocopy_Logs\EDI_EzPrint.txt
robocopy "D:\EDI\LHI RevSpring" "W:\EDI_3.0\LHI RevSpring" /DCOPY:DAT /XO /R:2 /W:1 /B /E /Z /MT:52 >> C:\_IT\Robocopy_Logs\EDI_RevSpring.txt
robocopy "D:\EDI\MED REC REQUESTS - NOT RECEIVED - GLOBAL" "W:\EDI_3.0\MED REC REQUESTS - NOT RECEIVED - GLOBAL" /DCOPY:DAT /XO /R:2 /W:1 /B /E /Z /MT:52 >> C:\_IT\Robocopy_Logs\EDI_not_received.txt
robocopy "D:\EDI\New folder" "W:\EDI_3.0\New folder" /DCOPY:DAT /XO /R:2 /W:1 /B /E /Z /MT:52 >> C:\_IT\Robocopy_Logs\EDI_newfolder.txt
robocopy "D:\EDI\PayerPath EDI ONLY DONT TOUCH" "W:\EDI_3.0\PayerPath EDI ONLY DONT TOUCH" /DCOPY:DAT /XO /R:2 /W:1 /B /E /Z /MT:52 >> C:\_IT\Robocopy_Logs\EDI_PayerPath.txt
robocopy "D:\EDI\REMITS BIDMC & ASSOC PHY AT HMFP &  BIDMC-ST VINCENT" "W:\EDI_3.0\REMITS BIDMC & ASSOC PHY AT HMFP &  BIDMC-ST VINCENT" /DCOPY:DAT /XO /R:2 /W:1 /B /E /Z /MT:52 /xo /DCOPY:DAT >> C:\_IT\Robocopy_Logs\EDI_Remits.txt
robocopy "D:\EDI\REVSPRING FILE RETURNS" "W:\EDI_3.0\REVSPRING FILE RETURNS" /DCOPY:DAT /XO /R:2 /W:1 /B /E /Z /MT:52 >> C:\_IT\Robocopy_Logs\EDI_filereturn_revspring.txt
robocopy "D:\EDI\REMITS 835 AS OF 12-17-12" "W:\EDI_3.0\REMITS 835 AS OF 12-17-12" /DCOPY:DAT /XO /R:2 /W:1 /B /E /Z /MT:52 /DCOPY:DAT >> C:\_IT\Robocopy_Logs\EDI_Logs_Remits.txt
robocopy "D:\EDI\Timely Filing" "W:\EDI_3.0\Timely Filing" /DCOPY:DAT /XO /R:2 /W:1 /B /E /Z /MT:52 >> C:\_IT\Robocopy_Logs\EDI_TimelyFiling.txt