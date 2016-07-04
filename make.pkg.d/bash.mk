bash                    := bash-4.3.46
bash_branch             := bash-4.3.30
bash_sha1               := 33b1bcc5dca1b72f28b2baeca6efa0d422097964
bash_url                := http://ftpmirror.gnu.org/bash/$(bash_branch).tar.gz

$(eval $(call verify-download,$(foreach l,31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46,http://ftpmirror.gnu.org/bash/bash-4.3-patches/bash43-0$l),ad1dabb17a54131423ff88de0d6301cbf4856828,fixes.patch))

export BASH = /bin/bash

$(prepare-rule):
	$(PATCH) -d $(builddir) < $(call addon-file,fixes.patch)

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
