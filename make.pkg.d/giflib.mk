giflib                  := giflib-5.1.0
giflib_url              := http://prdownloads.sourceforge.net/giflib/$(giflib).tar.bz2

configure-giflib-rule:
	cd $(giflib) && ./$(configure) \
		--disable-silent-rules

build-giflib-rule:
	$(MAKE) -C $(giflib) all

install-giflib-rule: $(call installed,glibc)
	$(MAKE) -C $(giflib) install
