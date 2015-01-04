gnumach                 := gnumach-1.4-87b7d8
gnumach_branch          := master
gnumach_snap            := 87b7d8226c4219fdf7b6f607a437e9c93c9211d7
gnumach_url             := git://git.sv.gnu.org/hurd/gnumach.git

configure-gnumach-rule:
	cd $(gnumach) && ./$(configure) \
		--exec-prefix= \
		\
		--enable-kdb \
		--enable-kmsg \
		--enable-pae

build-gnumach-rule:
	$(MAKE) -C $(gnumach) -j1 all gnumach gnumach.msgids

install-gnumach-rule:
	$(MAKE) -C $(gnumach) install
