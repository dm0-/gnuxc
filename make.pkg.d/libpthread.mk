libpthread              := libpthread-0.3-b9eb71
libpthread_snap         := b9eb71a78f15f5f889114fb1f5393be74789039d
libpthread_url          := git://git.sv.gnu.org/hurd/libpthread.git

prepare-libpthread-rule:
	cd $(libpthread) && $(GIT) revert --no-edit 536420a581f9f822cdef0fc460b5176a840f49e5
	cd $(libpthread) && $(GIT) merge --no-edit b1a5dd9b39835776796cdee3bd8f08adf6c9e46d
	$(PATCH) -d $(libpthread) < $(patchdir)/$(libpthread)-new-files.patch
	$(PATCH) -d $(libpthread) < $(patchdir)/$(libpthread)-fix-new-automake.patch
	$(RM) $(libpthread)/configure $(libpthread)/configure.in

configure-libpthread-rule:
	cd $(libpthread) && ./$(configure) \
		--exec-prefix=

build-libpthread-rule:
	$(MAKE) -C $(libpthread) all

install-libpthread-rule: $(call installed,glibc)
	$(MAKE) -C $(libpthread) install
