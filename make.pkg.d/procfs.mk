procfs                  := procfs-0.5-c87688
procfs_branch           := master
procfs_snap             := c87688a05a8b49479ee10127470cc60acebead4a
procfs_url              := git://git.sv.gnu.org/hurd/procfs.git

prepare-procfs-rule:
	$(PATCH) -d $(procfs) < $(patchdir)/$(procfs)-environment.patch

build-procfs-rule:
	$(MAKE) -C $(procfs) all

install-procfs-rule: $(call installed,hurd)
	$(INSTALL) -Dpm 755 $(procfs)/procfs $(DESTDIR)/hurd/procfs
	$(TOUCH) $(DESTDIR)/proc
	$(SYMLINK) ../proc/mounts $(DESTDIR)/etc/mtab
	$(SYMLINK) ../../proc/mounts $(DESTDIR)/var/run/mtab
