bash                    := bash-4.4.12
bash_key                := 7C0135FB088AAF6C66C650B9BB5869F064EA74AB
bash_url                := http://ftpmirror.gnu.org/bash/$(bash).tar.gz

export BASH = /bin/bash

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
