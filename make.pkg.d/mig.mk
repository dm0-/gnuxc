mig                     := mig-1.7-ae832c
mig_branch              := master
mig_sha1                := ae832c599fc25e9557200205a168989bae375489
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
