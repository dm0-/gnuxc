grep                    := grep-2.25
grep_sha1               := d9a7f1d90a6d5c123fdffb9a3b14831d17e05960
grep_url                := http://ftpmirror.gnu.org/grep/$(grep).tar.xz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--exec-prefix= \
		\
		--disable-silent-rules \
		--disable-rpath \
		--enable-gcc-warnings gl_cv_warn_c__Werror=no \
		--enable-threads=posix \
		--without-included-regex

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,pcre)
	$(MAKE) -C $(builddir) install
	$(INSTALL) -Dpm 644 $(call addon-file,bashrc.sh) $(DESTDIR)/etc/bashrc.d/grep.sh

# Write inline files.
$(call addon-file,bashrc.sh): | $$(@D)
	$(file >$@,$(contents))
$(prepared): $(call addon-file,bashrc.sh)


# Provide bash aliases to choose the default command-line options.
override define contents
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
endef
$(call addon-file,bashrc.sh): private override contents := $(value contents)
