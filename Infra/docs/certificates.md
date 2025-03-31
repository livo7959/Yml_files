# Certificates

This page is about [certificates](https://en.wikipedia.org/wiki/Public_key_certificate) and [Transport Layer Security (TLS)](https://en.wikipedia.org/wiki/Transport_Layer_Security).

- As a user, you might have to deal with untrusted certificates (due to TLS termination, explained below).
- As an admin, you might have to create or update existing certificates using our company's certificate authority.

## TLS Termination

Most websites today use [HTTPS](https://en.wikipedia.org/wiki/HTTPS). This means that they have [a website certificate](https://en.wikipedia.org/wiki/Public_key_certificate) and use [TLS](https://en.wikipedia.org/wiki/Transport_Layer_Security) to encrypt all traffic that goes back and forth.

At LogixHealth, network traffic that leaves the company's network goes through the egress firewall, which is a [Palo Alto](https://www.paloaltonetworks.com/) device. However, in most cases, this firewall does not simply let the traffic through - it terminates all outgoing TLS connections and re-creates them using its own certificate.

For example, on a "normal" network, surfing to google.com will result in a certificate signed by "WR2". But when on the LogixHealth internal network, surfing to google.com will result in a certificate signed by "bednwfw.logixhealth.com".

The point of having a fancy firewall that does this is so that we can decrypt most outgoing internet traffic, ensuring that we have visibility of the network for compliance and security reasons. TLS termination is pretty standard in most medium-to-large businesses.

However, TLS termination can lead to various problems and complications, which the rest of this page will go over.

## Certificate Distribution

By default, computers will trust [the 147 root certificate authorities](https://en.wikipedia.org/wiki/Certificate_authority#Providers). Since the LogixHealth certificate authority is not one of them, we must distribute the company's root CA certificate to all of the computers in the company and configure them to trust it. (Otherwise, internal websites would show up as "untrusted" because they are directly signed by our company's CA, and external websites would show up as "untrusted" because of TLS termination.)

### Manual

If you need to download a certificate manually, you can easily grab them from our [internal certs website](https://certs.logixhealth.com). This website contains both the root certificate authority certificate and the intermediate certificate authority certificate. However, for most cases, you will probably only need the root CA cert, because once you trust the root CA, you implicitly also trust the intermediate CA.

### Windows

Windows has an internal certificate store. You can browse the certificates in it by using the "Certificates" MMC snap-in. (This is the same thing as Start --> Run --> "certmgr.msc".)

At LogixHealth, we have set up our domain policy such that our certificates are automatically added to the internal certificate store as soon as a computer is joined to the domain. Thus, since most of the computers in the company are Windows computers that are joined to the domain, most certificate distribution is handled without having to do anything special.

Once a certificate is in the internal certificate store, browsers like Edge and Chrome will automatically use it when evaluating if a website is trusted or not.

### Linux

Linux servers are not typically joined to the domain, so they need to have the company certificate installed manually. (See the [section above](#manual) for manually downloading the certificate.)

Once you have the root CA certificate on the system, you need to install it. The specific installation method will depend on the Linux distribution that you are using. For example, on Ubuntu, you would copy the root CA certificate to the "/usr/local/share/ca-certificates/" directory and then run the `update-ca-certificates` command.

### Node.js

[Node.js](https://nodejs.org/en) is the most common JavaScript runtime. One quirk about Node.js is that it does not use the internal Windows certificate store. Thus, if you run any JavaScript/TypeScript programs on your computer, you might get errors related to untrusted certificates, even when surfing to the same URLs in Chrome results in a normal webpage without any errors!

The fix to this is to set the "NODE_EXTRA_CA_CERTS" environment variable to the path of the root CA certificate on your computer. (See the [section above](#manual) for manually downloading the certificate.)

### Azure CLI (az)

The [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/) is written in [Python](https://www.python.org/) and uses a bundled version of Python in order to prevent conflicts with other installed Python runtimes on the system. One quirk about this bundled Python is that it does not use the internal Windows certificate store. Thus, when running certain `az` commands (like `az acr login`), you might get errors relating to web requests failing.

The fix is to manually append the contents of the root CA certificate to the file at:

```
C:\Program Files (x86)\Microsoft SDKs\Azure\CLI2\lib\site-packages\certifi\cacert.pem
```

### Podman

See [the official page on installing a certificate authority](https://github.com/containers/podman/blob/main/docs/tutorials/podman-install-certificate-authority.md).

## LogixHealth Certificate Authority Information

- The new root CA is "BEDROOTCA001". (This will last from 2022 to 2024.)
- The old root CA is "LOGIX_ROOT_CA". Nothing should be using this CA. If you find any certificates signed by the old CA, you should update them immediately.
- The intermediate CA is "BEDSUBCA001". (This will last from 2022 to 2029.)

## Generating a New Certificate

If you are an admin, we have [a script](https://azuredevops.logixhealth.com/LogixHealth/Infrastructure/_git/infrastructure?path=/PowerShell/Certificate_Management/Request-Certificate.ps1) to generate a new certificate.

- This script must be run using an admin account (i.e. "admin_jnesta" instead of "jnesta").
- This script must be run from a server like "BEDPMGT001". (This is because Authlite will prevent it from working correctly when being run from a laptop.)

For example, on "BEDPMGT001", you can run the script like this:

```powershell
C:\_IT\repositories\infrastructure\PowerShell\Certificate_Management\Request-Certificate.ps1 -Export
```

(By default, the script will import the new certificate into the current computer's certificate store. This is not what we want, so we have to use the "-Export" option.)

This will create a ".pfx" file in the current working directory.

### For Windows Servers

".pfx" files can usually be directly used on Windows servers.

### For Linux Servers

Linux servers typically expect a ".crt" file and a ".key" file. Run these commands to convert the ".pfx" file:

```bash
CERTIFICATE_NAME="docs.logixhealth.com"

# Create the ".crt" file.
openssl pkcs12 -in "$CERTIFICATE_NAME.pfx" -out "$CERTIFICATE_NAME.fullchain.crt" -nokeys -passin pass:
# The ".pfx" file from the script is signed by the intermediate CA, but will not include the
# intermediate CA certificate or the root CA certificate. Thus, we have to manually append those.
# (They have to be appended in this specific order in order for it to work properly.)
curl --silent certs.logixhealth.com/BEDSUBCA001.crt >> "$CERTIFICATE_NAME.fullchain.crt"
curl --silent certs.logixhealth.com/BEDROOTCA001.crt >> "$CERTIFICATE_NAME.fullchain.crt"

# Create the ".key" file. (The "-nocerts" option does not work if the ".pfx" file does not have a
# passphrase. Thus, we extract the key from the combined certificate as a workaround.)
openssl pkcs12 -in "$CERTIFICATE_NAME.pfx" -out "$CERTIFICATE_NAME.combined" -nodes -passin pass:
openssl rsa -in "$CERTIFICATE_NAME.combined" -out "$CERTIFICATE_NAME.key"
rm "$CERTIFICATE_NAME.combined"
```

## Troubleshooting

### Example Websites

- The following is an internal-only website that has a valid certificate: https://authlite.logixhealth.com/
- The following is an internal-only website that uses a wildcard certificate: https://dclaimstatus.logixhealth.com/

### Troubleshooting a "Red" Certificate

- To see the information about a website's certificate:
  - If the certificate is trusted, click on the icon on the left of the address bar. (It looks like two lines.) Next, click on "Connection is secure". Next, click on "Certificate is valid".
  - If the certificate is untrusted, click on the "Not secure" text to the left of the address bar. Next, click on "Certificate details".
- A valid certificate should have the following values:
  - General Tab
    - Issued To:
      - Common Name (CN): foo.logixhealth.com
      - Organization (O): LogixHealth
      - Organization Unit (OU): IT
    - Issued By:
      - Common Name (CN): BEDSUBCA001
      - Organization (O): Not Part Of Certificate
      - Organizational Unit (OU): Not Part Of Certificate
    - Validity Period:
      - (must not be expired, obviously)
  - Details Tab
    - Must have a "Certificate Hierarchy" of:
      - BEDROOTCA001 --> BEDSUBCA001 --> foo.logixhealth.com
- Even if all of the above values are correct, the certificate will still show up as untrusted if it does not have a Subject Alternate Name (SAN) in it. (Typically, the SAN will be the same as the CN.)

### Other Commands

- Command to inspect a ".pfx" file:
  - `openssl pkcs12 -info -in "$CERTIFICATE_NAME.pfx" -nodes -passin pass:`
