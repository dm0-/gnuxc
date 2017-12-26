sed                     := sed-4.4
sed_key                 := 155D3FC500C834486D1EEA677FD9FCCB000BEEEE
sed_url                 := http://ftpmirror.gnu.org/sed/$(sed).tar.xz

export SED = /bin/sed

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--exec-prefix= \
		\
		--disable-rpath \
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
