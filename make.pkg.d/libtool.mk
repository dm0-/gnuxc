libtool                 := libtool-2.4.6
libtool_sha1            := 3e7504b832eb2dd23170c91b6af72e15b56eb94e
libtool_url             := http://ftpmirror.gnu.org/libtool/$(libtool).tar.xz

$(prepare-rule):
# Regenerate this to avoid edits by the anti-rpath scripts.
	$(RM) $(builddir)/build-aux/ltmain.sh

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
		--enable-ltdl-install \
		ac_cv_path_SED='$(SED)'

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,sed tar)
	$(MAKE) -C $(builddir) install
