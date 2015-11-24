tar                     := tar-1.28
tar_url                 := http://ftpmirror.gnu.org/tar/$(tar).tar.xz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
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

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,acl)
	$(MAKE) -C $(builddir) install
	$(INSTALL) -Dpm 644 $(call addon-file,bashrc.sh) $(DESTDIR)/etc/bashrc.d/tar.sh

# Write inline files.
$(call addon-file,bashrc.sh): | $$(@D)
	$(file >$@,$(contents))
$(prepared): $(call addon-file,bashrc.sh)


# Provide a bash alias to call "tar" without worrying which users are defined.
override define contents
alias dtar='tar --no-same-owner --numeric-owner --owner=0 --group=0 --preserve-order --preserve-permissions'
endef
$(call addon-file,bashrc.sh): private override contents := $(value contents)
