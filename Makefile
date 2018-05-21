PROJECT_NAME = ias-python3-script-infra

BASE_DIR = /opt/IAS

SHELL_PWD = $(shell echo `pwd`)
MAKEFILE_PATH = $(strip $(dir $(realpath $(firstword $(MAKEFILE_LIST)))))

PROJECT_DIR = $(MAKEFILE_PATH)
SCRATCH_AREA = $(SHELL_PWD)

# PROJECT_DIR = $(SHELL_PWD)

CHANGELOG_FILE = $(PROJECT_DIR)/$(PROJECT_NAME)/changelog

RELEASE_VERSION := $(shell cat '$(CHANGELOG_FILE)' | grep -v '^\s+$$' | head -n 1 | awk '{print $$2}')
ARCH := $(shell cat $(CHANGELOG_FILE) | grep -v '^\s+$$' | head -n 1 | awk '{print $$3}'|sed 's/;//')
SRC_VERSION := $(shell echo '$(RELEASE_VERSION)' | awk -F '-' '{print $$1}')
PKG_VERSION := $(shell echo '$(RELEASE_VERSION)' | awk -F '-' '{print $$2}')

SRC_DIR = $(PROJECT_DIR)/src

DROP_DIR = $(SCRATCH_AREA)/drop
BUILD_DIR = $(SCRATCH_AREA)/build
SPEC_FILE_NAME = $(PROJECT_NAME)-$(RELEASE_VERSION)--pkginfo.spec
SPEC_FILE = $(BUILD_DIR)/$(SPEC_FILE_NAME)
ROOT_DIR = $(BUILD_DIR)/root

INST_DIR = $(BASE_DIR)/$(PROJECT_NAME)

BIN_DIR=$(BASE_DIR)/bin/$(PROJECT_NAME)
BIN_INST_DIR=$(ROOT_DIR)/$(BIN_DIR)

CGI_BIN_DIR=$(BASE_DIR)/cgi-bin/$(PROJECT_NAME)
CGI_BIN_INST_DIR=$(ROOT_DIR)/$(CGI_BIN_DIR)

LIB_DIR=$(BASE_DIR)/lib
LIB_INST_DIR=$(ROOT_DIR)/$(LIB_DIR)

DOC_DIR=$(BASE_DIR)/doc/$(PROJECT_NAME)
DOC_INST_DIR=$(ROOT_DIR)$(DOC_DIR)

TEMPLATE_DIR=$(BASE_DIR)/templates/$(PROJECT_NAME)
TEMPLATE_INST_DIR=$(ROOT_DIR)/$(TEMPLATE_DIR)

# Directories for FullProjectPath type apps:
INPUT_DIR=$(BASE_DIR)/input/$(PROJECT_NAME)
OUTPUT_DIR=$(BASE_DIR)/output/$(PROJECT_NAME)
CONF_DIR=$(BASE_DIR)/etc/$(PROJECT_NAME)
LOG_DIR=$(BASE_DIR)/log/$(PROJECT_NAME)


DEB_DIR=$(ROOT_DIR)/DEBIAN
DEB_CONTROL_FILE=$(DEB_DIR)/control
DEB_CONF_FILES_FILE=$(DEB_DIR)/conffiles

SUMMARY := $(shell egrep '^Summary:' ./$(PROJECT_NAME)/rpm_specific | awk -F ':' '{print $$2}')

all:

clean:
	-rm -rf build

