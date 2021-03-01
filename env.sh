#!/bin/sh
set -eu

stage=$1

cat <<EOF
COMPOSE_PROJECT_NAME=wordpress
EOF

case "$stage" in
	"default")
		cat <<-EOF
		MYSQL_DATABASE=wp
		MYSQL_USER=wp
		MYSQL_PASSWORD=wp
		EOF
		;;

	"staging")
		;;

	*)
		echo "Undefined stage $stage" >&2
		;;
esac
