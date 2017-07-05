gperf                   := gperf-3.1
gperf_sha1              := e3c0618c2d2e5586eda9498c867d5e4858a3b0e2
gperf_url               := http://ftpmirror.gnu.org/gperf/$(gperf).tar.gz

$(configure-rule):
	cd $(builddir) && ./$(configure)

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,gcc)
	$(MAKE) -C $(builddir) install \
		htmldir='$$(datarootdir)/doc/gperf'