debug:
	# PROJECT_NAME: '$(PROJECT_NAME)'
	# MAKEFILE_PATH: '$(MAKEFILE_PATH)'
	# CHANGELOG_FILE: '$(CHANGELOG_FILE)'
	# RELEASE_VERSION: '$(RELEASE_VERSION)'
	# ARCH: '$(ARCH)'
	# SRC_VERSION: '$(SRC_VERSION)'
	# PKG_VERSION: '$(PKG_VERSION)'
	# SHELL_PWD: '$(SHELL_PWD)'
	# PROJECT_DIR: '$(PROJECT_DIR)'
	# DROP_DIR: '$(DROP_DIR)'
	# BUILD_DIR: '$(BUILD_DIR)'
	# SPEC_FILE_NAME: '$(SPEC_FILE_NAME)'
	# SPEC_FILE: '$(SPEC_FILE)'
	# SRC_DIR: '$(SRC_DIR)'
	# ROOT_DIR: '$(ROOT_DIR)'
	# BASE_DIR: '$(BASE_DIR)'
	# INST_DIR: '$(INST_DIR)'
	
	# BIN_DIR: '$(BIN_DIR)'
	# BIN_INST_DIR: '$(BIN_INST_DIR)'

	# CGI_BIN_DIR: '$(CGI_BIN_DIR)'
	# CGI_BIN_INST_DIR: '$(CGI_BIN_INST_DIR)'

	# LIB_DIR: '$(LIB_DIR)'
	# LIB_INST_DIR: '$(LIB_INST_DIR)'
	
	# DOC_DIR: '$(DOC_DIR)'
	# DOC_INST_DIR: '$(DOC_INST_DIR)'

	# INPUT_DIR: '$(INPUT_DIR)'
	# OUTPUT_DIR: '$(OUTPUT_DIR)'
	# CONF_DIR: '$(CONF_DIR)'
	# LOG_DIR: '$(LOG_DIR)'
	# TEMPLATE_DIR '$(TEMPLATE_DIR)'

package-rpm: clean all install rpmspec rpmbuild

package-deb: clean all install debsetup debbuild

release: test-all

test-all: test test-doc

test:
	
	# Sytax checking routines.
ifneq ("$(wildcard $(SRC_DIR)/bin/*.pl)","")
	# Running Perl Tests
	find $(SRC_DIR)/bin -type f \
		-name '*.pl' \
	| xargs -r perl -c 
	
endif

ifneq ("$(wildcard $(SRC_DIR)/bin/*.sh)","")
	# Running Bash Tests
	find $(SRC_DIR)/bin -type f \
		-name '*.sh' \
	| xargs -r -n1 bash -n 
	
endif

ifneq ("$(wildcard $(SRC_DIR)/bin/*.py)","") 
	# Running Python Tests
	find $(SRC_DIR)/bin -type f \
		-name '*.py' \
	| xargs -r -n1 python -m py_compile
endif

ifneq ("$(wildcard $(SRC_DIR)/bin/*.rb)","")
	# Running Ruby Tests
	find $(SRC_DIR)/bin -type f \
		-name '*.rb' \
	| xargs -r -n1 ruby -c
endif

test-doc:
	find $(SRC_DIR) -type f \
		-name '*.pl' \
		-o -name '*.pm' \
	| xargs -r podchecker
	
builddir:
	if [ ! -d build ]; then mkdir build; fi;

self-replicate: install
	# Self Replicating
	# This will put a copy of the source tree in a tar.gz file
	# in the doc dir.
	
	ls | egrep -v '(build|\.svn)' | \
		xargs -n1 -i cp -r {} ./build/$(PROJECT_NAME)-$(RELEASE_VERSION)/
	
	cd build && tar czvf $(PROJECT_NAME)-$(RELEASE_VERSION).tar.gz \
		$(PROJECT_NAME)-$(RELEASE_VERSION)
	
	mv build/$(PROJECT_NAME)-$(RELEASE_VERSION).tar.gz $(DOC_INST_DIR)/


install: builddir

	# META-Docs by default are added.
	
	mkdir -p $(DOC_INST_DIR)
	cp $(PROJECT_NAME)/changelog $(DOC_INST_DIR)/
	cp $(PROJECT_NAME)/description $(DOC_INST_DIR)/
	cp README* $(DOC_INST_DIR)
	find $(DOC_INST_DIR) -type f | xargs chmod 644

	# Directories for FullProjectPath type apps:

	mkdir -p $(ROOT_DIR)/$(INPUT_DIR)
	mkdir -p $(ROOT_DIR)/$(OUTPUT_DIR)
	mkdir -p $(ROOT_DIR)/$(LOG_DIR)


# Conditional additions

ifneq ("$(wildcard $(SRC_DIR)/run_scripts/*)","")
	# Installing run scripts
	cp -r $(SRC_DIR)/run_scripts $(DOC_INST_DIR)/run_scripts

endif

ifneq ("$(wildcard $(PROJECT_DIR)/doc/*)","") 
	# Installing more documentation
	mkdir -p $(DOC_INST_DIR)
	cp -r $(PROJECT_DIR)/doc $(DOC_INST_DIR)/doc
	find $(DOC_INST_DIR) -type f | xargs -r chmod 644
