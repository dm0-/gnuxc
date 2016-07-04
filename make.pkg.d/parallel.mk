parallel                := parallel-20160622
parallel_sha1           := 8c2e7a7bb6afef106df5a3e6729797985d92522b
parallel_url            := http://ftpmirror.gnu.org/parallel/$(parallel).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure)

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,perl)
	$(MAKE) -C $(builddir) install
