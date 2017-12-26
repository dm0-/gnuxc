librsvg                 := librsvg-2.41.2
librsvg_sha1            := 902af9cc73a4541dc3d33a6691fe70e465f32595
librsvg_url             := http://ftp.gnome.org/pub/gnome/sources/librsvg/2.41/$(librsvg).tar.xz

$(eval $(call verify-download,libc.crate,http://crates.io/api/v1/crates/libc/0.2.31/download,80b3a84e268a825c2c1ede2b43ca0bda291e4d74))

$(prepare-rule):
# Update libc to the version shipped with Rust, just to share the patch.
	$(RM) -r $(builddir)/rust/vendor/libc
	$(TAR) --transform='s,^[^/]*,libc,' -C $(builddir)/rust/vendor -xf $(call addon-file,libc.crate)
	sha256sum $(call addon-file,libc.crate) | $(SED) 's/^\([^ ]*\).*/{"package":"\1","files":{}}/' > $(builddir)/rust/vendor/libc/.cargo-checksum.json
	$(SED) -n '/liblibc/,/^---.*lib[m-z]/p' $(patchdir)/rust-*-hurd-port.patch | $(PATCH) -d $(builddir)/rust/vendor/libc -p2
	cd $(builddir)/rust && cargo update

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-pixbuf-loader \
		--enable-tools \
		\
		--disable-introspection \
		--disable-vala

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,gdk-pixbuf libcroco pango)
	$(MAKE) -C $(builddir) install
