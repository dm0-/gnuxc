automake                := automake-1.14.1
automake_url            := http://ftpmirror.gnu.org/automake/$(automake).tar.xz

configure-automake-rule:
	cd $(automake) && ./$(configure) \
		--disable-silent-rules

build-automake-rule:
	$(MAKE) -C $(automake) all

install-automake-rule: $(call installed,perl)
	$(MAKE) -C $(automake) install
