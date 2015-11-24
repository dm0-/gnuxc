gperf                   := gperf-3.0.4
gperf_url               := http://ftpmirror.gnu.org/gperf/$(gperf).tar.gz

$(configure-rule):
	cd $(builddir) && ./$(configure)

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,gcc)
	$(MAKE) -C $(builddir) install \
		htmldir='$$(datarootdir)/doc/gperf'
