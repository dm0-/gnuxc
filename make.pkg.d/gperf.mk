gperf                   := gperf-3.1
gperf_key               := EDEB87A500CC0A211677FBFD93C08C88471097CD
gperf_url               := http://ftpmirror.gnu.org/gperf/$(gperf).tar.gz

$(configure-rule):
	cd $(builddir) && ./$(configure)

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,gcc)
	$(MAKE) -C $(builddir) install \
		htmldir='$$(datarootdir)/doc/gperf'
