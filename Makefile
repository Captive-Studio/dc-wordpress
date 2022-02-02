default: help
include makefiles/*.mk

console: environment
	@$(load_env); docker exec -it wordpress_wordpress_1 /bin/bash

check-php-upload-max-filesize: environment
	@$(load_env); docker exec wordpress_wordpress_1 php -i 2>&1 | grep upload_max_filesize

check-requirements: wordpress-requirements ##- Check requirements
	@$(call ensure_command,awk)
	@[ "$$($(MAKE) --version | awk '/GNU Make/ { split($$3,a,"."); print a[1] }')" == "4" ] || (echo "Gnu Make 4.x is required"; exit 1)

.PHONY: start
start: docker-compose-build docker-compose-start ##- Start
.PHONY: deploy
deploy: docker-compose-build docker-compose-deploy ##- Deploy (start remotely)
.PHONY: stop
stop: docker-compose-stop ##- Stop

.PHONY: logs
logs: docker-compose-logs ##- Print logs

.PHONY: backup
backup: wordpress-dump-mariadb wordpress-dump-wp-content ##- Backup db and wp-content
.PHONY: restore
restore: wordpress-restore-mariadb wordpress-restore-wp-content ##- Restore db and wp-content

.PHONY: status
status: docker-compose-ps ##- Print status

.PHONY: clean
clean: docker-compose-clean ##- Delete data

.PHONY: local-wordpress-restore-wp-content
local-wordpress-restore-wp-content: ##- Restore wp-content locally
local-wordpress-restore-wp-content: environment set-local-docker-compose-files
	@$(load_env); echo "*** Restoring wp-content to local folder ***"
	@$(load_env); pv wp-content.tgz | sudo tar -C ./wp-content -xzf -
	@$(load_env); docker exec wordpress_wordpress_1 chown -R www-data:www-data '/var/www/html/wp-content'

.PHONY: local-allow-access-wp-content
local-allow-access-wp-content: ##- Allow all access to wp-content files
	@echo "Allowing permissions on wp-content files"
	sudo chmod -R 777 wp-content

.PHONY: local-restrict-access-wp-content
local-restrict-access-wp-content: ##- Restrict access to wp-content files
	@echo "Restricting permissions on wp-content files"
	sudo find wp-content -type d -exec chmod 755 {} \;
	sudo find wp-content -type f -exec chmod 644 {} \;

.PHONY: transfert-staging-to-default
transfert-staging-to-default: ##- Migrate data from staging to default env
transfert-staging-to-default: check-requirements
	@$(MAKE) -e from=staging to=default wordpress-transfert

.PHONY: transfert-default-to-staging
transfert-default-to-staging: ##- Migrate data from default to staging env
transfert-default-to-staging: check-requirements
	@$(MAKE) -e from=default to=staging wordpress-transfert

.PHONY: transfert-default-to-production
transfert-default-to-production: ##- Migrate data from default to production env
transfert-default-to-production: check-requirements
	@$(MAKE) -e from=default to=production wordpress-transfert

.PHONY: transfert-staging-to-production
transfert-staging-to-production: ##- Migrate data from staging to production env
transfert-staging-to-production: check-requirements
	@$(MAKE) -e from=staging to=production wordpress-transfert

.PHONY: transfert-production-to-staging
transfert-production-to-staging: ##- Migrate data from production to staging env
transfert-production-to-staging: check-requirements
	@$(MAKE) -e from=production to=staging wordpress-transfert
