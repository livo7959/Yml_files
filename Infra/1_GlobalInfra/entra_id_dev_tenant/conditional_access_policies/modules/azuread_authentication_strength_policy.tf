resource "azuread_authentication_strength_policy" "internal_user_supported_mfa" {
  display_name = "Internal User Supported MFA"
  description  = "Supported authentication methods for internal users"
  allowed_combinations = [
    "fido2",
    "deviceBasedPush",
    "temporaryAccessPassOneTime",
    "temporaryAccessPassMultiUse",
    "federatedMultiFactor",
    "federatedSingleFactor",
    "hardwareOath,federatedSingleFactor",
    "microsoftAuthenticatorPush,federatedSingleFactor",
    "password,hardwareOath",
    "password,microsoftAuthenticatorPush",
    "password,softwareOath",
    "softwareOath,federatedSingleFactor",
    "temporaryAccessPassMultiUse",
    "windowsHelloForBusiness",
    "x509CertificateSingleFactor",
  ]
}
