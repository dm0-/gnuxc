mig                     := mig-1.6-c01a23
mig_branch              := master
mig_snap                := c01a23d17a84fc42caba4031241c050e4a533d3f
mig_url                 := git://git.sv.gnu.org/hurd/mig.git

ifeq ($(host),$(build))
export MIG = mig
else
export MIG = $(host)-mig
endif

$(prepare-rule):
	$(call apply,drop-perl)

$(configure-rule):
	cd $(builddir) && ./$(configure)

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,flex)
	$(MAKE) -C $(builddir) install
