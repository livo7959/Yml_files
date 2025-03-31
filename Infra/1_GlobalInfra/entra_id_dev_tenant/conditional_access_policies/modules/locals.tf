# local variable of Conditional Access Policy information. These will be used to create the conditional access policies, exemption and inclusion groups.
locals {
  ca_policies = {
    "CA100" = {
      name                   = "CA100-GlobalBase-Require-MFA"
      description            = "Require MFA for all users"
      create_inclusion_group = false
    }
    "CA101" = {
      name                   = "CA101-GlobalBase-Block-Untrusted-Locations"
      description            = "Block access from untrusted locations"
      create_inclusion_group = false
    }
    "CA102" = {
      name                   = "CA102-GlobalBase-Block-Legacy-Auth-Protocols"
      description            = "Block legacy authentication protocols"
      create_inclusion_group = false
    }
    "CA103" = {
      name                   = "CA103-GlobalBase-Block-Unknown-Unsupported-Device-Platforms"
      description            = "Block unknown or unsupported device platforms"
      create_inclusion_group = false
    }
    "CA104" = {
      name                   = "CA104-GlobalBase-Require-MFA-Low-Med-Sign-In-Risk"
      description            = "Require MFA for low to medium sign-in risk"
      create_inclusion_group = false
    }
    "CA105" = {
      name                   = "CA105-GlobalBase-Block-High-Sign-In-Risk"
      description            = "Block high sign-in risk"
      create_inclusion_group = false
    }
    "CA106" = {
      name                   = "CA106-GlobalBase-Require-MFA-Low-Med-User-Risk"
      description            = "Require MFA for low to medium user risk"
      create_inclusion_group = false
    }
    "CA107" = {
      name                   = "CA107-GlobalBase-Block-High-User-Risk"
      description            = "Block high user risk"
      create_inclusion_group = false
    }
    "CA200" = {
      name                   = "CA200-Admins-Prevent-Session-Persistence"
      description            = "Prevent session persistence for admins"
      create_inclusion_group = false
    }
    "CA700" = {
      name                   = "CA700-Guests-Require-MFA"
      description            = "Require MFA for guests"
      create_inclusion_group = false
    }
  }
}

# Priviliged Entra ID Role IDs. Found here: https://learn.microsoft.com/en-us/entra/identity/role-based-access-control/permissions-reference

locals {
  global_administrator                   = "62e90394-69f5-4237-9190-012177145e10"
  global_reader                          = "f2ef992c-3afb-46b9-b7cf-a126ee74c451"
  application_administrator              = "9b895d92-2cd3-44c7-9d02-a6ac2d5ea5c3"
  application_developer                  = "cf1c38e5-3621-4004-a7cb-879624dced7c"
  cloud_application_adminstrator         = "158c047a-c907-4556-b7ef-446551a6b5f7"
  cloud_device_administrator             = "7698a772-787b-4ac8-901f-60d6b08affd2"
  conditional_access_administrator       = "b1be1c3e-b65d-4f19-8427-f6fa0d97feb9"
  exchange_administrator                 = "29232cdf-9323-42fd-ade2-1d097af3e4de"
  global_secure_access_administrator     = "ac434307-12b9-4fa1-a708-88bf58caabc1"
  helpdesk_administrator                 = "729827e3-9c14-49f7-bb1b-9608f156bbb8"
  hybrid_identity_adminstrator           = "8ac3fc64-6eca-42ea-9e69-59f4c7b60eb2"
  intune_administrator                   = "3a2c62db-5318-420d-8d74-23affee5d9d5"
  password_administrator                 = "966707d0-3269-4727-9be2-8c3a10f19b9d"
  priviliged_authetication_administrator = "7be44c8a-adaf-4e2a-84d6-ab2649e08a13"
  privileged_role_administrator          = "e8611ab8-c189-46e8-94e1-60213ab1f814"
  security_administrator                 = "194ae4cb-b126-40b2-bd5b-6091b380977d"
  security_operator                      = "5f2222b1-57c3-48ba-8ad5-d4759f1fde6f"
  security_reader                        = "5d6b6bb7-de71-4623-b4af-96380a352509"
  sharepoint_administrator               = "f28a1f50-f6e7-4571-818b-6a12f2af6b6c"
  user_administrator                     = "fe930be7-5e62-47db-91af-98c3a49a38b1"
}
