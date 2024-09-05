# BorgBackup Backup System
```bash
██████╗░░█████╗░██████╗░░██████╗░  ██████╗░░█████╗░░█████╗░██╗░░██╗██╗░░░██╗██████╗░░██████╗
██╔══██╗██╔══██╗██╔══██╗██╔════╝░  ██╔══██╗██╔══██╗██╔══██╗██║░██╔╝██║░░░██║██╔══██╗██╔════╝
██████╦╝██║░░██║██████╔╝██║░░██╗░  ██████╦╝███████║██║░░╚═╝█████═╝░██║░░░██║██████╔╝╚█████╗░
██╔══██╗██║░░██║██╔══██╗██║░░╚██╗  ██╔══██╗██╔══██║██║░░██╗██╔═██╗░██║░░░██║██╔═══╝░░╚═══██╗
██████╦╝╚█████╔╝██║░░██║╚██████╔╝  ██████╦╝██║░░██║╚█████╔╝██║░╚██╗╚██████╔╝██║░░░░░██████╔╝
╚═════╝░░╚════╝░╚═╝░░╚═╝░╚═════╝░  ╚═════╝░╚═╝░░╚═╝░╚════╝░╚═╝░░╚═╝░╚═════╝░╚═╝░░░░░╚═════╝░ 
```

This project provides a backup solution using BorgBackup on macOS. It is designed to create local backups on an external USB drive, providing a cost-effective alternative to cloud storage. The tool ensures security by using macOS Keychain to store and retrieve the Borg passphrase.

## TLDR

`make backup` will create de-duped backups of all the the directories listed in your [backup_config.csv](./backup_config_template.csv) to a USB drive as defined in this file [BORG_REPO](./borg_backups.sh) . It will also store your passphrase securely in keychain. The make commands will let you list and restore your backups.

PS: update the BORG_REPO to point to a usb drive

- run `df -h`
```bash
Filesystem       Size   Used  Avail Capacity iused     ifree %iused  Mounted on
dev/disk3s1    1.8Ti  353Gi  1.5Ti    19% 2894181  12367151   19%   /Volumes/T7
```
in this case we will update `export BORG_REPO='/Volumes/T7/borg_backups'`, where `/Volumes/T7` is my USB SSD and `borg_backups` is the dir name we have chosen.

## Why Use This Tool?

Backing up your data is crucial because hardware failures can happen unexpectedly, leading to data loss. While cloud storage offers a convenient backup solution, it can become costly, especially for large amounts of data. This tool provides an efficient and cost-effective alternative by backing up to an external USB drive. You can still use cloud storage as a secondary backup, but having a local backup ensures you have immediate access to your data in case of emergencies.


## Security

Security is a top priority in this backup solution. The tool uses macOS Keychain to securely store and retrieve the Borg passphrase. This approach minimizes the risk of passphrase exposure and ensures that sensitive information is protected.

## Prerequisites

- **Tools:**
  - Homebrew (for macOS package management)
  - BorgBackup (backup tool)

- **Knowledge:**
  - Basic shell scripting
  - Understanding of CSV files and command-line tools

- **Hardware:**
  - Tested on macOS

## Setup

1. **Install Homebrew:**
   ```sh
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"```


## Install BorgBackup: 
If BorgBackup is not installed, the tool will install it for you automatically, provided that Homebrew is present:

```brew install borgbackup```

### Prepare Configuration File:
- Rename backup_config_template.csv to backup_config.csv and modify paths accordingly.

### Passphrase Storage:
- Store the Borg passphrase in macOS Keychain or enter it when prompted by the script.

## Usage

- Clone the repo
 
-  `git clone https://github.com/dsantmajor/securebackup_to_usb.git`
- `make help`
  
Makefile has these commands
```bash

make help

██████╗░░█████╗░██████╗░░██████╗░  ██████╗░░█████╗░░█████╗░██╗░░██╗██╗░░░██╗██████╗░░██████╗
██╔══██╗██╔══██╗██╔══██╗██╔════╝░  ██╔══██╗██╔══██╗██╔══██╗██║░██╔╝██║░░░██║██╔══██╗██╔════╝
██████╦╝██║░░██║██████╔╝██║░░██╗░  ██████╦╝███████║██║░░╚═╝█████═╝░██║░░░██║██████╔╝╚█████╗░
██╔══██╗██║░░██║██╔══██╗██║░░╚██╗  ██╔══██╗██╔══██║██║░░██╗██╔═██╗░██║░░░██║██╔═══╝░░╚═══██╗
██████╦╝╚█████╔╝██║░░██║╚██████╔╝  ██████╦╝██║░░██║╚█████╔╝██║░╚██╗╚██████╔╝██║░░░░░██████╔╝
╚═════╝░░╚════╝░╚═╝░░╚═╝░╚═════╝░  ╚═════╝░╚═╝░░╚═╝░╚════╝░╚═╝░░╚═╝░╚═════╝░╚═╝░░░░░╚═════╝░ 
 
Backup your directories and files to a local or external storage device
 
 
Usage: make [TARGET]... [MAKEVAR1=SOMETHING]...

Available targets:
backup                          Create a backup using BorgBackup software
list-backups                    list all the backups from `${BORG_REPO}`
restore                         restore from backup dir `${BORG_REPO}`
help                            This help target
```

## Scripts

- borg_backups.sh: Main backup script.
- read_csv.sh: Reads configuration from CSV file.
- Makefile: Provides shortcuts for backup operations.

## Logs

- Review script.log for detailed operation logs.