pkgname = bashrc_dispatch# $Id$
include xdgbasedir.mk# ~/Library/Makefiles/

installed_tool ?= $(bindir)/$(pkgname)

bashrc_confdir ?= ${XDG_CONFIG_HOME}/bash

bashrc_interactive ?= $(bashrc_confdir)/bashrc_interactive
bashrc_login ?= $(bashrc_confdir)/bashrc_login
bashrc_once ?= $(bashrc_confdir)/bashrc_once

bashrc ?= ${HOME}/.bashrc
bash_profile ?= ${HOME}/.bash_profile
bash_login ?= ${HOME}/.bash_login
profile ?= ${HOME}/.profile

envdir ?= $(datarootdir)/MacOSX# ~/Library/Application Support/MacOSX
oldenvdir ?= $(PREFIX)/.MacOSX# ~/.MacOSX
modereadonly ?= 444# ugo=r
moderwdir ?= 755# u=rwx,go=rx

INSTALL ?= install -bCpSv -m $(modereadonly)
INSTALL_DIR ?= install -d -v -m $(moderwdir)

GIT ?= /usr/bin/git

# First target is the default target which will be invoked when typing `make`.
all: print-help #autoinstall

autoinstall: $(GIT)
# clone to $TMPDIR/$pkgname then `make -C $TMPDIR/$pkgname install`...

git-pull: $(GIT)
	@$(GIT) pull

install: $(installed_tool) $(bashrc) $(bash_profile)

$(installed_tool): $(pkgname) |$(bindir)/
	$(INSTALL) $^ $@

$(bashrc_interactive): |$(bashrc_confdir)/
	echo "[ ! -l $(bashrc) ] && echo mv -vn $(bashrc) $(bashrc_interactive)"

$(bashrc): $(installed_tool) |$(bashrc_interactive)
	echo ln -svfh $< $@

$(bash_profile): $(installed_tool) |$(bashrc_login)
	echo ln -svfh $< $@

$(bashrc_confdir)/:
	$(INSTALL_DIR) $@

$(bindir)/:
	$(INSTALL_DIR) $@

print-help:
	@echo "Run 'make install' to install to '~'" 

