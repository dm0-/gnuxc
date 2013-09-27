gnumach                 := gnumach-1.3.99-2166b4
gnumach_branch          := master
gnumach_snap            := 2166b4cd592c64bb3ea44406b57b7d426d89654b
gnumach_url             := git://git.sv.gnu.org/hurd/gnumach.git

configure-gnumach-rule:
	cd $(gnumach) && ./$(configure) \
		--exec-prefix= \
		\
		--enable-kdb \
		--enable-kmsg \
		--enable-pae

build-gnumach-rule:
	$(MAKE) -C $(gnumach) all gnumach gnumach.msgids

install-gnumach-rule:
	$(MAKE) -C $(gnumach) install
