gnumach                 := gnumach-1.4-7b2451
gnumach_branch          := master
gnumach_snap            := 7b24514f549f65ecc30ad06312a775b65ff99653
gnumach_url             := git://git.sv.gnu.org/hurd/gnumach.git

prepare-gnumach-rule:
	$(PATCH) -d $(gnumach) < $(patchdir)/$(gnumach)-install-debug-headers.patch
	$(RM) $(gnumach)/configure

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
