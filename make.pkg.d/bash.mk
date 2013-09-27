bash                    := bash-4.2.45
bash_branch             := bash-4.2
bash_url                := http://ftp.gnu.org/gnu/bash/$(bash_branch).tar.gz

export BASH = /bin/bash

prepare-bash-rule:
	for n in {001..045} ; do \
		$(DOWNLOAD) http://ftp.gnu.org/gnu/bash/$(bash_branch)-patches/bash42-$$n | \
		$(PATCH) -d $(bash) ; \
	done
	$(PATCH) -d $(bash) < $(patchdir)/$(bash)-environment.patch

configure-bash-rule:
	cd $(bash) && ./$(configure) \
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
		--enable-job-control bash_cv_job_control_missing=no \
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

build-bash-rule:
	$(MAKE) -C $(bash) all \
		CPPFLAGS=-DRECYCLES_PIDS

install-bash-rule: $(call installed,readline)
	$(MAKE) -C $(bash) install
	$(SYMLINK) bash $(DESTDIR)/bin/rbash
	$(SYMLINK) bash $(DESTDIR)/bin/sh
