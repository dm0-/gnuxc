ed                      := ed-1.10
ed_url                  := http://ftpmirror.gnu.org/ed/$(ed).tar.lz

configure-ed-rule:
	cd $(ed) && ./$(configure) \
		--exec-prefix= \
		CC='$(CC)' \
		CFLAGS='$(CFLAGS)' \
		CPPFLAGS='$(CPPFLAGS)' \
		LDFLAGS='$(LDFLAGS)'

build-ed-rule:
	$(MAKE) -C $(ed) all

install-ed-rule: $(call installed,glibc)
	$(MAKE) -C $(ed) install
