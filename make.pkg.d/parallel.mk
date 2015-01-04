parallel                := parallel-20141122
parallel_url            := http://ftpmirror.gnu.org/parallel/$(parallel).tar.bz2

configure-parallel-rule:
	cd $(parallel) && ./$(configure)

build-parallel-rule:
	$(MAKE) -C $(parallel) all

install-parallel-rule: $(call installed,perl)
	$(MAKE) -C $(parallel) install
