# BORG_REPO = ${BORG_REPO}
BORG_REPO='/Volumes/T7/borg_backups'
.DEFAULT_GOAL := backup

.PHONY: backup

backup: ## Create a backup using BorgBackup software
	./borg_backups.sh
list-backups: ## list all the backups from `${BORG_REPO}`
	borg list ${BORG_REPO}
restore: ## restore from backup dir `${BORG_REPO}`
	@echo "Run this command: borg extract ${BORG_REPO}::'provide the archive name from the list-backups command'"

# A help target including self-documenting targets (see the awk statement)
define HELP_TEXT
Usage: make [TARGET]... [MAKEVAR1=SOMETHING]...

Available targets:
endef
export HELP_TEXT
help: ## This help target
	@cat .banner
	@echo " "
	@echo " "
	@echo "Backup your directories and files to a local or external storage device"
	@echo " "
	@echo " "
	@echo "$$HELP_TEXT"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / \
		{printf "\033[36m%-30s\033[0m  %s\n", $$1, $$2}' $(MAKEFILE_LIST)