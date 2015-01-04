tar                     := tar-1.28
tar_url                 := http://ftpmirror.gnu.org/tar/$(tar).tar.xz

configure-tar-rule:
	cd $(tar) && ./$(configure) \
		--exec-prefix= \
		--libexecdir='$${prefix}/libexec' \
		\
		--disable-rpath \
		--disable-silent-rules \
		--enable-acl \
		--enable-backup-scripts \
		--enable-gcc-warnings gl_cv_warn_c__Werror=no \
		--with-posix-acls \
		--without-included-regex

build-tar-rule:
	$(MAKE) -C $(tar) all

install-tar-rule: $(call installed,acl)
	$(MAKE) -C $(tar) install
	$(INSTALL) -Dpm 644 $(tar)/bashrc.sh $(DESTDIR)/etc/bashrc.d/tar.sh

# Provide a bash alias to call "tar" without worrying which users are defined.
$(tar)/bashrc.sh: | $(tar)
	$(ECHO) "alias dtar='tar --no-same-owner --numeric-owner --owner=0 --group=0 --preserve-order --preserve-permissions'" > $@
$(call prepared,tar): $(tar)/bashrc.sh
