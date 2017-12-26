gnumach                 := gnumach-1.8-de813a
gnumach_branch          := master
gnumach_sha1            := de813a9cd1351607ea8c183d2b64628328c358fd
gnumach_url             := git://git.sv.gnu.org/hurd/gnumach.git

$(prepare-rule):
# Build non-upstream DDE bits required for rump kernel PCI support.
	$(GIT) -C $(builddir) diff 941d462425fb2692fd9ffea1ab03e927697fcfb0 457323ebb293739802c6a2e1307cb04a95debe9d | $(PATCH) -d $(builddir) -p1
# Reimplement poweroff support, but only for QEMU.
	$(EDIT) -e '/pic\.h/{p;s/pic/pio/;}' -e '/[Ii]n tight loop/i\\t    outw (0x0604, 0x2000);' $(builddir)/i386/i386at/model_dep.c

$(configure-rule): private override export LDFLAGS := $(subst $(gnumach:%=,), ,$(LDFLAGS:-Wl,%=%))
$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--exec-prefix= \
		\
		--enable-kdb \
		--enable-kernsample \
		--enable-kmsg \
		--enable-pae

$(build-rule):
	$(MAKE) -C $(builddir) -j1 all gnumach gnumach.msgids

$(install-rule):
	$(MAKE) -C $(builddir) install
