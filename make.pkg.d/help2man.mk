help2man                := help2man-1.43.3
help2man_url            := http://ftp.gnu.org/gnu/help2man/$(help2man).tar.gz

prepare-help2man-rule:
	$(PATCH) -d $(help2man) < $(patchdir)/$(help2man)-environment.patch

configure-help2man-rule:
	cd $(help2man) && ./$(configure) \
		--enable-nls

build-help2man-rule:
	$(MAKE) -C $(help2man) all

install-help2man-rule: $(call installed,perl-gettext)
	$(MAKE) -C $(help2man) install
