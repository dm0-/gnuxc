gnumach                 := gnumach-1.6-4c721d
gnumach_branch          := master
gnumach_snap            := 4c721d8da43ebbe77da0a874cea170e7ba5a61ac
gnumach_url             := git://git.sv.gnu.org/hurd/gnumach.git

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--exec-prefix= \
		\
		--enable-kdb \
		--enable-kmsg \
		--enable-pae

$(build-rule):
	$(MAKE) -C $(builddir) -j1 all gnumach gnumach.msgids

$(install-rule):
	$(MAKE) -C $(builddir) install
