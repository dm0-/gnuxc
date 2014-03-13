mpc                     := mpc-1.0.2
mpc_url                 := http://ftp.gnu.org/gnu/mpc/$(mpc).tar.gz

configure-mpc-rule:
	cd $(mpc) && ./$(configure)

build-mpc-rule:
	$(MAKE) -C $(mpc) all

install-mpc-rule: $(call installed,mpfr)
	$(MAKE) -C $(mpc) install
