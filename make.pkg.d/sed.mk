sed                     := sed-4.2.2
sed_url                 := http://ftpmirror.gnu.org/sed/$(sed).tar.bz2

export SED = /bin/sed

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--exec-prefix= \
		\
		--disable-rpath \
		--without-included-regex \
		--without-selinux

$(build-rule):
	$(MAKE) -C $(builddir) all \
		CPPFLAGS=-DPATH_MAX=4096

$(install-rule): $$(call installed,glibc)
	$(MAKE) -C $(builddir) install
