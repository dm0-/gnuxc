coreutils               := coreutils-8.28
coreutils_key           := 6C37DC12121A5006BC1DB804DF6FD971306037D9
coreutils_url           := http://ftpmirror.gnu.org/coreutils/$(coreutils).tar.xz

export SORT = /bin/sort

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--exec-prefix= \
		--libexecdir='$${prefix}/libexec' \
		\
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

$(build-rule):
	$(MAKE) -C $(builddir) all \
		$(and $(filter-out $(host),$(build)),man1_MANS=)

$(install-rule): $$(call installed,acl gmp)
	$(MAKE) -C $(builddir) install \
		$(and $(filter-out $(host),$(build)),INSTALL=install man1_MANS=)
	$(INSTALL) -dm 0755 $(DESTDIR)/usr/bin
	$(SYMLINK) ../../bin/env $(DESTDIR)/usr/bin/env
	$(INSTALL) -Dpm 0644 $(call addon-file,bashrc.sh) $(DESTDIR)/etc/bashrc.d/coreutils.sh
	$(INSTALL) -Dpm 0644 $(call addon-file,profile.sh) $(DESTDIR)/etc/profile.d/coreutils.sh

# Write inline files.
$(call addon-file,bashrc.sh profile.sh): | $$(@D)
	$(file >$@,$(contents))
$(prepared): $(call addon-file,bashrc.sh profile.sh)


# Provide a bash alias to color "ls" and define some common "ls" abbreviations.
override define contents
alias ls='ls --color=auto'
alias l='ls -1A'
alias la='ls -al'
alias ll='ls -Al'
endef
$(call addon-file,bashrc.sh): private override contents := $(value contents)


# Provide a bash profile setting to color "ls" output based on the terminal.
$(call addon-file,profile.sh): private override contents := eval $$(dircolors --sh)
