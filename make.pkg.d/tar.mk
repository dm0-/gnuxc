tar                     := tar-1.26
tar_url                 := http://ftp.gnu.org/gnu/tar/$(tar).tar.xz

prepare-tar-rule:
	$(PATCH) -d $(tar) < $(patchdir)/$(tar)-gets-decl.patch

configure-tar-rule:
	cd $(tar) && ./$(configure) \
		--exec-prefix= \
		--libexecdir='$${prefix}/libexec' \
		\
		--disable-rpath \
		--disable-silent-rules \
		--enable-backup-scripts \
		--without-included-regex

build-tar-rule:
	$(MAKE) -C $(tar) all

install-tar-rule: $(call installed,glibc)
	$(MAKE) -C $(tar) install
