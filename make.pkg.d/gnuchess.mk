gnuchess                := gnuchess-6.1.1
gnuchess_url            := http://ftp.gnu.org/gnu/chess/$(gnuchess).tar.gz

configure-gnuchess-rule:
	cd $(gnuchess) && ./$(configure) \
		--disable-rpath \
		--with-readline

build-gnuchess-rule:
	$(MAKE) -C $(gnuchess) all

install-gnuchess-rule: $(call installed,readline)
	$(MAKE) -C $(gnuchess) install
