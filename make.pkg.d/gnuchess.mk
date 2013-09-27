gnuchess                := gnuchess-6.0.92
gnuchess_url            := http://alpha.gnu.org/gnu/chess/$(gnuchess).tar.gz

prepare-gnuchess-rule:
	$(PATCH) -d $(gnuchess) < $(patchdir)/$(gnuchess)-include-locale.patch

configure-gnuchess-rule:
	cd $(gnuchess) && ./$(configure) \
		--disable-rpath \
		--with-readline

build-gnuchess-rule:
	$(MAKE) -C $(gnuchess) all

install-gnuchess-rule: $(call installed,readline)
	$(MAKE) -C $(gnuchess) install
