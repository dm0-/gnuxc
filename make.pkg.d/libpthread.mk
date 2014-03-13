libpthread              := libpthread-0.3-3b391d
libpthread_branch       := master
libpthread_snap         := 3b391db91f70b2166951413ee1eccc78cd398a44
libpthread_url          := git://git.sv.gnu.org/hurd/libpthread.git

prepare-libpthread-rule:
# Drop the librt dependency.
	$(GIT) -C $(libpthread) checkout 69e89a859882e4f675dd5491edc969159d8a4002 Makefile.am
	$(GIT) -C $(libpthread) commit -m 'Shut up the whiny revert'
	$(GIT) -C $(libpthread) revert --no-edit 581b822ea36002817f4c22b9ea715b72a0647166 69e89a859882e4f675dd5491edc969159d8a4002
# Drop the libihash dependency.
	$(PATCH) -d $(libpthread) < $(patchdir)/$(libpthread)-steal-libihash.patch
# Port to be built as a glibc module.
	$(PATCH) -d $(libpthread) < $(patchdir)/$(libpthread)-glibc-preparation.patch
	$(RM) --recursive $(libpthread)/signal
	$(RM) $(libpthread)/include/{libc-symbols,set-hooks}.h $(libpthread)/Makefile.am

# This project's build and install phases are handled by glibc.
configure-libpthread-rule: $(call configured,glibc)
build-libpthread-rule: $(call built,glibc)
install-libpthread-rule: $(call installed,glibc)
