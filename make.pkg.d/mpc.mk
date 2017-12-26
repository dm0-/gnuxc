mpc                     := mpc-1.0.3
mpc_key                 := AD17A21EF8AED8F1CC02DBD9F7D5C9BF765C61E3
mpc_url                 := http://ftpmirror.gnu.org/mpc/$(mpc).tar.gz

$(eval $(call verify-download,update-mpfr-1.patch,https://scm.gforge.inria.fr/anonscm/gitweb?p=mpc/mpc.git;a=commitdiff_plain;h=36a84f43f326de14db888ba07936cc9621c23f19,36a216796383981929fba0679e377664088e75e1))
$(eval $(call verify-download,update-mpfr-2.patch,https://scm.gforge.inria.fr/anonscm/gitweb?p=mpc/mpc.git;a=commitdiff_plain;h=5eaa17651b759c7856a118835802fecbebcf46ad,a29c9963fa35a828e6af41e7126110d0a282ad65))

$(prepare-rule):
# Backport patches for MPFR 4 support.
	$(SED) '/8,6/,/endif/{s/8,6/8,7/;s/.*MPFR_MANT.*/ /;s/.*#endif/-\n&/;}' $(call addon-file,update-mpfr-1.patch) | $(PATCH) -d $(builddir) -F2 -p1
	$(SED) 's/macros/macroes/;s/MPFR_RNDN/GMP_RNDN/' $(call addon-file,update-mpfr-2.patch) | $(PATCH) -d $(builddir) -p1
	$(RM) $(builddir)/configure

$(configure-rule):
	cd $(builddir) && ./$(configure)

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,mpfr)
	$(MAKE) -C $(builddir) install
