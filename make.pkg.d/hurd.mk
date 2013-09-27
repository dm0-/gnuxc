hurd                    := hurd-0.3-51a251
hurd_branch             := master
hurd_snap               := 51a25140f5314549b586a35e05e9f1e3319fd2cf
hurd_url                := git://git.sv.gnu.org/hurd/hurd.git

prepare-hurd-rule:
	$(PATCH) -d $(hurd) < $(patchdir)/$(hurd)-allow-user-installs.patch
	$(PATCH) -d $(hurd) < $(patchdir)/$(hurd)-console-nocaps.patch
	$(PATCH) -d $(hurd) < $(patchdir)/$(hurd)-disable-services.patch

configure-hurd-rule:
	cd $(hurd) && ./$(configure) \
		--prefix= \
		--datarootdir='$${prefix}/usr/share' \
		--includedir='$${prefix}/usr/include' \
		--libexecdir='$${prefix}/usr/libexec' \
		--localstatedir='$${prefix}/var' \
		--sysconfdir='$${prefix}/etc' \
		\
		--without-libdaemon

build-hurd-rule:
#	$(MAKE) -C $(hurd)/sutils default_pager_U.h
	$(MAKE) -C $(hurd) -j1 all
	$(MAKE) -C $(hurd)/hurd hurd.msgids

install-hurd-rule: $(call installed,gnumach)
	$(MAKE) -C $(hurd) install prefix=$(DESTDIR)
	$(INSTALL) -Dpm 644 $(hurd)/console/motd.UTF8 $(DESTDIR)/etc/motd.UTF8
	$(RM) $(DESTDIR)/dev/MAKEDEV

	$(INSTALL) -dm 0755 $(DESTDIR)/home
	$(INSTALL) -dm 0755 $(DESTDIR)/servers{,/socket}
	$(INSTALL) -dm 1777 $(DESTDIR)/tmp
	$(INSTALL) -dm 0755 $(DESTDIR)/usr/share/hurd
	$(INSTALL) -dm 0755 $(DESTDIR)/var/{cache,lib,lock,log,run,spool}

	$(SYMLINK) usr/libexec $(DESTDIR)/libexec
	$(SYMLINK) ../tmp $(DESTDIR)/var/tmp

	$(TOUCH) $(DESTDIR)/servers/{exec,socket/{1,2,26}}
