json-c                  := json-c-0.12.1
json-c_branch           := json-c-$(json-c)-20160607
json-c_sha1             := 3348f4184ddfee506989e9ea1ddb3d689391c7e2
json-c_url              := http://github.com/json-c/json-c/archive/$(json-c_branch:json-c-%=%).tar.gz

$(prepare-rule):
# Remove bad hard-coded settings.
	$(EDIT) 's/ -Werror / /g' $(builddir)/Makefile.am.inc
	$(RM) $(builddir)/configure

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-rdrand

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,glibc)
	$(MAKE) -C $(builddir) install
