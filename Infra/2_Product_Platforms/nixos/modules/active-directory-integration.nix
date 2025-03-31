# TODO: This does not work, needs further troubleshooting.

{ ... }:

{
  users.ldap = {
    enable = true;
    base = "OU=IT Department,OU=Server Access Accounts,OU=_IT Administration,DC=CORP,DC=LOGIXHEALTH,DC=LOCAL";
    server = "ldap://BEDPCORPDC001.corp.logixhealth.local/";
    useTLS = true;
    bind.distinguishedName = "CN=svc_ad_bind,OU=IT Department,OU=Service Accounts,OU=_IT Administration,DC=CORP,DC=LOGIXHEALTH,DC=LOCAL";
  };

  users.ldap.daemon.enable = true;

  users.ldap.daemon.extraConfig = ''
    ignorecase yes

    base group OU=IT Department,OU=Server Access Accounts,OU=_IT Administration,DC=CORP,DC=LOGIXHEALTH,DC=LOCAL

    map group gidNumber objectSid:15085
    map passwd uid sAMAccountName
    map passwd uidNumber objectSid:15085
    map passwd gidNumber "100"
    map passwd homedirectory "/home/$sAMAccountName"
    map passwd loginshell "/run/current-system/sw/bin/bash"
    map passwd gecos displayName
    map shadow uid sAMAccountName

    tls_reqcert demand
    tls_cacertfile /etc/ssl/certs/ca-certificates.crt
  '';

  security.pam.services.sshd.makeHomeDir = true;
}
