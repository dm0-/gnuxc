mig                     := mig-1.8-b88740
mig_branch              := master
mig_sha1                := b8874015bd1d09b1b72293c0b5be422fd375e04b
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
