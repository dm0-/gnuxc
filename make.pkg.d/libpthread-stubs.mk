libpthread-stubs        := libpthread-stubs-0.3
libpthread-stubs_url    := http://xcb.freedesktop.org/dist/$(libpthread-stubs).tar.bz2

configure-libpthread-stubs-rule:
	cd $(libpthread-stubs) && ./$(configure) \
		LIBS=-lpthread

build-libpthread-stubs-rule:
	$(MAKE) -C $(libpthread-stubs) all

install-libpthread-stubs-rule: $(call installed,libpthread)
	$(MAKE) -C $(libpthread-stubs) install
