bash                    := bash-4.4.12
bash_branch             := bash-4.4
bash_sha1               := 8de012df1e4f3e91f571c3eb8ec45b43d7c747eb
bash_url                := http://ftpmirror.gnu.org/bash/$(bash_branch).tar.gz

$(eval $(call verify-download,$(foreach l,01 02 03 04 05 06 07 08 09 10 11 12,http://ftpmirror.gnu.org/bash/$(bash_branch)-patches/bash44-0$l),7803db5ed29c547bddb2326afc20eb618ec5ef42,fixes.patch))

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
		--enable-function-import \
		--enable-glob-asciiranges-default \
		--enable-help-builtin \
		--enable-history \
		--enable-job-control \
		--enable-mem-scramble \
		--enable-multibyte \
		--enable-net-redirections \
		--enable-process-substitution \
		--enable-progcomp \
		--enable-prompt-string-decoding \
		--enable-readline \
		--enable-restricted \
		--enable-select \
		--with-curses \
		--with-installed-readline \
		--without-included-gettext \
		CPPFLAGS=-DRECYCLES_PIDS

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,readline)
	$(MAKE) -C $(builddir) install \
		DESTDIR='$(DESTDIR)'
	$(SYMLINK) bash $(DESTDIR)/bin/rbash
	$(SYMLINK) bash $(DESTDIR)/bin/sh
