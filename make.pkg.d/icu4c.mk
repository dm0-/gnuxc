icu4c                   := icu4c-60.2
icu4c_branch            := icu
icu4c_key               := 9731166CD8E23A83BEE7C6D3ACA5DBE1FD8FABF1
icu4c_url               := http://download.icu-project.org/files/$(subst -,/,$(icu4c))/$(subst .,_,$(icu4c))-src.tgz
icu4c_sig               := $(icu4c_url).asc

ifeq ($(host),$(build))
export ICU_CONFIG = /usr/bin/icu-config
else
export ICU_CONFIG = /usr/bin/$(host)-icu-config
endif

ifneq ($(host),$(build))
$(call configure-rule,native): $(builddir)/configure
	$(MKDIR) $(builddir)/native/config && $(TOUCH) $(builddir)/native/config/icucross.mk
	cd $(builddir)/native && $(native) ../source/configure
$(configure-rule): $(call configured,native)
$(configure-rule): private override export with_cross_build := $(CURDIR)/$(builddir)/native

$(call build-rule,native): $(call configured,native)
	$(MAKE) -C $(builddir)/native all VERBOSE=1
$(build-rule): $(call built,native)
endif

$(configure-rule):
	cd $(builddir)/source && ./$(configure) \
		--disable-rpath \
		--enable-debug \
		--enable-dyload \
		--enable-extras \
		--enable-icuio \
		--enable-plugins \
		--enable-static \
		--enable-strict \
		--enable-tracing \
		--with-data-packaging=library

$(build-rule):
	$(MAKE) -C $(builddir)/source all VERBOSE=1

$(install-rule): $$(call installed,gcc)
	$(MAKE) -C $(builddir)/source install VERBOSE=1
