gnuchess                := gnuchess-6.2.0
gnuchess_url            := http://ftpmirror.gnu.org/chess/$(gnuchess).tar.gz

configure-gnuchess-rule:
	cd $(gnuchess) && ./$(configure) \
		--disable-rpath \
		--with-readline

build-gnuchess-rule:
	$(MAKE) -C $(gnuchess) all

install-gnuchess-rule: $(call installed,readline)
	$(MAKE) -C $(gnuchess) install
