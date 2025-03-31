# F5 BIG-IP Application Services 3 Extension (AS3)

This is the [user guide](https://clouddocs.f5.com/products/extensions/f5-appsvcs-extension/latest/userguide/), [FAQ](https://clouddocs.f5.com/products/extensions/f5-appsvcs-extension/latest/userguide/faq.html), and
[F5 Application Services Extension Github](https://github.com/F5Networks/f5-appsvcs-extension).

## Application Services 3 Extension Installation on F5 Appliance

You must use the admin user (and not just a user with administrator privileges) to [install](https://clouddocs.f5.com/products/extensions/f5-appsvcs-extension/latest/userguide/installation.html#installation). Before doing so, please go over the [prerequisites](https://clouddocs.f5.com/products/extensions/f5-appsvcs-extension/latest/userguide/prereqs.html).

## Declarations

We have decided to go with tenant wide declarations for lower overhead vs [Per-Application Declarations](https://clouddocs.f5.com/products/extensions/f5-appsvcs-extension/latest/userguide/per-app-declarations.html).There is not much gain except for shorter config post time.

## Warnings, Notes, & Tips

[Warnings, Notes, & Tips from F5 BIG IP](https://clouddocs.f5.com/products/extensions/f5-appsvcs-extension/latest/userguide/tips-warnings.html#notes-and-tips)

When creating a new tenant using BIG-IP AS3, it must not use the same name as a partition you separately create on the target BIG-IP system. If you use the same name and then post the declaration, BIG-IP AS3 overwrites (or removes) the existing partition completely, including all configuration objects in that partition.

When you are using BIG-IP AS3 on a BIG-IP system that is part of a Device Group for high availability, if you want BIG-IP AS3 on all devices, you must manually install it on each BIG-IP in the group. Synchronizing the configuration between devices in a Device Group does NOT install BIG-IP AS3 on devices that do not have BIG-IP AS3 installed.

BIG-IP AS3 does not function properly when the BIG-IP has Appliance mode enabled. We strongly recommend disabling [Appliance mode](https://my.f5.com/manage/s/article/K12815) when using BIG-IP AS3. Note: When the device is not running in Appliance mode, the line displays under Optional Modules.
We have verified 11/12/24 that is not running Appliance mode.

## Known Issues & Troubleshooting:

Per [F5 website](https://clouddocs.f5.com/products/extensions/f5-appsvcs-extension/latest/userguide/known-issues.html), refer to their [GitHub](https://github.com/F5Networks/f5-appsvcs-extension/issues) for known issues. Hit the link for common [troubleshooting tips](https://clouddocs.f5.com/products/extensions/f5-appsvcs-extension/latest/userguide/troubleshooting.html#big-ip-as3-general-troubleshooting-tips)

## AS3 JSON Schema Reference

[Full appendix](https://clouddocs.f5.com/products/extensions/f5-appsvcs-extension/latest/refguide/schema-reference-byclass.html) here but the classes we commonly use below:

### Partitions

Partitions = [Tenant](https://clouddocs.f5.com/products/extensions/f5-appsvcs-extension/latest/refguide/schemaref/Tenant.schema.json.html)

### Pools

[Pools](https://clouddocs.f5.com/products/extensions/f5-appsvcs-extension/latest/refguide/schemaref/Pool.schema.json.html)

### Monitors

[Monitor](https://clouddocs.f5.com/products/extensions/f5-appsvcs-extension/latest/refguide/schemaref/Monitor.schema.json.html)

### Virtual Servers

Virtual Server HTTPS = [Service_HTTPS](https://clouddocs.f5.com/products/extensions/f5-appsvcs-extension/latest/refguide/schemaref/Service_HTTPS.schema.json.html)

When creating a Virtual Server for HTTPS, it automatically creates a redirect virtual server and applies the https redirect iRule. No need to explicitly add a http virtual server / service_http.

### SSL Profiles

Server SSL Profiles = [TLS_Server](https://clouddocs.f5.com/products/extensions/f5-appsvcs-extension/latest/refguide/schemaref/TLS_Server.schema.json.html)

Client SSL Profiles = [TLS_Client](https://clouddocs.f5.com/products/extensions/f5-appsvcs-extension/latest/refguide/schemaref/TLS_Client.schema.json.html)

[No more parent profiles in ssl profiles, need to define](https://github.com/F5Networks/f5-appsvcs-extension/issues/275)

[TLS_Server is creating ssl client and defaulting client ssl parent profile , TLS_Client is creating ssl server defaulting to serverssl parent profile
"The BIG-IP AS3 naming convention for TLS Server and TLS Client differs from traditional BIG-IP terminology to better comply with industry usage, but may be slightly confusing for long-time BIG-IP users. The BIG-IP AS3 TLS_Server class is for connections arriving to the BIG-IP, which creates a “client SSL profile” object on the BIG-IP. The BIG-IP AS3 TLS_Client class if for connections leaving the BIG-IP, which creates a “server SSL profile” on the BIG-IP. See TLS_Server and TLS_Client in the Schema Reference for more information."](https://clouddocs.f5.com/products/extensions/f5-appsvcs-extension/latest/userguide/tips-warnings.html#notes-and-tips)

### Certificates

[Referencing an existing SSL certificate and key in the Common partition](https://clouddocs.f5.com/products/extensions/f5-appsvcs-extension/latest/declarations/tls-encryption.html#referencing-an-existing-ssl-certificate-and-key-in-the-common-partition)

While referencing existing cert in the as3 template (2_Product_Platforms\ansible\f5_as3\as3_templates\logixapps.json), unable to pull in private key from specific partition. As workaround, referencing common partition in template and we would need to upload certs to common.

`"privateKey": {
              "bigip": "/Common/{{ app['certificate'] }}" } `

For new certs, we are still manually importing. Most likely our new cert automation tool can handle this for us.

### Nodes:

Do not need to explicitly add nodes in AS3, adds automatically when adding to a pool. There is no object class for "node". Only drawback is nodes will appear as ip address vs host name. It does show only in the pool members when adding the description metadata under pool class > pool members.

## Declaration Validation

[Declaration Validation](https://clouddocs.f5.com/products/extensions/f5-appsvcs-extension/latest/userguide/validate.html)

## Declaration Metadata

[Declaration Metadata](https://clouddocs.f5.com/products/extensions/f5-appsvcs-extension/latest/declarations/miscellaneous.html#using-metadata-in-a-declaration)

## AS3 Template

[Template uses Jinja2 templating engine](https://jinja.palletsprojects.com/en/stable/)

Template file here: 2_Product_Platforms\ansible\f5_as3\as3_templates\logixapps.json.jinja2

To pass prettier check , we renamed the template to include .json.jinja2 file ext.

# Ansible

[Ansible Collections](https://clouddocs.f5.com/products/orchestration/ansible/devel/)

(Manually installed - will automate this when we transition to docker images for our CI runners - discussed with James 11/13/24 during in person meeting)

Install ansible f5 big ip module cmd:
`ansible-galaxy collection install f5networks.f5_bigip`

Installing objectpath library cmd: (missing Python library called objectpath, which is required by the bigip_configsync_action module from the f5networks.f5_bigip collection)
`pip install objectpath`

## Declarative Collection

We are using the [f5_bigip collection](https://clouddocs.f5.com/products/orchestration/ansible/devel/f5_bigip/f5_bigip.html) for BIG-IP Declarative APIs and Tasks

[F5 Networks Declarative Documentation](https://clouddocs.f5.com/products/orchestration/ansible/devel/f5_bigip/modules_2_0/module_index.html)
[GitHub - Ansible Collection](https://github.com/F5Networks/f5-ansible-bigip)
[Ansible Galaxy Collection](https://galaxy.ansible.com/ui/repo/published/f5networks/f5_bigip/)

## Ansible Playbooks

There should only be four playbooks/tenants/partitions that we are separating by environments:

f5_lab_partition\
f5_dev_partition\
f5_uat_partition\
f5_prod_partition

Application configurations are inputted into playbooks, playbooks are at root of Ansible directory. (If inputs are in host vars, very messy to loop through apps in multiple partitions. We are not operating with multiple hosts, we are only applying configurations to one host which is then broken down into partitions/tenants and synced to device group where the second node picks up the config sync. Therefore, app config inputs are on the playbook level)

Playbook which calls template , expects the inputs of:

partition\
name (app name)\
vsip (virtual server IP)\
members (IP addresses of member servers of pool)\
certificate (certificate name)

```
  vars:
    partition: lab
    apps:
      - name: logix-tommy
        vsip: 20.20.20.40
        members:
          - 10.10.33.29
          - 10.10.33.31
        certificate: logix-tommy.logixhealth.com
      - name: logix-derek
        vsip: 20.20.20.41
        members:
          - 10.10.33.29
          - 10.10.33.31
        certificate: logix-derek.logixhealth.com
      - name: logix-nick
        vsip: 20.20.20.43
        members:
          - 10.10.33.29
          - 10.10.33.31
        certificate: 2025_wildcard_LH_internal
```

ssl profiles, monitors, pools , & virtual servers (including https redirect) are handled in the AS3 template.

## F5 Primary Node

The way we have our playbooks , we deploy the configs to active node and sync to device group.

If the active node changes, simply go into the F5 inventory file and add active node there and comment/remove secondary.

The host vars contain connection info, should not need to touch anything there.
