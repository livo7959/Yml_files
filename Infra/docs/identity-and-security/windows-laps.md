## Introduction

We are using Windows LAPS on our Windows Server OS 2019 and above.
_(Windows LAPS not supported on Windows Server 2016/2012, still uses Legacy LAPS)._

## AD Schema Changes

Change ticket LHT252943 | DevOps task 16020 | done May 7, 2024

### Configuration

- 60 days credential rotation
- 16 characters
- Built-in Administrator account

### Group Policy Objects (GPO)

- Computer – `Windows_LAPS_Servers`
- Computer – `Windows_LAPS_Servers_Privileged_Access_Systems`
- Computer – `Windows_LAPS_AVD`

### Group Policy AD Groups

- `GPO_Legacy_LAPS` – Security filter group for Legacy LAPS GPO (2012/2016). Used to scope the `Windows_LAPS_Servers` at the root and place our servers on 2012/2016 here.
- `GPO_Deny_Windows_LAPS` – Nested `GPO_Legacy_LAPS` (2012/2016)

## OU Permissions

- OU Permissions
  Powershell cmds to set Permissions for servers/computer objects to reset their own password

# Example:

```powershell
Set-LapsADComputerSelfPermission -Identity "OU=Cloud-Datacenters,DC=CORP,DC=LOGIXHEALTH,DC=LOCAL"
```

- Read Permissions to LAPS secrets

# Example:

```powershell
Set-LapsADReadPasswordPermission -Identity "OU=VDI,OU=Azure-EastUS,OU=Cloud-Datacenters,DC=CORP,DC=LOGIXHEALTH,DC=LOCAL" -AllowedPrincipals "LAPS_Azure_VDI"
```

### Authorized decryptors are set in GPO to match read groups

- Read groups and authorized decryptors

1. Corp\LAPS_BED_Servers : OU=Production Datacenter,OU=Datacenters,OU=Bedford,DC=CORP,DC=LOGIXHEALTH,DC=LOCAL
1. Corp\LAPS_BED_Servers : OU=Tier1,OU=Bedford,OU=Datacenters,DC=CORP,DC=LOGIXHEALTH,DC=LOCAL
1. Corp\LAPS_Azure_VDI : OU=VDI,OU=Azure-EastUS,OU=Cloud-Datacenters,DC=CORP,DC=LOGIXHEALTH,DC=LOCAL
1. Corp\Domain Admins : OU=Tier0_Servers,OU=Privileged Access Servers,OU=Privileged Access Systems,DC=CORP,DC=LOGIXHEALTH,DC=LOCAL

# Retrieving Secrets

- GUI: Open up computer object in AD > LAPS Tab

```powershell
Get-LapsADPassword [computer-name] -AsPlainText
```

For Legacy LAPS can continue to use LAPS UI on BEDPMGMT001 or Powershell:

```powershell
Get-AdmPwdPassword [computer-name]
```

## Links

[Overview](https://learn.microsoft.com/en-us/windows-server/identity/laps/laps-overview)

[Configuration](https://learn.microsoft.com/en-us/windows-server/identity/laps/laps-management-policy-settings)

[Powershell Commands - Retrieving Secrets](https://learn.microsoft.com/en-us/windows-server/identity/laps/laps-management-powershell)

[Powershell Commands](https://learn.microsoft.com/en-us/powershell/module/laps/?view=windowsserver2019-ps)

[Migration](https://learn.microsoft.com/en-us/powershell/module/laps/?view=windowsserver2019-ps)

[Troubleshooting](https://learn.microsoft.com/en-us/troubleshoot/windows-server/windows-security/windows-laps-troubleshooting-guidance)
