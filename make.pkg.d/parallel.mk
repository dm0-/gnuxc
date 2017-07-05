parallel                := parallel-20170622
parallel_sha1           := 9f3b82c63543fc9c55395d372c905dc34fc09c05
parallel_url            := http://ftpmirror.gnu.org/parallel/$(parallel).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure)

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,perl)
	$(MAKE) -C $(builddir) install
