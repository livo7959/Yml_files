# EntraID General Applications

This directory contains general / miscellaneous Entra ID applications + service principles in the production Entra ID tenant that do not have to do with the mainline company applications.

## Naming Convention

If the service principal uses a specific subscription, then they should conform to the following naming standard: sp-foo-subscriptionName

(This only really fits for infrastructure deployment accounts.)

For example:

- sp-azdo-lhSandboxData001
- sp-azdo-lhSandboxDev001

Otherwise, the service principal should be named like: sp-foo

It can also have the environment appended, like this:

- sp-foo-sbox
- sp-foo-prod
