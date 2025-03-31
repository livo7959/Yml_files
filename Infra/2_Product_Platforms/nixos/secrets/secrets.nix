let
  BEDPCONHOST001 = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCxmbLKHseGE2HHIZ+MAhXTX8Ny02VOpO6b4gkVV/p4iQv9KMjVKEGsiWG7kRQV84o/bznWbzFymWR9vWriaIKkYf4l0w8rKELJY2jqJBd4VwVT0CPmoteQ+XxpdC22rM1UwQlJ3QRrLq5JnA67unIDjL2SM0viXk+t317JxjrQxe75VZ3OEt80/EsqWUREe7qeOU2fI5/7gjLeKHwI3/Uw4rCBwa7RCSyuVI6uMElsahkkshQzD7sV4whHd5/P/7SMgwuQmQODsYQ6Wz7Fu8chT/+5tdvQLjppOvqGmzJXO45/qa9r3VW7jAtoBGc9ziTU3dut1Q3JztN/Jj9fv1UaFJYkP5MiYGhbkRCU4f6tmR2XlD6DRKIupZTC0Gw7/JsamCfUB6BMo3S1mudPOIIaTjOMZvBCwXpuaRSvHtNH0JCtHpzKt07dTsLkRtjqvWqufBck0/3HRhxHRqcikqokbiFj5H+YMomCPEJKwx1MQ9EawcgI3ICYyHot0lyisp85nA1MsoU46FFBbDF5mUHnrNNi4CMrSsWbCOREgz+hntiDAH61CHekSlsRIlt0GmRkR+lsUOpHqpHGHyafwU6Je1lDagtLSF6nolFrpK4+0wPinKVvmjS7iu+ytUbEB+N1aucHXPaKbj6foGB1Mob9kvywxl5fAFgUouTqdc0SkQ==";
in
{
  "sp-BEDPCONHOST001.age".publicKeys = [ BEDPCONHOST001 ];

  # Container service principles
  "sp-charts-data-transfer-service.age".publicKeys = [ BEDPCONHOST001 ];

  # Containers
  "auto-auto-complete.age".publicKeys = [ BEDPCONHOST001 ];
  "azure-devops-ci-cd-runner.age".publicKeys = [ BEDPCONHOST001 ];
  "charts-data-transfer-service.age".publicKeys = [ BEDPCONHOST001 ];
}
