<#
.SYNOPSIS
Requests a certificate from a Windows CA

.DESCRIPTION
Requests a certificates with the specified subject name from am Windows CA and saves the resulting certificate with the private key in the local computer store.

You must specify at least the CN for the subject name.

With the SAN parameter you can also specify values for subject alternative name to request a SAN certificate.
The CA must support this type of certificate otherwise the request will fail.

With the Export parameter it's also possible to export the requested certificate (with private key) directly to a .pfx file instead of storing it in the local computer store.

You can also use the Import-CSV cmdlet with Request-Certificate.ps1 to request multiple certificates.
To do this, use the Import-CSV cmdlet to create custom objects from a comma-separated value (CSV) file that contains a list of object properties (such as CN, SAN etc. ). Then pass these objects through the pipeline to Request-Certificate.ps1 to request the certificates.

.PARAMETER CN
Specifies the common name for the subject of the certificate(s).
Mostly its the FQDN of a website or service.
e.g. test.logixhealth.com

.PARAMETER SAN
Specifies a comma separated list of subject alternate names (FQDNs) for the certificate
The syntax is {tag}={value}.
Valid tags are: email, upn, dns, guid, url, ipaddress, oid
e.g. dns=test.logixhealth.com,email=foo@logixhealth.com

.PARAMETER TemplateName
Specifies the name for the temple of the CA to issue the certificate(s).
The default value is "WebServer".

.PARAMETER KeyLength
Specifies the key length in Bit for the certificate.
Possible Values: 1024,2048,3072,4096,15360
Default Value: 2048

.PARAMETER CAName
Specifies the name of the CA to send the request to in the format FQDN\CAName
If the CAName is not specified, then the directory is queried for a list of enterprise CAs.
If more than one is returned the user is prompted to choose an enterprise CA from the local Active Directory.

.PARAMETER Country
Specifies two letter for the optional country value in the subject of the certificate(s).
e.g. CH

.PARAMETER State
Specifies the optional state value in the subject of the certificate(s).
e.g. Bedford

.PARAMETER City
Specifies the optional city value in the subject of the certificate(s).
e.g. Bedford

.PARAMETER Organization
Specifies the optional organization value in the subject of the certificate(s).
e.g. logixhealth.com

.PARAMETER Department
Specifies the optional department value in the subject of the certificate(s).
e.g. IT

.PARAMETER AddCNinSAN
Specifies the CN will be added to the SAN list if not already provided. This ensures compatibility with
modern browsers.

.PARAMETER Export
Exports the certificate and private key to a pfx file instead of installing it in the local computer store.
By default the certificate will be installed in the local computer store.

.PARAMETER ExportPath
Path to which the pfx file should be saved when -Export is specified.

.PARAMETER Password
Specify the Password (as plain String or SecureString) used on the export.

.INPUTS
System.String
Common name for the subject, SAN , Country, State etc. of the certificate(s) as a string

.OUTPUTS
None. Request-Certificate.ps1 does not generate any output.

.EXAMPLE
C:\PS> .\Request-Certificate.ps1

Description
-----------
This command requests a certificate form the enterprise CA in the local Active Directory.
The user will be asked for the value for the CN of the certificate.

.EXAMPLE
C:\PS> .\Request-Certificate.ps1 -CAName "testsrv.test.ch\Test CA"

Description
-----------
This command requests a certificate form the CA testsrv.test.ch\Test CA.
The user will be asked for the value for the CN of the certificate.

.EXAMPLE
C:\PS> .\Request-Certificate.ps1 -CN "webserver.test.ch" -CAName "testsrv.test.ch\Test CA" -TemplateName "Webservercert"

Description
-----------
This command requests a certificate form the CA testsrv.test.ch\Test CA with the certificate template "Webservercert"
and a CN of webserver.test.ch
The user will be asked for the value for the SAN of the certificate.

.EXAMPLE
Get-Content .\certs.txt | .\Request-Certificate.ps1 -Export

