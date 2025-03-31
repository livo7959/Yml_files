<#
.SYNOPSIS
Grant SharePoint online site selected permissions through Graph API
.DESCRIPTION
To do
.EXAMPLE
To do
#>

Param(
    [Parameter(Mandatory=$true)]
    [string]$AppId,
    [Parameter(Mandatory=$true)]
    [string]$AppDisplayName,
    [Parameter(Mandatory=$true)]
    [string]$SiteId,
    [Parameter(Mandatory=$true)]
    [string]$Role
)

# Import the Graph API and connect to SharePoint online
Import-Module Microsoft.Graph.Sites

# Connect to Graph API. Note, this assumes you have SharePoint Admin role or full control on the required site

Connect-MgGraph -Scopes Sites.FullControl.All

# Set the body parameters

$BodyParams = @{
	roles = @(
		$Role
	)
	grantedToIdentities = @(
		@{
			application = @{
				id = $AppId
				displayName = $AppDisplayName
			}
		}
	)
}

New-MgSitePermission -SiteId $SiteId -BodyParameter $BodyParams