Key points to build for the script

Catalog

- Allow usage of existing catalogs
- If creating a new catalog check if one already exists with the same name. If one exists throw a warning and write log, exit the script with Error "Existing catalog found with object id (object if of catalog). To use the existing catalog supply the object id into the -ExistingCatalogID parameter.
- If one doesn't exist create the new catalog into a variable for later use.

Access Package

Idempotency

- We should be able to support updating and creating new packages.
- Test if catalogs and access packages already exist, if so run update commandlets, else run creation commandlets
-

External References

- https://dev.to/arindam0310018/automate-entitlement-management-in-azure-ad-identity-governance-using-microsoft-graph-powershell-42k
- https://learn.microsoft.com/en-us/entra/id-governance/entitlement-management-access-package-create-app
- https://learn.microsoft.com/en-us/graph/tutorial-access-package-api?toc=%2Fentra%2Fid-governance%2Ftoc.json&bc=%2Fentra%2Fid-governance%2Fbreadcrumb%2Ftoc.json&tabs=powershell

# Current Error

New-MgEntitlementManagementResourceRequest_Create: C:\git\infrastructure\0_Global_Library\powershell-scripts\Entitlement-Management\Create-AccessPackageV2.ps1:110:9
Line |
110 | New-MgEntitlementManagementResourceRequest -BodyParameter $Re …
| ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
| The caller is not the resource owner. Status: 400 (BadRequest) ErrorCode: CallerNotResourceOwner Date: 2024-10-22T20:23:18 Headers: Location
| : https://igaelm-asev3-ecapi-cus.igaelm-asev3-environment-cus.p.azurewebsites.net/api/v1/resourceRequests Vary :
| Accept-Encoding Strict-Transport-Security : max-age=31536000 request-id : 0f9321c6-49e1-4ea6-b35a-b7bcde5c881c
| client-request-id : 522256b5-a877-4955-b9d3-9b7f68527256 x-ms-ags-diagnostic : {"ServerInfo":{"DataCenter":"Canada
| East","Slice":"E","Ring":"3","ScaleUnit":"002","RoleInstance":"QB1PEPF0000578A"}} Date : Tue, 22 Oct 2024 20:23:17 GMT
Resource Type: AdApplication, Resource ID: 8890563f-5fca-4274-a0c3-b36d55773dc6
New-MgEntitlementManagementResourceRequest_Create: C:\git\infrastructure\0_Global_Library\powershell-scripts\Entitlement-Management\Create-AccessPackageV2.ps1:110:9
Line |
110 | New-MgEntitlementManagementResourceRequest -BodyParameter $Re …
| ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
| Requested value 'AdApplication' was not found. Status: 400 (BadRequest) ErrorCode: ArgumentException Date: 2024-10-22T20:23:18 Headers: Location
| : https://igaelm-asev3-ecapi-cus.igaelm-asev3-environment-cus.p.azurewebsites.net/api/v1/resourceRequests Vary :
| Accept-Encoding Strict-Transport-Security : max-age=31536000 request-id : c826f304-e44d-4265-a03a-9a65819398a9
| client-request-id : f2e9df7a-2a31-4549-b3b1-f1023c6ed443 x-ms-ags-diagnostic : {"ServerInfo":{"DataCenter":"Canada
| East","Slice":"E","Ring":"3","ScaleUnit":"002","RoleInstance":"QB1PEPF0000578A"}} Date : Tue, 22 Oct 2024 20:23:18 GMT
New-MgEntitlementManagementAccessPackage: C:\git\infrastructure\0_Global_Library\powershell-scripts\Entitlement-Management\Create-AccessPackageV2.ps1:141:91
Line |
141 | … ementAccessPackage -DisplayName $AccessPackageName -CatalogId $Catalo …
| ~~~~~~~~~~
| A parameter cannot be found that matches parameter name 'CatalogId'.
Get-MgEntitlementManagementCatalogResourceRole_List: C:\git\infrastructure\0_Global_Library\powershell-scripts\Entitlement-Management\Create-AccessPackageV2.ps1:153:5
Line |
153 | $ResourceRole = Get-MgEntitlementManagementCatalogResourceRole -A …
| ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
| The resource was not found. Status: 404 (NotFound) ErrorCode: ResourceNotFound Date: 2024-10-22T20:23:19 Headers: Vary :
| Accept-Encoding Strict-Transport-Security : max-age=31536000 request-id : ace3b2cd-2b37-4d65-a90d-076837076ce8
| client-request-id : fe1b3001-36d6-474b-b4b1-3333145b1206 x-ms-ags-diagnostic : {"ServerInfo":{"DataCenter":"Canada
| East","Slice":"E","Ring":"3","ScaleUnit":"002","RoleInstance":"QB1PEPF0000578A"}} Date : Tue, 22 Oct 2024 20:23:19 GMT
Get-MgEntitlementManagementCatalogResourceRole_List: C:\git\infrastructure\0_Global_Library\powershell-scripts\Entitlement-Management\Create-AccessPackageV2.ps1:153:5
Line |
153 | $ResourceRole = Get-MgEntitlementManagementCatalogResourceRole -A …
| ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
| OData query is invalid: Guid should contain 32 digits with 4 dashes (xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx).. Status: 400 (BadRequest) ErrorCode:
| InvalidFilter Date: 2024-10-22T20:23:20 Headers: Vary : Accept-Encoding Strict-Transport-Security : max-age=31536000
| request-id : 9451935b-c8aa-490a-b2fe-4541ff28ae97 client-request-id : 04619859-c681-447d-9379-99788db63e7f
| x-ms-ags-diagnostic : {"ServerInfo":{"DataCenter":"Canada East","Slice":"E","Ring":"3","ScaleUnit":"002","RoleInstance":"QB1PEPF0000578A"}}
| Date : Tue, 22 Oct 2024 20:23:20 GMT
Get-MgEntitlementManagementCatalogResourceRole_List: C:\git\infrastructure\0_Global_Library\powershell-scripts\Entitlement-Management\Create-AccessPackageV2.ps1:153:5
Line |
153 | $ResourceRole = Get-MgEntitlementManagementCatalogResourceRole -A …
| ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
| The resource was not found. Status: 404 (NotFound) ErrorCode: ResourceNotFound Date: 2024-10-22T20:23:22 Headers: Vary :
| Accept-Encoding Strict-Transport-Security : max-age=31536000 request-id : cacb5746-c1bf-4681-9cf1-49939da02090
| client-request-id : 89fdab97-ff13-4dab-b381-33f93abb0518 x-ms-ags-diagnostic : {"ServerInfo":{"DataCenter":"Canada
| East","Slice":"E","Ring":"3","ScaleUnit":"002","RoleInstance":"QB1PEPF0000578A"}} Date : Tue, 22 Oct 2024 20:23:22 GMT

infrastructure> $Resources = @(

> >     @{Type="AadGroup"; Id="301bbb5a-08a7-4247-9886-637746705979"},
> >     @{Type="SharePointOnline"; Id="https://logixhealthinc.sharepoint.com/sites/LHInfrastructure451-PKIProject"},
> >     @{Type="AadApplication"; Id="8890563f-5fca-4274-a0c3-b36d55773dc6"}
> >
> > )
> >
> > infrastructure> .\0_Global_Library\powershell-scripts\Entitlement-Management\Create-AccessPackageV2.ps1 -CatalogName "Script Test Catalog 01" -AccessPackageName "Script Test Package 01" -PolicyName "Script Test Policy 01" -Resources $Resources
> > Resource Type: AadGroup, Resource ID: 301bbb5a-08a7-4247-9886-637746705979
> > New-MgEntitlementManagementResourceRequest_Create: C:\git\infrastructure\0_Global_Library\powershell-scripts\Entitlement-Management\Create-AccessPackageV2.ps1:110:9
> > Line |
> > 110 | New-MgEntitlementManagementResourceRequest -BodyParameter $Re …

     |          ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     | The specified resource is already onboarded to ELM.  Status: 400 (BadRequest) ErrorCode: ResourceAlreadyOnboarded Date: 2024-10-22T20:23:42  Headers:
     | Location                      : https://igaelm-asev3-ecapi-cus.igaelm-asev3-environment-cus.p.azurewebsites.net/api/v1/resourceRequests Vary
     | : Accept-Encoding Strict-Transport-Security     : max-age=31536000 request-id                    : b18546fa-085d-4384-898d-773261f10808
     | client-request-id             : 75925ffa-e399-4afe-9747-93a52f0b8b84 x-ms-ags-diagnostic           : {"ServerInfo":{"DataCenter":"Canada
     | East","Slice":"E","Ring":"3","ScaleUnit":"002","RoleInstance":"QB1PEPF0000578A"}} Date                          : Tue, 22 Oct 2024 20:23:42 GMT

Resource Type: SharePointOnline, Resource ID: https://logixhealthinc.sharepoint.com/sites/LHInfrastructure451-PKIProject
New-MgEntitlementManagementResourceRequest_Create: C:\git\infrastructure\0_Global_Library\powershell-scripts\Entitlement-Management\Create-AccessPackageV2.ps1:110:9
Line |
110 | New-MgEntitlementManagementResourceRequest -BodyParameter $Re …
| ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
| The caller is not the resource owner. Status: 400 (BadRequest) ErrorCode: CallerNotResourceOwner Date: 2024-10-22T20:23:45 Headers: Location
| : https://igaelm-asev3-ecapi-cus.igaelm-asev3-environment-cus.p.azurewebsites.net/api/v1/resourceRequests Vary :
| Accept-Encoding Strict-Transport-Security : max-age=31536000 request-id : 005d5874-707f-4df5-ad5b-2c1100b63c0b
| client-request-id : 77d36f40-6e9a-4230-bc81-ad8cccbfdb20 x-ms-ags-diagnostic : {"ServerInfo":{"DataCenter":"Canada
| East","Slice":"E","Ring":"3","ScaleUnit":"002","RoleInstance":"QB1PEPF0000578A"}} Date : Tue, 22 Oct 2024 20:23:45 GMT
Resource Type: AadApplication, Resource ID: 8890563f-5fca-4274-a0c3-b36d55773dc6
New-MgEntitlementManagementResourceRequest_Create: C:\git\infrastructure\0_Global_Library\powershell-scripts\Entitlement-Management\Create-AccessPackageV2.ps1:110:9
Line |
110 | New-MgEntitlementManagementResourceRequest -BodyParameter $Re …
| ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
| The caller is not the resource owner. Status: 400 (BadRequest) ErrorCode: CallerNotResourceOwner Date: 2024-10-22T20:23:46 Headers: Location
| : https://igaelm-asev3-ecapi-cus.igaelm-asev3-environment-cus.p.azurewebsites.net/api/v1/resourceRequests Vary :
| Accept-Encoding Strict-Transport-Security : max-age=31536000 request-id : 9e6ed5ef-a888-4dae-a878-ca2ccde93071
| client-request-id : d5a5d038-0ef1-479e-8fa9-350fe0aa4594 x-ms-ags-diagnostic : {"ServerInfo":{"DataCenter":"Canada
| East","Slice":"E","Ring":"3","ScaleUnit":"002","RoleInstance":"QB1PEPF0000578A"}} Date : Tue, 22 Oct 2024 20:23:46 GMT
New-MgEntitlementManagementAccessPackage: C:\git\infrastructure\0_Global_Library\powershell-scripts\Entitlement-Management\Create-AccessPackageV2.ps1:141:91
Line |
141 | … ementAccessPackage -DisplayName $AccessPackageName -CatalogId $Catalo …
| ~~~~~~~~~~
| A parameter cannot be found that matches parameter name 'CatalogId'.
Get-MgEntitlementManagementCatalogResourceRole_List: C:\git\infrastructure\0_Global_Library\powershell-scripts\Entitlement-Management\Create-AccessPackageV2.ps1:153:5
Line |
153 | $ResourceRole = Get-MgEntitlementManagementCatalogResourceRole -A …
| ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
| The resource was not found. Status: 404 (NotFound) ErrorCode: ResourceNotFound Date: 2024-10-22T20:23:47 Headers: Vary :
| Accept-Encoding Strict-Transport-Security : max-age=31536000 request-id : 53f3cbed-af2d-432c-9253-5e0c120fe17d
| client-request-id : 387c1aab-02a6-4531-bd81-116ea76c6636 x-ms-ags-diagnostic : {"ServerInfo":{"DataCenter":"Canada
| East","Slice":"E","Ring":"3","ScaleUnit":"002","RoleInstance":"QB1PEPF0000578A"}} Date : Tue, 22 Oct 2024 20:23:47 GMT
Get-MgEntitlementManagementCatalogResourceRole_List: C:\git\infrastructure\0_Global_Library\powershell-scripts\Entitlement-Management\Create-AccessPackageV2.ps1:153:5
Line |
153 | $ResourceRole = Get-MgEntitlementManagementCatalogResourceRole -A …
| ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
| OData query is invalid: Guid should contain 32 digits with 4 dashes (xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx).. Status: 400 (BadRequest) ErrorCode:
| InvalidFilter Date: 2024-10-22T20:23:49 Headers: Vary : Accept-Encoding Strict-Transport-Security : max-age=31536000
| request-id : b3a356d1-44e6-4084-a4ef-cf10b418e871 client-request-id : c45fe832-d3db-4612-9184-df5d16f0bc37
| x-ms-ags-diagnostic : {"ServerInfo":{"DataCenter":"Canada East","Slice":"E","Ring":"3","ScaleUnit":"002","RoleInstance":"QB1PEPF0000578A"}}
| Date : Tue, 22 Oct 2024 20:23:48 GMT
Get-MgEntitlementManagementCatalogResourceRole_List: C:\git\infrastructure\0_Global_Library\powershell-scripts\Entitlement-Management\Create-AccessPackageV2.ps1:153:5
Line |
153 | $ResourceRole = Get-MgEntitlementManagementCatalogResourceRole -A …
| ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
| The resource was not found. Status: 404 (NotFound) ErrorCode: ResourceNotFound Date: 2024-10-22T20:23:50 Headers: Vary :
| Accept-Encoding Strict-Transport-Security : max-age=31536000 request-id : 10c33440-7f8b-4908-b891-a2aa08482a23
| client-request-id : a18d2ca4-c347-48f2-9ae0-34eb68d99ea9 x-ms-ags-diagnostic : {"ServerInfo":{"DataCenter":"Canada
| East","Slice":"E","Ring":"3","ScaleUnit":"002","RoleInstance":"QB1PEPF0000578A"}} Date : Tue, 22 Oct 2024 20:23:49 GMT
infrastructure>
