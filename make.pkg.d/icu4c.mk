icu4c                   := icu4c-54.1
icu4c_branch            := icu
icu4c_url               := http://download.icu-project.org/files/$(subst -,/,$(icu4c))/$(subst .,_,$(icu4c))-src.tgz

ifeq ($(host),$(build))
export ICU_CONFIG = icu-config
else
export ICU_CONFIG = $(host)-icu-config
endif

ifneq ($(host),$(build))
configure-icu4c-native-rule: $(icu4c)/configure
	$(MKDIR) $(icu4c)/native/config && $(TOUCH) $(icu4c)/native/config/icucross.mk
	cd $(icu4c)/native && env -i CFLAGS='$(CFLAGS)' PATH=/bin ../source/configure
configure-icu4c-rule: $(call configured,icu4c-native)
configure-icu4c-rule: export private with_cross_build := $(CURDIR)/$(icu4c)/native

build-icu4c-native-rule: $(call configured,icu4c-native)
	$(MAKE) -C $(icu4c)/native all VERBOSE=1
build-icu4c-rule: $(call built,icu4c-native)

clean-icu4c-native:
	$(RM) $(timedir)/{build,configure}-icu4c-native-{rule,stamp}
.PHONY clean-icu4c: clean-icu4c-native
endif

configure-icu4c-rule:
	cd $(icu4c)/source && ./$(configure) \
		--disable-rpath \
		--enable-debug \
		--enable-static \
		--enable-strict \
		--with-data-packaging=library

build-icu4c-rule:
	$(MAKE) -C $(icu4c)/source all VERBOSE=1

install-icu4c-rule: $(call installed,gcc)
	$(MAKE) -C $(icu4c)/source install VERBOSE=1
