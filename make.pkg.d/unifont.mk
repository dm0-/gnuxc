unifont                 := unifont-10.0.03
unifont_sha1            := 874502db140df009c303ed9663a56e5a10d91b17
unifont_url             := http://ftpmirror.gnu.org/unifont/$(unifont)/$(unifont).bdf.gz

$(eval $(call verify-download,$(unifont_url),$(unifont_sha1),unifont.bdf.gz))

$(prepare-rule):
	gzip -cd $(call addon-file,unifont.bdf.gz) > $(builddir)/unifont.bdf

$(install-rule):
	$(INSTALL) -Dpm 644 $(builddir)/unifont.bdf $(DESTDIR)/usr/share/fonts/unifont/unifont.bdf
