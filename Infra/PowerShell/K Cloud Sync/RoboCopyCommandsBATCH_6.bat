@echo off
CALL ROBOCOPY "D:\Medical_Records_Administration" "W:\Medical_Records_Administration"  /DCOPY:DAT /XO /R:2 /W:1 /B /E /Z /MT:52 >> C:\_IT\Robocopy_Logs\Medical_Records_Administration.txt
CALL ROBOCOPY "D:\OIG GSA Reports" "W:\OIG GSA Reports"  /DCOPY:DAT /XO /R:2 /W:1 /B /E /Z /MT:52 >> C:\_IT\Robocopy_Logs\OIG_GSA_Reports.txt
CALL ROBOCOPY "D:\Onboarding Job Application Template" "W:\Onboarding Job Application Template" /DCOPY:DAT /XO /R:2 /W:1 /B /E /Z /MT:52 >> C:\_IT\Robocopy_Logs\Onboarding_Job_Application_Template.txt
CALL ROBOCOPY "D:\Onboarding Job Applications" "W:\Onboarding Job Applications" /DCOPY:DAT /XO /R:2 /W:1 /B /E /Z /MT:52 >> C:\_IT\Robocopy_Logs\OnboardingJobApplications.txt
CALL ROBOCOPY "D:\Operations" "W:\Operations"  /DCOPY:DAT /XO /R:2 /W:1 /B /E /Z /MT:52 >> C:\_IT\Robocopy_Logs\Operations.txt
CALL ROBOCOPY "D:\OPS" "W:\OPS" /DCOPY:DAT /XO /R:2 /W:1 /B /E /Z /MT:52 >> C:\_IT\Robocopy_Logs\OPS.txt
CALL ROBOCOPY "D:\Partners Audit" "W:\Partners Audit" /DCOPY:DAT /XO /R:2 /W:1 /B /E /Z /MT:52 >> C:\_IT\Robocopy_Logs\Partners_Audit.txt
CALL ROBOCOPY "D:\PAYERPATH" "W:\PAYERPATH"  /DCOPY:DAT /XO /R:2 /W:1 /B /E /Z /MT:52 >> C:\_IT\Robocopy_Logs\PAYERPATH.txt
CALL ROBOCOPY "D:\Regal" "W:\Regal" /DCOPY:DAT /XO /R:2 /W:1 /B /E /Z /MT:52 >> C:\_IT\Robocopy_Logs\Regal.txt
CALL ROBOCOPY "D:\Revenue Integrity" "W:\Revenue Integrity"  /DCOPY:DAT /XO /R:2 /W:1 /B /E /Z /MT:52 >> C:\_IT\Robocopy_Logs\Revenue_Integrity.txt
CALL ROBOCOPY "D:\Specialty Global Folder" "W:\Specialty Global Folder" /DCOPY:DAT /XO /R:2 /W:1 /B /E /Z /MT:52 >> C:\_IT\Robocopy_Logs\SpecialtyGlobalFolder.txt
CALL ROBOCOPY "D:\Talent Transformation" "W:\Talent Transformation" /DCOPY:DAT /XO /R:2 /W:1 /B /E /Z /MT:52 >> C:\_IT\Robocopy_Logs\Talent_Transformation.txt
CALL ROBOCOPY "D:\WebAppResources" "W:\WebAppResources"  /DCOPY:DAT /XO /R:2 /W:1 /B /E /Z /MT:52 >> C:\_IT\Robocopy_Logs\WebAppResources.txt