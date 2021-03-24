default: help
include *.mk

.PHONY: start
start: docker-compose-pull docker-compose-start ##- Start
.PHONY: deploy
deploy: docker-compose-pull docker-compose-deploy ##- Deploy (start remotely)
.PHONY: stop
stop: docker-compose-stop ##- Stop

.PHONY: logs
logs: docker-compose-logs

backup: dump-mariadb dump-wp-content
restore: restore-mariadb restore-wp-content

dump-wp-content: environment
	@$(load_env); echo "*** Dumping wp-content ***"
	@$(load_env); docker exec -i wordpress_wordpress_1 sh -c "tar -C /var/www/html/wp-content -czf - ." > wp-content.tgz

dump-mariadb: environment
	@$(load_env); echo "*** Dumping database '$$MYSQL_DATABASE' ***"
	@$(load_env); docker exec -it wordpress_wordpress-db_1 mysqldump -h 127.0.0.1 -u $$MYSQL_USER \
			--password=$$MYSQL_PASSWORD \
			--no-tablespaces $$MYSQL_DATABASE | gzip > $$MYSQL_DATABASE.sql.gz
	@$(load_env); echo "- database $$MYSQL_DATABASE => $$MYSQL_DATABASE.sql.gz"

restore-wp-content: environment
	@$(load_env); echo "*** Restoring wp-content ***"
	@$(load_env); pv wp-content.tgz | docker exec -i wordpress_wordpress_1 sh -c "tar -C /var/www/html/wp-content -xzf - ."
	@$(load_env); docker exec wordpress_wordpress_1 chown -R www-data:www-data '/var/www/html/wp-content/*'

restore-mariadb: environment
	@$(load_env); echo "*** Restoring database '$$MYSQL_DATABASE' ***"
	@$(load_env); pv $$MYSQL_DATABASE.sql.gz | gunzip | \
		sed \
			-e 's|http://localhost:8080|https://staging.spi.captive.fr|g' \
			-e 's|http:\\\\/\\\\/localhost:8080|https:\\\\/\\\\/staging.spi.captive.fr|g' \
		| docker exec -i wordpress_wordpress-db_1 \
		mysql -h 127.0.0.1 -u $$MYSQL_USER --password=$$MYSQL_PASSWORD $$MYSQL_DATABASE

console: environment
	@$(load_env); docker exec -it wordpress_wordpress_1 /bin/bash

restore-mariadb-staging-local: environment
	@$(load_env); echo "*** Restoring database '$$MYSQL_DATABASE' ***"
	@$(load_env); pv $$MYSQL_DATABASE.sql.gz | gunzip | \
		sed \
			-e 's|https://staging.spi.captive.fr|http://localhost:8080|g' \
			-e 's|https:\\\\/\\\\/staging.spi.captive.fr|http:\\\\/\\\\/localhost:8080|g' \
		| docker exec -i wordpress_wordpress-db_1 \
		mysql -h 127.0.0.1 -u $$MYSQL_USER --password=$$MYSQL_PASSWORD $$MYSQL_DATABASE
