#Import CSV file - point to file location 
$gmsaaccounts = Import-csv C:\_IT\gmsa_bulk.csv

#CSV headers and gmsa inputs
#name	     DNSHostName	                    KerberosEncryptionType	PrincipalsAllowedToRetrieveManagedPassword	Description	Path
#gmsa_test	 gmsa_test.corp.logixheath.local    AES256	                BEDITEST030$	                            Test GMSA	OU=Managed SA,OU=Service Accounts,OU=_IT Administration,DC=CORP,DC=LOGIXHEALTH,DC=LOCAL
#gmsa_test1	 gmsa_test1.corp.logixheath.local   AES256	                BEDITEST031$	                            Test GMSA	OU=Managed SA,OU=Service Accounts,OU=_IT Administration,DC=CORP,DC=LOGIXHEALTH,DC=LOCAL
 
#Loop through each row containing gmsa details in the CSV file 
foreach ($gmsa in $gmsaaccounts)
{
#Defined Variables
$Name = $gmsa.Name
$DNSHostName = $gmsa.DNSHostName
$KerberosEncryptionType = $gmsa.KerberosEncryptionType
$PrincipalsAllowedToRetrieveManagedPassword = $gmsa.PrincipalsAllowedToRetrieveManagedPassword
$Description = $gmsa.Description
$Path = $gmsa.Path

#Account will be created from the CSV file
New-ADServiceAccount `
-Name "$name" `
-DNSHostName "$DNSHostName" `
-KerberosEncryptionType "$KerberosEncryptionType" `
-PrincipalsAllowedToRetrieveManagedPassword "$PrincipalsAllowedToRetrieveManagedPassword" `
-Description "$Description" `
-Path "$Path" `

Write-output "The following GMSA account has been created: $name"
Get-ADServiceAccount -identity $Name -Properties PrincipalsAllowedToRetrieveManagedPassword
}

