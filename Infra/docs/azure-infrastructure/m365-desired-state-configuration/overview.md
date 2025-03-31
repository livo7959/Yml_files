# Desired State Configuration

# What is Desired State Configuration (DSC)

Desired State Configuration (DSC) is a management platform in PowerShell that allows you to manage your IT and development infrastructure using configuration as code.

# Prerequisites

1. PowerShell version:
   Microsoft365DSC is supported for PowerShell version 5.1 and 7.3+. For additional details on how to leverage it with PowerShell 7, please refer to our [PowerShell 7+ Guide for Microsoft365DSC](https://microsoft365dsc.com/user-guide/get-started/powershell7-support/).
1. PowerShell Execution Policy
   If you encounter issues while loading scripts, set it to Unrestricted:

   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
   ```

1. Windows Remote Management (WinRM)
   Microsoft365DSC uses the Local Configuration Manager (LCM). This requires PowerShell Remoting to be enabled. Please run either:

   ```powershell
   winrm quickconfig -force

   Enable-PSRemoting -Force -SkipNetworkProfileCheck
   ```

# How to setup a local development environment?

**IMPORTANT: The commands below need to be run as as elevated (run as admin) PowerShell 5.1 console or dependencies may not be properly configured.**

```powershell
Install-Module Microsoft365DSC -Scope AllUsers

Update-Microsoft365DSCDependencies

Run the following, incase the above fails and incase of any warnings:

Update-M365DSCDependencies -Force

Update-M365DSCDependencies
```

PowerShell 7 is supported after the initial install but [requires additional configuration.](https://microsoft365dsc.com/user-guide/get-started/powershell7-support/)
