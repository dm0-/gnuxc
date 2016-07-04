gnumach                 := gnumach-1.7-4bccd1
gnumach_branch          := master
gnumach_sha1            := 4bccd10cfeaf126382467dd90d7339a98989b9d2
gnumach_url             := git://git.sv.gnu.org/hurd/gnumach.git

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--exec-prefix= \
		\
		--enable-kdb \
		--enable-kernsample \
		--enable-kmsg \
		--enable-pae

$(build-rule):
	$(MAKE) -C $(builddir) -j1 all gnumach gnumach.msgids

$(install-rule):
	$(MAKE) -C $(builddir) install
