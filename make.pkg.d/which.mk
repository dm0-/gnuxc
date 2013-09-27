which                   := which-2.20
which_url               := http://ftp.gnu.org/gnu/which/$(which).tar.gz

prepare-which-rule:
	$(ECHO) "alias which='( alias ; declare -f ) | which --tty-only --read-alias --read-functions --show-tilde --show-dot'" > $(which)/which.sh

configure-which-rule:
	cd $(which) && ./$(configure)

build-which-rule:
	$(MAKE) -C $(which) all

install-which-rule: $(call installed,glibc)
	$(MAKE) -C $(which) install
	$(INSTALL) -Dpm 644 $(which)/which.sh $(DESTDIR)/etc/profile.d/which.sh
