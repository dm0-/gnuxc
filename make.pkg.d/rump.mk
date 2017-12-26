rump                    := rump-1

rump-audio_branch       := master
rump-audio_sha1         := 607eef6ce828a432603c443d902dd86a9c7fd6df
rump-audio_url          := git://github.com/dm0-/hurd-rump-audio.git

rump-buildrump.sh_branch := master
rump-buildrump.sh_sha1  := 6cccd464a9675ce19eaca569b1c9c2837492038c
rump-buildrump.sh_url   := git://github.com/rumpkernel/buildrump.sh.git

rump-pci-userspace_branch := master
rump-pci-userspace_sha1 := c069aec17d3f851c04635a08622e3af531d85339
rump-pci-userspace_url  := git://github.com/rumpkernel/pci-userspace.git

$(builddir)/audio: | $$(@D)/.gnuxc
	$(GIT) clone --branch=$(rump-audio_branch) -n $(rump-audio_url) $@
	$(GIT) -C $@ reset --hard $(rump-audio_sha1)
$(builddir)/buildrump.sh: | $$(@D)/.gnuxc
	$(GIT) clone --branch=$(rump-buildrump.sh_branch) -n $(rump-buildrump.sh_url) $@
	$(GIT) -C $@ reset --hard $(rump-buildrump.sh_sha1)
$(builddir)/pci-userspace: | $$(@D)/.gnuxc
	$(GIT) clone --branch=$(rump-pci-userspace_branch) -n $(rump-pci-userspace_url) $@
	$(GIT) -C $@ reset --hard $(rump-pci-userspace_sha1)
$(builddir)/src: | $$(@D)/buildrump.sh
	$(EDIT) '/^GITREPO=/s,https://,git://,' $|/checkout.sh
	cd $(builddir) && CFLAGS= LDFLAGS= buildrump.sh/buildrump.sh checkout
$(downloaded): | $(builddir)/audio $(builddir)/buildrump.sh $(builddir)/pci-userspace $(builddir)/src

$(prepare-rule):
# Allow using a host-prefixed mig.
	$(EDIT) 's/ mig / $${MIG:Umig} /' $(builddir)/pci-userspace/src-gnu/Makefile.inc
# Turn off catman pages.
	$(EDIT) 's/^MKCATPAGES=yes/MKCATPAGES=no/;s/ cat / /' $(builddir)/buildrump.sh/buildrump.sh
# Build virtio network interface support.
	$(EDIT) 's/^RUMP_VIRTIF=no/RUMP_VIRTIF=yes/' $(builddir)/buildrump.sh/buildrump.sh
# Do not set RPATHs on the programs.
	$(EDIT) 's/-Wl,-R[^ ]*//g' $(builddir)/buildrump.sh/buildrump.sh

$(builddir)/configure: private override allow_rpaths = 1 # Don't mess with the tools' configure scripts.

$(build-rule): private override export CFLAGS := $(CFLAGS:-Werror%format-security=-Wformat) -Wno-error=implicit-fallthrough
$(build-rule):
	cd $(builddir) && CFLAGS= LDFLAGS= \
		buildrump.sh/buildrump.sh -F CFLAGS='$(CFLAGS)' -F LDFLAGS='$(LDFLAGS)' fullbuild
	$(builddir)/obj/tooldir/rumpmake -C $(builddir)/pci-userspace/src-gnu NOGCCERROR=1
# Move to a separate project file when sysroot rump libraries are packaged.
	$(MAKE) -C $(builddir)/audio all \
		CPPFLAGS="$(CPPFLAGS) -I$$PWD/$(builddir)/obj/dest.stage/usr/include" \
		LDFLAGS="$(LDFLAGS) -L$$PWD/$(builddir)/obj/dest.stage/usr/lib"

$(install-rule): $$(call installed,glibc)
	cd $(builddir) && CFLAGS= LDFLAGS= \
		buildrump.sh/buildrump.sh -d '$(DESTDIR)/usr' install
	$(builddir)/obj/tooldir/rumpmake -C $(builddir)/pci-userspace/src-gnu install DESTDIR='$(DESTDIR)'
	$(MAKE) -C $(builddir)/audio install
	$(INSTALL) -Dpm 0644 $(call addon-file,rump.scm) $(DESTDIR)/etc/shepherd.d/rump.scm
	$(call enable-service,rump,3 5)

# Write inline files.
$(call addon-file,rump.scm): | $$(@D)
	$(file >$@,$(contents))
$(prepared): $(call addon-file,rump.scm)


# Provide a system service definition for "rump".
override define contents
(define rump-command
  '("/usr/bin/rump_server" "-s" "-v"
    "-lrumpvfs"
    "-lrumpdev"
    "-lrumpdev_audio"
    "-lrumpdev_audio_ac97"
    "-lrumpdev_pci"
    "-lrumpdev_pci_auich"
    "unix:///run/rump.sock"))
(define (rump-start . args)
  (let ((mask (umask)) (pid 0))
    (umask #o0077)
    (set! pid (fork+exec-command rump-command))
    (umask mask)
    pid))
(make <service>
  #:docstring "The rump service runs NetBSD hardware drivers."
  #:provides '(rump)
  #:requires '()
  #:start rump-start
  #:stop (make-kill-destructor))
endef
$(call addon-file,rump.scm): private override contents := $(value contents)
