emms                    := emms-4.3
emms_sha1               := d5fbd22ca500ffab125cd58916a9d032ee58d400
emms_url                := http://ftpmirror.gnu.org/emms/$(emms).tar.gz

$(eval $(call verify-download,http://git.savannah.gnu.org/cgit/emms.git/patch/?id=0ebffc0b7263d261c9de1f117a96d28447889dfd http://git.savannah.gnu.org/cgit/emms.git/patch/?id=a6aa6ca703336ab3fd26f25f36c45894d8ecea5f,04aa5bdf603f77771f64bbaab6280b699a0b1ab5,fix-pulseaudio.patch))

$(prepare-rule):
	$(PATCH) -d $(builddir) -p1 < $(call addon-file,fix-pulseaudio.patch)
	$(call apply,default-pulseaudio)

$(install-rule): $$(call installed,emacs)
	$(INSTALL) -dm 0755 $(DESTDIR)/usr/share/emacs/site-lisp/emms
	$(INSTALL) -pm 0644 -t $(DESTDIR)/usr/share/emacs/site-lisp/emms $(builddir)/lisp/*.el
	$(RM) $(DESTDIR)/usr/share/emacs/site-lisp/emms/emms-{auto,maint}.el
	$(INSTALL) -dm 0755 $(DESTDIR)/etc/skel/.emacs.d/emms
