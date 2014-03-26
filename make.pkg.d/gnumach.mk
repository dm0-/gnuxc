gnumach                 := gnumach-1.4-e33a07
gnumach_branch          := master
gnumach_snap            := e33a07f421a84e54360628354e4faa0cf4a5d36f
gnumach_url             := git://git.sv.gnu.org/hurd/gnumach.git

prepare-gnumach-rule:
	$(PATCH) -d $(gnumach) < $(patchdir)/$(gnumach)-install-debug-headers.patch

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
