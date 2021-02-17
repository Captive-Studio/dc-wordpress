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

.PHONY: set-local-docker-compose-files
set-local-docker-compose-files:
	$(eval compose_files=-f docker-compose.yml -f docker-compose.local.yml)

# Add local override file before calling target (use: local-<target>)
local-% : set-local-docker-compose-files % ;
