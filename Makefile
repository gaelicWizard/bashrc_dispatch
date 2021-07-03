pkgname = bashrc_dispatch# $Id$
include xdgbasedir.mk# ~/Library/Makefiles/

tools_brcd ?= $(bindir)/$(pkgname)

bashrc_confdir ?= $(sysconfdir)/bash

bashrc_interactive ?= $(bashrc_confdir)/bashrc_interactive
bashrc_login ?= $(bashrc_confdir)/bashrc_login
bashrc_once ?= $(bashrc_confdir)/bashrc_once

bashrc ?= ${HOME}/.bashrc
bash_profile ?= ${HOME}/.bash_profile
bash_login ?= ${HOME}/.bash_login
profile ?= ${HOME}/.profile

envdir ?= $(datarootdir)/MacOSX# ~/Library/Application Support/MacOSX
oldenvdir ?= $(PREFIX)/.MacOSX# ~/.MacOSX
moderobin ?= 555# ugo=rx
moderodata ?= 444# ugo=r
moderw ?= 755# u=rwx,go=rx

INSTALL_BIN ?= install -bCpSv -m $(modeobin)
INSTALL_DATA ?= install -bCpSv -m $(moderodata)
INSTALL_DIR ?= install -d -v -m $(moderw)

GIT ?= /usr/bin/git

# First target is the default target which will be invoked when typing `make`.
all: print-help #autoinstall

autoinstall: $(GIT)
# clone to $TMPDIR/$pkgname then `make -C $TMPDIR/$pkgname install`...

git-pull: $(GIT)
	@$(GIT) pull

install: $(tools_brcd) $(bashrc) $(bash_profile)

$(tools_brcd): $(pkgname) |$(bindir)/
	$(INSTALL) $^ $@

$(bashrc_interactive): |$(bashrc_confdir)/
	echo "[ ! -l $(bashrc) ] && echo mv -vn $(bashrc) $(bashrc_interactive)"

$(bashrc): $(tools_brcd) |$(bashrc_interactive)
	echo ln -svfh $< $@

$(bash_profile): $(tools_brcd) |$(bashrc_once)
	echo ln -svfh $< $@

$(bashrc_login): |$(bashrc_confdir)/
	echo mv -vn $(bash_login) $@

$(bashrc_once): |$(bashrc_confdir)/
	echo mv -vn $(bash_profile) $@

$(bashrc_confdir)/:
	$(INSTALL_DIR) $@

$(bindir)/:
	$(INSTALL_DIR) $@

print-help:
	@echo "Run 'make install' to install to '~'" 

