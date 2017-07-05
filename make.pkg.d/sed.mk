sed                     := sed-4.4
sed_sha1                := a196cd036efd52a8e349cfe88ab4baa555fb29d5
sed_url                 := http://ftpmirror.gnu.org/sed/$(sed).tar.xz

export SED = /bin/sed

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--exec-prefix= \
		\
		--disable-rpath \
		--disable-silent-rules \
		--enable-acl \
		--enable-assert \
		--enable-gcc-warnings \
		--enable-threads=posix \
		--without-included-regex \
		--without-selinux

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,glibc)
	$(MAKE) -C $(builddir) install
