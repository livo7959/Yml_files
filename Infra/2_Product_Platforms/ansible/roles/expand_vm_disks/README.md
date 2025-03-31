# Partition Resize Role

This role automates the process of resizing Windows partitions

## Requirements

- Windows OS
- community.windows collection

## CMD Line to identify parition number

diskpart
LIST DISK
SELECT DISK X
LIST PARTITION

## Optional Variables:

exisiting_disk_expand:

- drive_letter: C # Drive letter to resize
  partition_size: -1 # -1 means use maximum available size
  partition_number: 4 # Partition number to resize
  disk_number: 0 # Disk number containing the partition

If the exisiting_disk_expand variable is not defined, the role will be skipped.
This allows the role to be included in playbooks without running when partition resizing is not needed.

## Example Playbook

- hosts: test_servers
  roles:

  - expand_vm_disks

  vars:
  exisiting_disk_expand: - drive_letter: C
  partition_size: -1
  partition_number: 4
  disk_number: 0