Description
-----------
Gets common names from the file certs.txt and request for each a certificate.
Each certificate will then be saved withe the private key in a .pfx file.

.EXAMPLE
C:\PS> .\Request-Certificate.ps1 -CN "webserver.test.ch" -SAN "DNS=webserver.test.ch,DNS=srvweb.test.local"

Description
-----------
This command requests a certificate with a CN of webserver.test.ch and subject alternative names (SANs)
The SANs of the certificate are the DNS names webserver.test.ch and srvweb.test.local.

.EXAMPLE
C:\PS> Import-Csv .\sancertificates.csv -UseCulture | .\Request-Certificate.ps1 -verbose -Export -CAName "testsrv.test.ch\Test CA"

Description
-----------
This example requests multiple SAN certificates from the "Test CA" CA running on the server "testsrv.test.ch".
The first command creates custom objects from a comma-separated value (CSV) file thats contains a list of object properties. The objects are then passed through the pipeline to Request-Certificate.ps1 to request the certificates form the "J0F3's Issuing CA" CA.
Each certificate will then be saved with the private key in a .pfx file.

The CSV file look something like this:
CN;SAN
test1.test.ch;DNS=test1san1.test.ch,DNS=test1san2.test.ch
test2.test.ch;DNS=test2san1.test.ch,DNS=test2san2.test.ch
test3.test.ch;DNS=test3san1.test.ch,DNS=test3san2.test.ch

.Example
C:\PS>.\Request-Certificate.ps1 -CN "name.logixhealth.com" -SAN "DNS=name.logixhealth.com" -CAName "bedsubca001.logixhealth.local\bedsubca001" -TemplateName 'LOGIX-CORP-WebServer-2Y' -Export -Password "hunter3" -ExportPath .
Description
-----------
This example was created by Nick Ottaviano for LogixHealth. Here we are requesting a certificate from the Issuing CA.
The Template 'LOGIX-CORP-WebServer-4Y' is being used
The Export parameter is triggering the export of the cert to a pfx file using the Password parameter
The ExportPath parameter specifics the current path denoted by "." as the export location, there you will see name.logixhealth.com.pfx

.NOTES

Originally rom: https://www.powershellgallery.com/packages/Request-Certificate/1.5.0/Content/Request-Certificate.ps1

The following changes were made:
- Set LogixHealth default info for org parameters and CA name
- Added LogixHealth specific example
- "AddCNinSAN" parameter was defaulted to true

File Name : Request-Certificate.ps1
Requires : PowerShell V2 or higher

.LINK
© Jonas Feller c/o J0F3, 2019
www.jfe.cloud

#>

