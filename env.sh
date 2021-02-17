#!/bin/sh
set -eu

stage=$1

cat <<EOF
COMPOSE_PROJECT_NAME=wordpress
EOF

case "$stage" in
	"default")
		;;

	*)
		echo "Undefined stage $stage" >&2
		;;
esac
