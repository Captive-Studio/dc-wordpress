# https://github.com/kmmndr/makefile-collection

define ensure_command
	command -v $(1) > /dev/null || (echo "$(1) command is missing !"; exit 1)
endef

help: ##- Show this help.
	@echo 'Usage: make <target> (see target list below)'
	@echo
	@sed -e '/#\{2\}-/!d; s/\\$$//; s/:[^#\t]*/:/; s/#\{2\}-*//' $(MAKEFILE_LIST)
