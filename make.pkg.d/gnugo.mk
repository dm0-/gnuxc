gnugo                   := gnugo-3.8
gnugo_url               := http://ftpmirror.gnu.org/gnugo/$(gnugo).tar.gz

ifneq ($(host),$(build))
$(call configure-rule,native): CFLAGS := $(CFLAGS) -Wno-error=format-security
$(call configure-rule,native): $(builddir)/configure
	$(MKDIR) $(builddir)/native && cd $(builddir)/native && ../configure \
		AR=ar CC=gcc RANLIB=ranlib
$(configure-rule): $(call configured,native)

$(call build-rule,native): $(configured)
	$(MAKE) -C $(builddir)/native/engine   libboard.a libengine.a
	$(MAKE) -C $(builddir)/native/sgf      libsgf.a
	$(MAKE) -C $(builddir)/native/utils    libutils.a
	$(MAKE) -C $(builddir)/native/patterns mkpat joseki mkeyes uncompress_fuseki mkmcpat
	$(MAKE) -C $(builddir)/engine   libboard.a libengine.a
	$(MAKE) -C $(builddir)/sgf      libsgf.a
	$(MAKE) -C $(builddir)/utils    libutils.a
	$(MAKE) -C $(builddir)/patterns mkpat joseki mkeyes uncompress_fuseki mkmcpat
	$(COPY) $(builddir)/native/patterns/{mkpat,joseki,mkeyes,uncompress_fuseki,mkmcpat} $(builddir)/patterns/
$(build-rule): $(call built,native)
endif

$(configure-rule): CFLAGS := $(CFLAGS) -Wno-error=format-security
$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-color \
		--enable-socket-support \
		--with-curses \
		--with-readline

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,readline)
	$(MAKE) -C $(builddir) install
