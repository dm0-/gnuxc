glibc                   := glibc-2.17.90-7a3271
glibc_branch            := tschwinge/Roger_Whittaker
glibc_snap              := 7a32719e4dc679fa53402a602f07df21b1a9420f
glibc_url               := git://git.sv.gnu.org/hurd/glibc.git

glibc-libpthread        := $(glibc)/libpthread-0.3-ed9f86
glibc-libpthread_snap   := ed9f866df04350bd3bf4661710eda07c02e8ff6a
glibc-libpthread_url    := git://git.sv.gnu.org/hurd/libpthread.git

$(glibc-libpthread): | $(glibc)
	$(GIT) clone -n $(glibc-libpthread_url) $@
	$(GIT) -C $@ reset --hard $(glibc-libpthread_snap)

prepare-glibc-rule: | $(glibc-libpthread)
# Fix a documentation error.
	$(GIT) -C $(glibc) cherry-pick 2b66ef5d55325b2957d6c62908ca065228e56814
	$(PATCH) -d $(glibc) < $(patchdir)/$(glibc)-provide-hurd-api.patch
	$(PATCH) -d $(glibc) < $(patchdir)/$(glibc)-create-gnumach-header.patch
	$(PATCH) -d $(glibc-libpthread) < $(patchdir)/$(subst /,-,$(glibc-libpthread))-steal-libihash.patch
	$(PATCH) -d $(glibc-libpthread) < $(patchdir)/$(subst /,-,$(glibc-libpthread))-glibc-preparation.patch
	$(RM) $(glibc-libpthread)/include/{libc-symbols,set-hooks}.h
# Stop getauxval() from segfaulting.
#	$(ECHO) '#include <libc-symbols.h>' > $(glibc)/sysdeps/mach/hurd/getauxval.c
#	$(ECHO) 'unsigned long int __getauxval (unsigned long int type) { return 0; }' >> $(glibc)/sysdeps/mach/hurd/getauxval.c
#	$(ECHO) 'weak_alias (__getauxval, getauxval)' >> $(glibc)/sysdeps/mach/hurd/getauxval.c
# Support make 4.
	$(EDIT) '/ | 3/s/)/ | 4.*)/' $(glibc)/configure
# Static libraries miss some object files if libpthread isn't named libpthread.
	$(MOVE) $(glibc-libpthread) $(glibc)/libpthread && $(TOUCH) $(glibc-libpthread)

configure-glibc-rule: CFLAGS := $(CFLAGS:-O2=-O3)
configure-glibc-rule: CFLAGS := $(CFLAGS:-Wp,-D_FORTIFY_SOURCE%=)
configure-glibc-rule: CFLAGS := $(CFLAGS:-fexceptions=-fasynchronous-unwind-tables)
configure-glibc-rule: CFLAGS := $(CFLAGS:-fstack-protector%=)
configure-glibc-rule:
	$(MKDIR) $(glibc)/build && cd $(glibc)/build && ../$(configure) \
		--disable-multi-arch \
		--enable-all-warnings \
		--enable-obsolete-rpc \
		--enable-stackguard-randomization \
		BASH_SHELL='$(BASH)' \
		\
		--disable-nscd

build-glibc-rule:
	$(MAKE) -C $(glibc)/build all \
		CFLAGS-clock_gettime.c='-DSYSDEP_GETTIME="case CLOCK_MONOTONIC:"' \
		install_root=.
	$(MAKE) -C $(glibc)/build info

install-glibc-rule: $(call installed,hurd)
	$(MAKE) -C $(glibc)/build install
	$(SYMLINK) ld.so.1 $(DESTDIR)/lib/ld.so
	$(INSTALL) -dm 755 $(DESTDIR)/usr/lib/locale
	$(RM) $(DESTDIR)/usr/libexec/pt_chown
