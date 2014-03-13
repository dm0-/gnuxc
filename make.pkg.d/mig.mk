mig                     := mig-1.4-bb06f6
mig_branch              := master
mig_snap                := bb06f65290c2526d214302ba43bb6bc363cd4868
mig_url                 := git://git.sv.gnu.org/hurd/mig.git

configure-mig-rule:
	cd $(mig) && ./$(configure)

build-mig-rule:
	$(MAKE) -C $(mig) all

install-mig-rule: $(call installed,flex)
	$(MAKE) -C $(mig) install
