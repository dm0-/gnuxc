libtool                 := libtool-2.4.6
libtool_key             := CFE2BE707B538E8B26757D84151308092983D606
libtool_url             := http://ftpmirror.gnu.org/libtool/$(libtool).tar.xz

$(prepare-rule):
# Regenerate this to avoid edits by the anti-rpath scripts.
	$(RM) $(builddir)/build-aux/ltmain.sh

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-ltdl-install \
		ac_cv_path_SED='$(SED)'

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,sed tar)
	$(MAKE) -C $(builddir) install
