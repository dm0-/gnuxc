cpio                    := cpio-2.12
cpio_url                := http://ftpmirror.gnu.org/cpio/$(cpio).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--exec-prefix= \
		--libexecdir='$${prefix}/libexec' \
		\
		--disable-rpath \
		--disable-silent-rules \
		--enable-mt \
		--with-rmt=/usr/libexec/rmt

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,tar)
	$(MAKE) -C $(builddir) install
