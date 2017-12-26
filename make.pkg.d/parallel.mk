parallel                := parallel-20171222
parallel_key            := CDA01A4208C4F74506107E7BD1AB451688888888
parallel_url            := http://ftpmirror.gnu.org/parallel/$(parallel).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure)

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,perl)
	$(MAKE) -C $(builddir) install
