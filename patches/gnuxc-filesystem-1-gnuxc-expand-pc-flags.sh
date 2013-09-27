#!/bin/bash

[ "${RPM_BUILD_ROOT:-/}" = / ] && exit 0 || cd "$RPM_BUILD_ROOT"

shopt -s nullglob

for pc in .$(rpm -E '%gnuxc_datadir')/pkgconfig/*.pc .$(rpm -E '%gnuxc_libdir')/pkgconfig/*.pc
do
        for var in $(grep -e^{Cflags,Libs{,.private}}: "$pc" | grep -io '\${[0-9A-Z_]\+}')
        do
                var=${var#??} var=${var%?}
                sed -i -e '/^\(Cflags\|Libs\(\.private\)\?\):/s,\${'"$var},$(pkg-config --variable=$var "$pc"),g" "$pc"
        done
done
