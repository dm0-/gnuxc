cpio                    := cpio-2.11
cpio_url                := http://ftpmirror.gnu.org/cpio/$(cpio).tar.bz2

prepare-cpio-rule:
# Drop unnecessary prototype redefinitions.
	$(DOWNLOAD) 'http://git.savannah.gnu.org/cgit/cpio.git/patch/?id=3a7a1820d4cecbd77c7b74c785af5942510bf080' | $(PATCH) -d $(cpio) -p1
	$(PATCH) -d $(cpio) < $(patchdir)/$(cpio)-gets-decl.patch

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

install-cpio-rule: $(call installed,tar)
	$(MAKE) -C $(cpio) install
