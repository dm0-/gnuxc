parallel                := parallel-20140222
parallel_url            := http://ftp.gnu.org/gnu/parallel/$(parallel).tar.bz2

configure-parallel-rule:
	cd $(parallel) && ./$(configure)

build-parallel-rule:
	$(MAKE) -C $(parallel) all

install-parallel-rule: $(call installed,perl)
	$(MAKE) -C $(parallel) install
