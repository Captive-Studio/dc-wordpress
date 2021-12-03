#!/bin/sh
set -eu

stage=$1

cat <<EOF
COMPOSE_PROJECT_NAME=wordpress
# COMPOSE_COMPATIBILITY=true
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

	"staging")
		;;

	*)
		echo "Undefined stage $stage" >&2
		;;
esac
