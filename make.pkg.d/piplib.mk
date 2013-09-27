piplib                  := piplib-1.4.0
piplib_url              := http://www.bastoul.net/cloog/pages/download/$(piplib).tar.gz

piplib_configuration := \
	--enable-portable-binary \
	--with-gcc-arch=$(arch)

prepare-piplib-rule:
	$(RM) $(piplib)/configure

configure-piplib-int-rule: $(piplib)/configure
	$(MKDIR) $(piplib)/int && cd $(piplib)/int && ../$(configure) $(piplib_configuration) \
		--enable-int-version
configure-piplib-llint-rule: $(piplib)/configure
	$(MKDIR) $(piplib)/llint && cd $(piplib)/llint && ../$(configure) $(piplib_configuration) \
		--enable-llint-version
configure-piplib-mp-rule: $(piplib)/configure
	$(MKDIR) $(piplib)/mp && cd $(piplib)/mp && ../$(configure) $(piplib_configuration) \
		--enable-mp-version

configure-piplib-rule: $(call configured,piplib-int piplib-llint piplib-mp)

build-piplib-int-rule: $(call configured,piplib)
	$(MAKE) -C $(piplib)/int all
build-piplib-llint-rule: $(call configured,piplib)
	$(MAKE) -C $(piplib)/llint all
build-piplib-mp-rule: $(call configured,piplib)
	$(MAKE) -C $(piplib)/mp all

build-piplib-rule: $(call built,piplib-int piplib-llint piplib-mp)

install-piplib-rule: $(call installed,gmp)
	$(MAKE) -C $(piplib)/int   install
	$(MAKE) -C $(piplib)/llint install
	$(MAKE) -C $(piplib)/mp    install

clean-piplib-variants:
	$(RM) $(timedir)/{build,configure}-piplib-{int,llint,mp}-{rule,stamp}
.PHONY clean-piplib: clean-piplib-variants
