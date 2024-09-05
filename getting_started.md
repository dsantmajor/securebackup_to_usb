# Getting Started Guide
## Why Use This Tool?
The primary goal of this backup solution is to offer a reliable, cost-effective method for backing up data locally using an external USB drive. This approach is particularly useful when working with critical data on your computer, as it provides an additional layer of protection against hardware failures and data loss. While cloud storage is a viable option, this tool ensures that you have a local backup readily available, reducing dependence on potentially expensive cloud solutions.

## Security
We have integrated security measures by utilizing macOS Keychain for storing the Borg passphrase. This ensures that sensitive information is not exposed and adds an extra layer of security to your backup process.

## Prerequisites
- macOS Computer: Ensure you have macOS for testing and running the scripts.
- Homebrew: Install Homebrew if not already installed.
- BorgBackup: Install BorgBackup via Homebrew.
## Setup
Clone the repo
we have these logic in these scripts

- borg_backups.sh
- read_csv.sh
- Makefile
- backup_config_template.csv

## Configure the CSV File:

Rename backup_config_template.csv to backup_config.csv.
Update paths in the CSV file to match your backup source directories and target backup location.

## Makefile Configuration:

Ensure the BORG_REPO path in the Makefile matches your backup location.
Running the Backup

## Prepare Keychain Passphrase:

Store your Borg passphrase in macOS Keychain or be ready to enter it when prompted by the script.
Run Backup:

## Use the Makefile command to start the backup process:

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
