coreutils               := coreutils-8.23
coreutils_url           := http://ftpmirror.gnu.org/coreutils/$(coreutils).tar.xz

ifneq ($(host),$(build))
prepare-coreutils-rule:
	$(EDIT) \
		-e '/run_help2man/{/SHELL/s/^@[^@]*@//;/PERL/s/^@[^@]*@/#/;}' \
		-e '/^[ \t]*--output=/{h;d};/^[ \t]*--info-page=/G' \
		$(coreutils)/Makefile.in
endif

configure-coreutils-rule:
	cd $(coreutils) && ./$(configure) \
		--exec-prefix= \
		--libexecdir='$${prefix}/libexec' \
		\
		--disable-silent-rules \
		--disable-single-binary \
		--disable-rpath \
		--enable-acl \
		--enable-assert \
		--enable-gcc-warnings gl_cv_warn_c__Werror=no \
		--enable-no-install-program= \
		--enable-threads=posix \
		--enable-xattr \
		--with-gmp \
		--without-included-regex \
		\
		--disable-libcap \
		--disable-libsmack \
		--without-selinux

build-coreutils-rule:
	$(MAKE) -C $(coreutils) all

install-coreutils-rule: $(call installed,acl gmp)
	$(MAKE) -C $(coreutils) install
	$(INSTALL) -dm 755 $(DESTDIR)/usr/bin
	$(SYMLINK) ../../bin/env $(DESTDIR)/usr/bin/env
	$(INSTALL) -Dpm 644 $(coreutils)/bashrc.sh $(DESTDIR)/etc/bashrc.d/coreutils.sh
	$(INSTALL) -Dpm 644 $(coreutils)/profile.sh $(DESTDIR)/etc/profile.d/coreutils.sh

# Provide a bash profile setting to color "ls" output based on the terminal.
$(coreutils)/profile.sh: | $(coreutils)
	$(ECHO) 'eval $$(dircolors --sh)' > $@
$(call prepared,coreutils): $(coreutils)/profile.sh

# Provide a bash alias to color "ls" and define some common "ls" abbreviations.
$(coreutils)/bashrc.sh: | $(coreutils)
	$(ECHO) -e "alias ls='ls --color=auto'\nalias l='ls -1A'\nalias la='ls -al'\nalias ll='ls -Al'" > $@
$(call prepared,coreutils): $(coreutils)/bashrc.sh
