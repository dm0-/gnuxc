gperf                   := gperf-3.0.4
gperf_sha1              := e32d4aff8f0c730c9a56554377b2c6d82d0951b8
gperf_url               := http://ftpmirror.gnu.org/gperf/$(gperf).tar.gz

$(configure-rule):
	cd $(builddir) && ./$(configure)

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,gcc)
	$(MAKE) -C $(builddir) install \
		htmldir='$$(datarootdir)/doc/gperf'
