guile                   := guile-2.2.3
guile_key               := 4FD4D288D445934E0A14F9A5A8803732E4436885
guile_url               := http://ftpmirror.gnu.org/guile/$(guile).tar.xz

export GUILE = /usr/bin/guile
ifeq ($(host),$(build))
export GUILE_CONFIG = /usr/bin/guile-config
else
export GUILE_CONFIG = /usr/bin/$(host)-guile-config
endif

ifneq ($(host),$(build))
$(call configure-rule,native): $(builddir)/configure
	$(MKDIR) $(builddir)/native && cd $(builddir)/native && $(native) ../configure \
		--disable-shared \
		--disable-silent-rules
$(call build-rule,native): $(call configured,native)
	$(MAKE) -C $(builddir)/native all
$(configure-rule): $(call built,native)
$(configure-rule): private override export GUILE_FOR_BUILD := $(CURDIR)/$(builddir)/native/meta/guile

$(builddir)/meta/guile-config: $(configured)
	$(MAKE) -C $(builddir)/meta guile-config PKG_CONFIG=/usr/bin/pkg-config
$(build-rule): $(builddir)/meta/guile-config
endif

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-rpath \
		--enable-debug-malloc \
		--enable-guile-debug \
		--with-bdw-gc=bdw-gc \
		--with-threads \
		--without-included-regex \
		LT_SYS_LIBRARY_PATH=/usr/lib # Work around rpath nonsense.

$(build-rule):
	$(MAKE) -C $(builddir) all \
		ELISP_SOURCES= # Drop this elisp file since it won't cross-compile.

$(install-rule): $$(call installed,gc libffi libtool libunistring readline)
	$(MAKE) -C $(builddir) install \
		ELISP_SOURCES= # Drop this elisp file since it won't cross-compile.
	$(INSTALL) -Dpm 0644 $(call addon-file,user.scm) $(DESTDIR)/etc/skel/.guile

# Write inline files.
$(call addon-file,user.scm): | $$(@D)
	$(file >$@,$(contents))
$(prepared): $(call addon-file,user.scm)


# Provide default user settings for Guile.
override define contents
(use-modules (ice-9 readline))
(activate-readline)
endef
$(call addon-file,user.scm): private override contents := $(value contents)
