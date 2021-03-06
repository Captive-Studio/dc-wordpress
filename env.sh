#!/bin/sh
set -eu

stage=$1

cat <<EOF
COMPOSE_PROJECT_NAME=wordpress-$stage
# COMPOSE_COMPATIBILITY=true
STAGE=$stage
EOF

case "$stage" in
	"default")
		cat <<-EOF
		APP_FQDN=localhost
		MYSQL_DATABASE=wp
		MYSQL_USER=wp
		MYSQL_PASSWORD=wp
		WP_BASEURL=http://localhost:8080
		EOF
		;;

	"staging"|"production")
		;;

	*)
		echo "Undefined stage $stage" >&2
		;;
esac
