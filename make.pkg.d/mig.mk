mig                     := mig-1.4-5a2d1f
mig_branch              := master
mig_snap                := 5a2d1fb4db65d847d5bc9ea1cf5192bd81d8c7e5
mig_url                 := git://git.sv.gnu.org/hurd/mig.git

ifeq ($(host),$(build))
export MIG = mig
else
export MIG = $(host)-mig
endif

prepare-mig-rule:
	$(PATCH) -d $(mig) < $(patchdir)/$(mig)-drop-perl.patch

configure-mig-rule:
	cd $(mig) && ./$(configure)

build-mig-rule:
	$(MAKE) -C $(mig) all

install-mig-rule: $(call installed,flex)
	$(MAKE) -C $(mig) install
