#!/bin/sh
csv_output=$(./read_csv.sh backup_config.csv)
for i in ${csv_output[@]}; do
    echo $i
done

# backup_args=""
# for item in "${csv_output[@]}"; do
#     backup_args+=\"$item\"
# done
# echo $backup_args

# Function to log information and errors
log_info() { printf "\n%s %s\n\n" "$(date)" "$*" >&2; }
log_error() { printf "\n%s [ERROR] %s\n\n" "$(date)" "$*" >&2; logger -p user.err -t borg_backup "[ERROR] $*"; }

# Check if borg is installed
if ! command -v borg >/dev/null 2>&1; then
    log_error "borg is not installed. Attempting to install borg..."

    # Try to install borg using Homebrew
    if command -v brew >/dev/null 2>&1; then
        log_info "Homebrew found. Installing borg using Homebrew..."
        brew install borgbackup
    else
        log_error "Homebrew is not installed. Please install Homebrew and try again. Visit https://brew.sh for instructions."
        exit 1
    fi
fi

# Retrieve the passphrase from macOS Keychain
BORG_PASSPHRASE=$(security find-generic-password -a "" -s "borg_passphrase" -w)

# Check if the passphrase was successfully retrieved
if [ -z "$BORG_PASSPHRASE" ]; then
    log_error "Failed to retrieve passphrase from Keychain."

    # Prompt user for passphrase
    echo "Enter the Borg passphrase:"
    read -s BORG_PASSPHRASE

    # Check if the user entered a passphrase
    if [ -z "$BORG_PASSPHRASE" ]; then
        log_error "No passphrase entered. Exiting."
        exit 1
    fi

    # Save the passphrase to Keychain
    security add-generic-password -a "" -s "borg_passphrase" -w "$BORG_PASSPHRASE" -U
    if [ $? -ne 0 ]; then
        log_error "Failed to save passphrase to Keychain."
        exit 1
    fi

    log_info "Passphrase saved to Keychain."
fi

export BORG_PASSPHRASE

# Update this to point to your USB drive mount point
export BORG_REPO='/Volumes/T7/borg_backups'

# Check if the repository directory exists
if [ ! -d "$BORG_REPO" ]; then
    log_error "Backup location $BORG_REPO does not exist. Please specify a valid USB drive or backup location."
    exit 1
fi

# Check if the repository is initialized
if ! borg info $BORG_REPO >/dev/null 2>&1; then
    log_info "Initializing Borg repository at $BORG_REPO."
    borg init --encryption=repokey $BORG_REPO
    if [ $? -ne 0 ]; then
        log_error "Failed to initialize Borg repository at $BORG_REPO."
        exit 1
    fi
fi

log_info "Starting backup"

# Replace these paths with the directories and files you want to back up
directories_and_files=(
    "/Volumes/Data/donsantmajor/Documents/PattitudeEvents"
    "/Volumes/Data/donsantmajor/Documents/BMJ"
    "/Volumes/Data/donsantmajor/Documents/intelezen"
    "/Volumes/Data/donsantmajor/Documents/scalene"
)

# Build the backup command arguments
# backup_args=$(printf " %s" "${directories_and_files[@]}")
backup_args=$(printf " %s" "${csv_output[@]}")




echo "======================================================"
echo "||      DIRECTORIES / FILES FOR BACKUP                ||"
echo "======================================================\n"
echo "These Directories are being backedup using borgbackup\n"
for i in $backup_args; do
    echo "\b - $i"
done
echo "======================================================\n\n"




# Backup the specified directories and files into an archive named after
# the machine this script is currently running on:

borg create                         \
    --verbose                       \
    --filter AME                    \
    --list                          \
    --stats                         \
    --show-rc                       \
    --compression lz4               \
    --exclude-caches                \
    --exclude 'home/*/.cache/*'     \
    --exclude 'var/tmp/*'           \
                                    \
    ::'{hostname}-{now}'            \
    $backup_args


backup_exit=$?
if [ $backup_exit -ne 0 ]; then
    log_error "Backup failed with exit code $backup_exit"
    exit $backup_exit
fi

log_info "Pruning repository"

borg prune                          \
    --list                          \
    --glob-archives '{hostname}-*'  \
    --show-rc                       \
    --keep-daily    7               \
    --keep-weekly   4               \
    --keep-monthly  6

prune_exit=$?
if [ $prune_exit -ne 0 ]; then
    log_error "Prune failed with exit code $prune_exit"
    exit $prune_exit
fi

log_info "Compacting repository"

borg compact

compact_exit=$?
if [ $compact_exit -ne 0 ]; then
    log_error "Compaction failed with exit code $compact_exit"
    exit $compact_exit
fi

# Use highest exit code as global exit code
global_exit=$(( backup_exit > prune_exit ? backup_exit : prune_exit ))
global_exit=$(( compact_exit > global_exit ? compact_exit : global_exit ))

if [ $global_exit -eq 0 ]; then
    log_info "Backup, Prune, and Compact finished successfully"
elif [ $global_exit -eq 1 ]; then
    log_info "Backup, Prune, and/or Compact finished with warnings"
else
    log_error "Backup, Prune, and/or Compact finished with errors"
fi

exit $global_exit
