@echo off
ROBOCOPY "D:\Automation Engine - Operations" "W:\Automation Engine - Operations"  /DCOPY:DAT /XO /R:2 /W:1 /B /E /Z /MT:52 >> C:\_IT\Robocopy_Logs\AE_Ops_Logs.txt
ROBOCOPY "D:\Automation Engine - Reimbursement" "W:\Automation Engine - Reimbursement"  /DCOPY:DAT /XO /R:2 /W:1 /B /E /Z /MT:52 >> C:\_IT\Robocopy_Logs\AE_Reimbursement_Logs.txt
ROBOCOPY "D:\Automation Engine - Revenue Cycle Management" "W:\Automation Engine - Revenue Cycle Management"  /DCOPY:DAT /XO /R:2 /W:1 /B /E /Z /MT:52 >> C:\_IT\Robocopy_Logs\AE_RCM_Logs.txt
ROBOCOPY "D:\Automation Engine - Specialty" "W:\Automation Engine - Specialty" /DCOPY:DAT /XO /R:2 /W:1 /B /E /Z /MT:52 >> C:\_IT\Robocopy_Logs\AD_Speciality_Logs.txt
ROBOCOPY "D:\Bedford ED Billing" "W:\Bedford ED Billing"  /DCOPY:DAT /XO /R:2 /W:1 /B /E /Z /MT:52 >> C:\_IT\Robocopy_Logs\BED_EDBILL_Logs.txt
ROBOCOPY "D:\Billing Appeals" "W:\Billing Appeals"  /DCOPY:DAT /XO /R:2 /W:1 /B /E /Z /MT:52 >> C:\_IT\Robocopy_Logs\BillingAppeals_Logs.txt
ROBOCOPY "D:\Business Automation" "W:\Business Automation" /DCOPY:DAT /XO /R:2 /W:1 /B /E /Z /MT:52 >> C:\_IT\Robocopy_Logs\BA_Logs.txt
ROBOCOPY "D:\Cash Posting" "W:\Cash Posting" /DCOPY:DAT /XO /R:2 /W:1 /B /E /Z /MT:52 >> C:\_IT\Robocopy_Logs\CashP_Logs.txt