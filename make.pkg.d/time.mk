time                    := time-1.8
time_key                := F576AAAC1B0FF849792D8CB129A794FD2272BC86
time_url                := http://ftpmirror.gnu.org/time/$(time).tar.gz

$(configure-rule):
	cd $(builddir) && ./$(configure)

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,glibc)
	$(MAKE) -C $(builddir) install
