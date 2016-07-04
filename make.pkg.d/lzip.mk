lzip                    := lzip-1.18
lzip_sha1               := 9961510b53603adc7547f5173754ed3f7f00bdbd
lzip_url                := http://download.savannah.gnu.org/releases/lzip/$(lzip).tar.lz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		CXX='$(CXX)' \
		CPPFLAGS='$(CPPFLAGS)' \
		CXXFLAGS='$(CXXFLAGS)' \
		LDFLAGS='$(LDFLAGS)'

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,gcc)
	$(MAKE) -C $(builddir) install
