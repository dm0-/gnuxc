cpio                    := cpio-2.11
cpio_url                := http://ftp.gnu.org/gnu/cpio/$(cpio).tar.bz2

prepare-cpio-rule:
	$(PATCH) -d $(cpio) < $(patchdir)/$(cpio)-gets-decl.patch
	$(PATCH) -d $(cpio) < $(patchdir)/$(cpio)-drop-redefined.patch

configure-cpio-rule:
	cd $(cpio) && ./$(configure) \
		--exec-prefix= \
		--libexecdir='$${prefix}/libexec' \
		\
		--disable-rpath \
		--disable-silent-rules \
		--enable-mt \
		--with-rmt=/usr/libexec/rmt

build-cpio-rule:
	$(MAKE) -C $(cpio) all

install-cpio-rule: $(call installed,glibc tar)
	$(MAKE) -C $(cpio) install
