parallel                := parallel-20151122
parallel_url            := http://ftpmirror.gnu.org/parallel/$(parallel).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure)

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,perl)
	$(MAKE) -C $(builddir) install