endif

ifneq ("$(wildcard $(SRC_DIR)/bin/*)","") 
	# Installing binaries.
	mkdir -p $(ROOT_DIR)/$(BIN_DIR)
	cp -r $(SRC_DIR)/bin/* $(ROOT_DIR)/$(BIN_DIR)
	find $(BIN_INST_DIR) -type f | xargs -r chmod 755
endif

ifneq ("$(wildcard $(SRC_DIR)/cgi-bin/*)","") 
	# Installing CGI-BIN files
	mkdir -p $(ROOT_DIR)/$(CGI_BIN_DIR)
	-cp -r $(SRC_DIR)/cgi-bin/* $(ROOT_DIR)/$(CGI_BIN_DIR)
	-find $(CGI_BIN_INST_DIR) -type f | xargs -r chmod 755
endif
	
ifneq ("$(wildcard $(SRC_DIR)/templates/*)","") 
	# Installing Templates
	mkdir -p $(TEMPLATE_INST_DIR)
	cp -r $(SRC_DIR)/templates/* $(TEMPLATE_INST_DIR)
	find $(TEMPLATE_INST_DIR) -type f | xargs -r chmod 644
endif

# lib
ifneq ("$(wildcard $(SRC_DIR)/lib/*)","")	
	# Installing libraries
	mkdir -p $(LIB_INST_DIR)
	cp -r $(SRC_DIR)/lib/* $(LIB_INST_DIR)
	find $(SRC_DIR)/lib/ | xargs -r chmod 644
endif

ifneq ("$(wildcard $(SRC_DIR)/etc/*)","")
	# Installing project directory configuration
	mkdir -p $(ROOT_DIR)/$(CONF_DIR)
	cp -r $(SRC_DIR)/etc/* $(ROOT_DIR)/$(CONF_DIR)/
	chmod 0644 $(ROOT_DIR)/$(CONF_DIR)
endif

ifneq ("$(wildcard $(SRC_DIR)/root_etc/*)","")
	# Installing things to /etc
	cp -r $(SRC_DIR)/root_etc $(ROOT_DIR)/etc
	chmod -R 0644 $(ROOT_DIR)/etc
endif


	# Set up directories
	chmod -R a+r $(ROOT_DIR)
	-find $(ROOT_DIR) -type d -exec chmod a+rx {} \;

	################
	# Some Final Cleanup
	# This shouldn't need to happen if you're building from an export
	
	# Subversion
	-find $(ROOT_DIR) -type d -name '.svn' -exec rm -r {} \;

	# vi
	-find $(ROOT_DIR) -type f -name '*.swp' -exec rm -r {} \;
	
	# python
	-find $(ROOT_DIR) -type d -name '__pycache__' -exec rm -r {} \;
	-find $(ROOT_DIR) -type f -name '*.pyc' -exec rm -r {} \;
	
	
	################
	# An example of creating a file owned by
	# a non-root user (your system must have
	# fakeroot installed and working):
	# touch $(ROOT_DIR)/drop
	# chown somegroup:somegroup $(ROOT_DIR)/drop
	

rpmspec: install
	echo "" > $(SPEC_FILE)
	echo "Name: $(PROJECT_NAME)" >> $(SPEC_FILE)
	echo "Version: $(SRC_VERSION)" >> $(SPEC_FILE)
	echo "Release: $(PKG_VERSION)" >> $(SPEC_FILE)
	echo "BuildArch: $(ARCH)" >> $(SPEC_FILE)
	echo `svn info |grep '^URL:'` >> $(SPEC_FILE)
	echo "Packager: $$USER" >> $(SPEC_FILE)
	
	# cat ./$(PROJECT_NAME)/pkginfo >> $(SPEC_FILE)
	cat ./$(PROJECT_NAME)/rpm_specific >> $(SPEC_FILE)
	for file in $(PROJECT_NAME)/install_scripts/*; do echo "%"`basename $$file` >> $(SPEC_FILE); cat $$file >> $(SPEC_FILE); done
	echo "%description" >> $(SPEC_FILE)
	cat ./$(PROJECT_NAME)/description >> $(SPEC_FILE)
	echo "" >> $(SPEC_FILE)

	echo "%files" >> $(SPEC_FILE)

	# These are created by default
	echo "%defattr(644, root, root, 755)" >> $(SPEC_FILE)
	echo "$(DOC_DIR)" >> $(SPEC_FILE)
	
	echo "%defattr(664, root, root, 755) " >> $(SPEC_FILE)
	echo "$(INPUT_DIR)" >> $(SPEC_FILE)
	
	echo "%defattr(664, root, root, 755) " >> $(SPEC_FILE)
	echo "$(OUTPUT_DIR)" >> $(SPEC_FILE)
	
	echo "%defattr(664, root, root, 755) " >> $(SPEC_FILE)
	echo "$(LOG_DIR)" >> $(SPEC_FILE)

# Binaries
ifneq ("$(wildcard $(SRC_DIR)/bin/*)","")
	echo "%defattr(755, root, root, 755) " >> $(SPEC_FILE)
	echo "$(BIN_DIR)" >> $(SPEC_FILE)
endif

# cgi-bin
ifneq ("$(wildcard $(SRC_DIR)/cgi-bin/*)","")
	echo "%defattr(755, root, root, 755) " >> $(SPEC_FILE)
	echo "$(CGI_BIN_DIR)" >> $(SPEC_FILE)
endif

# Templates
ifneq ("$(wildcard $(SRC_DIR)/templates/*)","")	
	echo "%defattr(664, root, root, 755) " >> $(SPEC_FILE)
	echo "$(TEMPLATE_DIR)" >> $(SPEC_FILE)
endif

# Libraries
ifneq ("$(wildcard $(SRC_DIR)/lib/*)","")
	echo "%defattr(644, root, root,755) " >> $(SPEC_FILE)
	echo "$(LIB_DIR)" >> $(SPEC_FILE)
endif

# Project Config, example /opt/IAS/etc/(project-name)
ifneq ("$(wildcard $(SRC_DIR)/etc/*)","")
	echo "%defattr(644, root, root,755) " >> $(SPEC_FILE)
	echo "%dir $(CONF_DIR)" >> $(SPEC_FILE)
	-find $(ROOT_DIR)/$(CONF_DIR) -type f | sed -r "s|$(ROOT_DIR)|%config |"  >> $(SPEC_FILE)
endif

ifneq ("$(wildcard $(SRC_DIR)/root_etc/*)","")
	# /etc/ config files
	-find $(ROOT_DIR)/etc -type f |  sed -r "s|$(ROOT_DIR)|%config(noreplace) |" >> $(SPEC_FILE)
endif


cp-rpmspec: builddir
	cp $(PROJECT_NAME)/$(SPEC_FILE_NAME) $(SPEC_FILE)

rpmbuild:
	rpmbuild --buildroot $(ROOT_DIR) -bb $(SPEC_FILE) --define '_topdir $(BUILD_DIR)' --define '_rpmtopdir $(BUILD_DIR)'
	
debsetup:
	mkdir -p $(DEB_DIR)
	echo "Package: " $(PROJECT_NAME) >> $(DEB_CONTROL_FILE)
	echo "Version: " $(RELEASE_VERSION) >> $(DEB_CONTROL_FILE)
	cat $(PROJECT_NAME)/deb_control >> $(DEB_CONTROL_FILE)
	
	echo "Description: " $(SUMMARY) >> $(DEB_CONTROL_FILE)
	cat ./$(PROJECT_NAME)/description | egrep -v '^\s*$$' | sed 's/^/ /' >> $(DEB_CONTROL_FILE)

# Project Config, example /opt/IAS/etc/(project-name)
ifneq ("$(wildcard $(SRC_DIR)/etc/*)","")
	-find $(ROOT_DIR)/$(CONF_DIR) -type f | sed -r "s|$(ROOT_DIR)||" >> $(DEB_CONF_FILES_FILE)
endif

ifneq ("$(wildcard $(SRC_DIR)/root_etc/*)","")
	# /etc/ config files
	-find $(ROOT_DIR)/etc -type f |  sed -r "s|$(ROOT_DIR)||" >> $(DEB_CONF_FILES_FILE)
endif
	
debbuild:
	dpkg-deb --build $(ROOT_DIR) $(BUILD_DIR)
