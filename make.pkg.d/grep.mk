grep                    := grep-3.1
grep_sha1               := d1d677e959c7d874e18e7e3839f26a0f0c1733d5
grep_url                := http://ftpmirror.gnu.org/grep/$(grep).tar.xz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--exec-prefix= \
		\
		--disable-silent-rules \
		--disable-rpath \
		--enable-assert \
		--enable-gcc-warnings gl_cv_warn_c__Werror=no \
		--enable-perl-regexp \
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
alias egrep='grep --color=auto -E'
alias fgrep='grep --color=auto -F'
endef
$(call addon-file,bashrc.sh): private override contents := $(value contents)
