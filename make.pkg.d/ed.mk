ed                      := ed-1.10
ed_url                  := http://ftp.gnu.org/gnu/ed/$(ed).tar.lz

prepare-ed-rule:
	$(PATCH) -d $(ed) < $(patchdir)/$(ed)-environment.patch

configure-ed-rule:
	cd $(ed) && ./$(configure) \
		--exec-prefix=

build-ed-rule:
	$(MAKE) -C $(ed) all

install-ed-rule: $(call installed,glibc)
	$(MAKE) -C $(ed) install
