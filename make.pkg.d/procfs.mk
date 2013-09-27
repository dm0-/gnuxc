procfs                  := procfs-0.3-969078
procfs_branch           := master
procfs_snap             := 969078c9755b7e28dcabe277629f757e20a19f1a
procfs_url              := git://git.sv.gnu.org/hurd/procfs.git

prepare-procfs-rule:
	$(PATCH) -d $(procfs) < $(patchdir)/$(procfs)-environment.patch

build-procfs-rule:
	$(MAKE) -C $(procfs) all

install-procfs-rule: $(call installed,hurd)
	$(INSTALL) -Dpm 755 $(procfs)/procfs $(DESTDIR)/hurd/procfs
	$(TOUCH) $(DESTDIR)/proc
	$(SYMLINK) ../proc/mounts $(DESTDIR)/etc/mtab
