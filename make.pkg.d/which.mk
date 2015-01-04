which                   := which-2.20
which_url               := http://ftpmirror.gnu.org/which/$(which).tar.gz

configure-which-rule:
	cd $(which) && ./$(configure)

build-which-rule:
	$(MAKE) -C $(which) all

install-which-rule: $(call installed,glibc)
	$(MAKE) -C $(which) install
	$(INSTALL) -Dpm 644 $(which)/bashrc.sh $(DESTDIR)/etc/bashrc.d/which.sh

# Provide a bash alias that executes a more functional "which" command.
$(which)/bashrc.sh: | $(which)
	$(ECHO) "alias which='( alias ; declare -f ) | which --tty-only --read-alias --read-functions --show-tilde --show-dot'" > $@
$(call prepared,which): $(which)/bashrc.sh
