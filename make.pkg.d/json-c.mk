json-c                  := json-c-0.13
json-c_branch           := json-c-$(json-c)-20171207
json-c_sha1             := 6fc7fdd11eadd5a05e882df11bb4998219615de2
json-c_url              := http://github.com/json-c/json-c/archive/$(json-c_branch:json-c-%=%).tar.gz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-rdrand \
		--enable-threading

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,glibc)
	$(MAKE) -C $(builddir) install
