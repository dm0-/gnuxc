gdbm                    := gdbm-1.10.90
gdbm_url                := http://alpha.gnu.org/gnu/gdbm/$(gdbm).tar.gz

configure-gdbm-rule:
	cd $(gdbm) && ./$(configure) \
		--disable-rpath \
		--disable-silent-rules

build-gdbm-rule:
	$(MAKE) -C $(gdbm) all

install-gdbm-rule: $(call installed,glibc)
	$(MAKE) -C $(gdbm) install
