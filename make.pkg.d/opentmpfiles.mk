opentmpfiles            := opentmpfiles-0.1.3
opentmpfiles_sha1       := c22d8d086189ccd78251e139c3cdde8288505a28
opentmpfiles_url        := http://github.com/OpenRC/$(subst -,/archive/,$(opentmpfiles)).tar.gz

$(install-rule): $$(call installed,bash)
	$(MAKE) -C $(builddir) install bindir=/sbin
