###########################
# Advanced Usage below.
###########################

MAKEFILE_PATH = $(strip $(dir $(firstword $(MAKEFILE_LIST))))
PACKAGE_SHELL_INCLUDE_PATH=$(MAKEFILE_PATH)/package_shell/make

include $(MAKEFILE_PATH)/base.gmk

# The following are optional in base.gmk ,
# but must be set before the other stuff loads
ifeq ($(BASE_DIR),)
	BASE_DIR := /opt/IAS
endif

include $(MAKEFILE_PATH)/package_shell/main.gmk


