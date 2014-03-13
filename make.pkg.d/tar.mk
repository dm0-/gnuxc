tar                     := tar-1.27
tar_url                 := http://ftp.gnu.org/gnu/tar/$(tar).tar.xz

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
		--without-included-regex

build-tar-rule:
	$(MAKE) -C $(tar) all

install-tar-rule: $(call installed,acl)
	$(MAKE) -C $(tar) install
