
# Create hashtable array to store gMSA parameters
$gmsaParameters = @{
    Name = "gmsa_serviceName"
    DNSHostName = "gmsa_sericeName.corp.logixheath.local"
    KerberosEncryptionType = "AES256"
    PrincipalsAllowedToRetrieveManagedPassword = "Server1$,Server_Group_1"
    Description = "gMSA Description"
    Path = "OU=Managed SA,OU=Service Accounts,OU=_IT Administration,DC=CORP,DC=LOGIXHEALTH,DC=LOCAL"
}

# Create gMSA
New-ADServiceAccount @gmsaParameters

schtasks /change /TN \TaskPath\TaskName /RU Corp\gmsa_serviceName$ /RP
