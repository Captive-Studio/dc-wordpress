.PHONY: set-local-docker-compose-files
set-local-docker-compose-files:
	$(eval compose_files=-f docker-compose.yml -f docker-compose.local.yml)

# Add local override file before calling target (use: local-<target>)
local-% : set-local-docker-compose-files % ;
