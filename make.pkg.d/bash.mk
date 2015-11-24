bash                    := bash-4.3.42
bash_branch             := bash-4.3.30
bash_url                := http://ftpmirror.gnu.org/bash/$(bash_branch).tar.gz

export BASH = /bin/bash

$(prepare-rule):
	$(DOWNLOAD) 'http://ftpmirror.gnu.org/bash/bash-4.3-patches/'bash43-{031..0$(lastword $(subst ., ,$(bash)))} | $(PATCH) -d $(builddir)

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--exec-prefix= \
		\
		--disable-rpath \
		--enable-alias \
		--enable-arith-for-command \
		--enable-array-variables \
		--enable-bang-history \
		--enable-brace-expansion \
		--enable-casemod-attributes \
		--enable-casemod-expansions \
		--enable-command-timing \
		--enable-cond-command \
		--enable-cond-regexp \
		--enable-coprocesses \
		--enable-debugger \
		--enable-directory-stack \
		--enable-dparen-arithmetic \
		--enable-extended-glob \
		--enable-extended-glob-default \
		--enable-help-builtin \
		--enable-history \
		--enable-job-control \
		--enable-mem-scramble \
		--enable-multibyte \
		--enable-net-redirections \
		--enable-process-substitution \
		--enable-progcomp \
		--enable-readline \
		--enable-restricted \
		--enable-select \
		--with-installed-readline \
		--without-included-gettext

$(build-rule):
	$(MAKE) -C $(builddir) all \
		CPPFLAGS=-DRECYCLES_PIDS

$(install-rule): $$(call installed,readline)
	$(MAKE) -C $(builddir) install \
		DESTDIR='$(DESTDIR)'
	$(SYMLINK) bash $(DESTDIR)/bin/rbash
	$(SYMLINK) bash $(DESTDIR)/bin/sh
