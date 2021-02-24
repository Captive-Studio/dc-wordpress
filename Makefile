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

dump-wp-content: environment
	@$(load_env); echo "*** Dumping wp-content ***"
	@$(load_env); docker exec -i wordpress_wordpress_1 sh -c "tar -C /var/www/html/wp-content -czf - ." > wp-content.tgz

dump-mariadb: environment
	@$(load_env); echo "*** Dumping database '$$MYSQL_DATABASE' ***"
	@$(load_env); docker exec -it wordpress_wordpress-db_1 mysqldump -h 127.0.0.1 -u $$MYSQL_USER \
			--password=$$MYSQL_PASSWORD \
			--no-tablespaces $$MYSQL_DATABASE | gzip > $$MYSQL_DATABASE.sql.gz
	@$(load_env); echo "- database $$MYSQL_DATABASE => $$MYSQL_DATABASE.sql.gz"
