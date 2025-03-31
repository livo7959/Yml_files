# Integrator

Integrator is an application created at LogixHealth that automates the sending and recieving of form files, using "integrations" to enhance the data or parse it to extract the data.

Integrator mostly runs on the VM of "BEDPINT001". However, it also uses the "LogixAutomation - Execution Engine", which runs on "BEDPAUTO01". (Specifically, "BEDPAUTO02" and others are not used by Integrator, those are for other LogixAutomation services.)

For the networking side, all ICER data that is pulled/pushed through the Integrator engine (i.e. "LogixAutomation - Execution Engine" will have a source of "BEDPAUTOENG01".

The following is a complete table that lists the virtual machines and their respective roles:

| Virtual Machine Name            | Function                     |
| ------------------------------- | ---------------------------- |
| BEDPINT001                      | Integrator Application       |
| BEDPINT001                      | Integrator Service           |
| BEDPAPPICER001 - BEDPAPPICER004 | Common Data Service          |
| BEDPAUTOENG01                   | Integrator Automation Engine |
