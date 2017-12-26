cpio                    := cpio-2.12
cpio_key                := 325F650C4C2B6AD58807327A3602B07F55D0C732
cpio_url                := http://ftpmirror.gnu.org/cpio/$(cpio).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--exec-prefix= \
		--libexecdir='$${prefix}/libexec' \
		\
		--disable-rpath \
		--enable-mt \
		--with-rmt=/usr/libexec/rmt

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,tar)
	$(MAKE) -C $(builddir) install
