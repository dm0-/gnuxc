unifont                 := unifont-10.0.06
unifont_key             := 95D2E9AB8740D8046387FD151A09227B1F435A33
unifont_url             := http://ftpmirror.gnu.org/unifont/$(unifont)/$(unifont).bdf.gz

$(eval $(call verify-download,unifont.bdf.gz,$(unifont_url),,$(unifont_key)))

$(prepare-rule):
	gzip -cd $(call addon-file,unifont.bdf.gz) > $(builddir)/unifont.bdf

$(install-rule):
	$(INSTALL) -Dpm 0644 $(builddir)/unifont.bdf $(DESTDIR)/usr/share/fonts/unifont/unifont.bdf
