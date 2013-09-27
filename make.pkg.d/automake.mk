automake                := automake-1.14
automake_url            := http://ftp.gnu.org/gnu/automake/$(automake).tar.xz

configure-automake-rule:
	cd $(automake) && ./$(configure) \
		--disable-silent-rules

build-automake-rule:
	$(MAKE) -C $(automake) all

install-automake-rule: $(call installed,perl)
	$(MAKE) -C $(automake) install
