grep                    := grep-2.21
grep_url                := http://ftpmirror.gnu.org/grep/$(grep).tar.xz

configure-grep-rule:
	cd $(grep) && ./$(configure) \
		--exec-prefix= \
		\
		--disable-silent-rules \
		--disable-rpath \
		--enable-gcc-warnings gl_cv_warn_c__Werror=no \
		--enable-threads=posix \
		--without-included-regex

build-grep-rule:
	$(MAKE) -C $(grep) all

install-grep-rule: $(call installed,pcre)
	$(MAKE) -C $(grep) install
	$(INSTALL) -Dpm 644 $(grep)/bashrc.sh $(DESTDIR)/etc/bashrc.d/grep.sh

# Provide bash aliases to choose the default command-line options.
$(grep)/bashrc.sh: | $(grep)
	$(ECHO) "alias grep='grep --color=auto'" > $@
	$(ECHO) "alias egrep='egrep --color=auto'" >> $@
	$(ECHO) "alias fgrep='fgrep --color=auto'" >> $@
$(call prepared,grep): $(grep)/bashrc.sh