[CmdletBinding(DefaultParametersetname="NoExport")]
Param(
    [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [string]$CN,

    [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
    [string[]]$SAN,

    [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
    [String]$TemplateName = "WebServer",

    [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
    [ValidateSet(1024,2048,3072,4096,15360)]
    [int]$keyLength = 2048,

    [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
    [string]$CAName = "bedsubca001.logixhealth.local\bedsubca001",

    [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
    [string]$Country = "US",

    [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
    [string]$State = "Massachusetts",

    [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
    [string]$City = "Bedford",

    [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
    [string]$Organization = "LogixHealth",

    [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
    [string]$Department = "IT",

    # All modern certificates should have a SAN, so we modify the script to default this flag to
    # true.
    [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
    [switch]$AddCNinSAN = $true,

    [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName='Export')]
    [switch]$Export,

    [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, ParameterSetName='Export')]
    [ValidateScript( {Resolve-Path -Path $_})]
    [string]$ExportPath,

    [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, ParameterSetName='Export')]
    [ValidateScript( {$_.getType().name -eq "SecureString" -or $_.getType().name -eq "String"})]
    $Password
)

BEGIN {
  # Check if current user starts with "admin_"
  $currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
  $username = $currentUser.Split('\')[-1]  # Get just the username part, not domain
  $lowercaseUsername = $username.ToLower()

  if (-not $lowercaseUsername.StartsWith("admin_")) {
      throw "This script can only be run by usernames that start with `"admin_`". Current user: $username"
  }

  #internal function to do some cleanup
    function Remove-ReqTempfiles() {
        param(
            [String[]]$tempfiles
        )
        Write-Verbose "Cleanup temp files..."
        Remove-Item -Path $tempfiles -Force -ErrorAction SilentlyContinue
    }

    function Remove-ReqFromStore {
        param(
            [String]$CN
        )
        Write-Verbose "Remove pending certificate request form cert store..."

        #delete pending request (if a request exists for the CN)
        $certstore = new-object system.security.cryptography.x509certificates.x509Store('REQUEST', 'LocalMachine')
        $certstore.Open('ReadWrite')
        foreach ($certreq in $($certstore.Certificates)) {
            if ($certreq.Subject -eq "CN=$CN") {
                $certstore.Remove($certreq)
            }
        }
        $certstore.close()
    }
}

PROCESS {
    #disable debug confirmation messages
    if ($PSBoundParameters['Debug']) {$DebugPreference = "Continue"}

    Write-Verbose "Generating request inf file"
    $file = @"
[NewRequest]
Subject = "CN=$CN,c=$Country, s=$State, l=$City, o=$Organization, ou=$Department"
MachineKeySet = TRUE
KeyLength = $KeyLength
KeySpec=1
Exportable = TRUE
RequestType = PKCS10
ProviderName = "Microsoft Enhanced Cryptographic Provider v1.0"
[RequestAttributes]
CertificateTemplate = "$TemplateName"
"@


    #check if SAN certificate is requested
    if ($PSBoundParameters.ContainsKey('SAN')) {
        #each SAN must be a array element
        #if the array has ony one element then split it on the commas.
        if (($SAN).count -eq 1) {
            $SAN = @($SAN -split ',')
        }
    }

    if ($AddCNinSAN) {
        $SAN = "DNS=$CN" + $SAN #Add CN as first SAN entry
    }

    # Remove Potential duplicates (if CN was already provided in SAN list)
    $SAN = $SAN | Select-Object -Unique


    if ($SAN.Count -gt 0) {

        Write-Host "Requesting SAN certificate with subject $CN and SAN: $($SAN -join ',')" -ForegroundColor Green
        Write-Debug "Parameter values: CN = $CN, TemplateName = $TemplateName, CAName = $CAName, SAN = $($SAN -join ' ')"

        Write-Verbose "A value for the SAN is specified. Requesting a SAN certificate."
        Write-Debug "Add Extension for SAN to the inf file..."
        $file +=
@'

[Extensions]
; If your client operating system is Windows Server 2008, Windows Server 2008 R2, Windows Vista, or Windows 7
; SANs can be included in the Extensions section by using the following text format. Note 2.5.29.17 is the OID for a SAN extension.

2.5.29.17 = "{text}"

'@

        foreach ($an in $SAN) {
            $file += "_continue_ = `"$($an)&`"`n"
        }
    }
    else {
        Write-Host "Requesting certificate with subject $CN" -ForegroundColor Green
        Write-Debug "Parameter values: CN = $CN, TemplateName = $TemplateName, CAName = $CAName"
    }

    Write-Debug "Inf-File: $file"

    try    {
        #create temp files
        $inf = [System.IO.Path]::GetTempFileName()
        $req = [System.IO.Path]::GetTempFileName()
        $filename = $CN -replace "^\*","wildcard"
        $cer = Join-Path -Path $env:TEMP -ChildPath "$filename.cer"
        $rsp = Join-Path -Path $env:TEMP -ChildPath "$filename.rsp"

        Remove-ReqTempfiles -tempfiles $inf, $req, $cer, $rsp

        #write the file to debug logs (if debug enabled)
        Write-Debug $file
        #create new request inf file
        Set-Content -Path $inf -Value $file

        #show inf file if -verbose is used
        Get-Content -Path $inf | Write-Verbose

        Write-Verbose "generate .req file with certreq.exe"
        Invoke-Expression -Command "certreq -new `"$inf`" `"$req`""
        if (!($LastExitCode -eq 0)) {
            throw "certreq -new command failed"
        }

        write-verbose "Sending certificate request to CA"
        Write-Debug "CAName = $CAName"

        if (!$PSBoundParameters.ContainsKey('CAName')) {
            $rootDSE = [System.DirectoryServices.DirectoryEntry]'LDAP://RootDSE'
            $searchBase = [System.DirectoryServices.DirectoryEntry]"LDAP://$($rootDSE.configurationNamingContext)"
            $CAs = [System.DirectoryServices.DirectorySearcher]::new($searchBase,'objectClass=pKIEnrollmentService').FindAll()

            if($CAs.Count -eq 1){
                $CAName = "$($CAs[0].Properties.dnshostname)\$($CAs[0].Properties.cn)"
            }
            else {
                $CAName = ""
            }
        }

        if (!$CAName -eq "") {
            $CAName = " -config `"$CAName`""
        }

        Write-Debug "certreq -submit$CAName `"$req`" `"$cer`""
        Invoke-Expression -Command "certreq -submit$CAName `"$req`" `"$cer`""

        if (!($LastExitCode -eq 0)) {
            throw "certreq -submit command failed"
        }
        Write-Debug "request was successful. Result was saved to `"$cer`""

        write-verbose "retrieve and install the certificate"
        Invoke-Expression -Command "certreq -accept `"$cer`""

        if (!($LastExitCode -eq 0)) {
            throw "certreq -accept command failed"
        }

        if (($LastExitCode -eq 0) -and ($? -eq $true)) {
            Write-Host "Certificate request successfully finished!" -ForegroundColor Green

        }
        else {
            throw "Request failed with unknown error. Try with -verbose -debug parameter"
        }


        if ($export) {
            Write-Debug "export parameter is set. => export certificate"
            Write-Verbose "exporting certificate and private key"
            $cert = Get-Childitem "cert:\LocalMachine\My" | where-object {$_.Thumbprint -eq (New-Object System.Security.Cryptography.X509Certificates.X509Certificate2((Get-Item $cer).FullName, "")).Thumbprint}
            Write-Debug "Certificate found in computer store: $cert"

            #create a pfx export as a byte array
            if($Password) {
                Write-Debug "Exporting with password"
                $certbytes = $cert.export([System.Security.Cryptography.X509Certificates.X509ContentType]::pfx, $Password)
            }  else {
                Write-Debug "Exporting without password"
                $certbytes = $cert.export([System.Security.Cryptography.X509Certificates.X509ContentType]::pfx)
            }


            #write pfx file
            if ($PSBoundParameters.ContainsKey('ExportPath')) {
                $pfxPath = Join-Path -Path (Resolve-Path -Path $ExportPath) -ChildPath "$filename.pfx"
            }
            else {
                $pfxPath = ".\$filename.pfx"
            }
            $certbytes | Set-Content -Encoding Byte -Path $pfxPath -ea Stop
            Write-Host "Certificate successfully exported to `"$pfxPath`"!" -ForegroundColor Green

            Write-Verbose "deleting exported certificate from computer store"
            # delete certificate from computer store
            $certstore = new-object system.security.cryptography.x509certificates.x509Store('My', 'LocalMachine')
            $certstore.Open('ReadWrite')
            $certstore.Remove($cert)
            $certstore.close()

        }
        else {
            Write-Debug "export parameter is not set. => script finished"
            Write-Host "The certificate with the subject $CN is now installed in the computer store !" -ForegroundColor Green
        }
    }
    catch {
        #show error message (non terminating error so that the rest of the pipeline input get processed)
        Write-Error $_
    }
    finally {
        #tempfiles and request cleanup
        Remove-ReqTempfiles -tempfiles $inf, $req, $cer, $rsp
        Remove-ReqFromStore -CN $CN
    }
}

END {
    Remove-ReqTempfiles -tempfiles $inf, $req, $cer, $rsp
}
