lsh                     := lsh-2.1
lsh_url                 := http://ftp.gnu.org/gnu/lsh/$(lsh).tar.gz

prepare-lsh-rule:
	$(ECHO) "alias ssh='lsh --sloppy-host-authentication --capture-to ~/.lsh/host-acls'" > $(lsh)/lsh.sh

configure-lsh-rule:
	cd $(lsh) && ./$(configure)

build-lsh-rule:
	$(MAKE) -C $(lsh) all

install-lsh-rule: $(call installed,liboop nettle)
	$(MAKE) -C $(lsh) install
	$(INSTALL) -Dpm 644 $(lsh)/lsh.sh $(DESTDIR)/etc/profile.d/lsh.sh
