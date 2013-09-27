mig                     := mig-1.3.1.99-b53836
mig_branch              := master
mig_snap                := b53836447df7230cd5665a7ccabd2a6e1a6607e5
mig_url                 := git://git.sv.gnu.org/hurd/mig.git

configure-mig-rule:
	cd $(mig) && ./$(configure)

build-mig-rule:
	$(MAKE) -C $(mig) all

install-mig-rule: $(call installed,flex)
	$(MAKE) -C $(mig) install
