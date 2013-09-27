gperf                   := gperf-3.0.4
gperf_url               := http://ftp.gnu.org/gnu/gperf/$(gperf).tar.gz

configure-gperf-rule:
	cd $(gperf) && ./$(configure)

build-gperf-rule:
	$(MAKE) -C $(gperf) all

install-gperf-rule: $(call installed,gcc)
	$(MAKE) -C $(gperf) install PACKAGE=$(gperf)
