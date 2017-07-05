#!/bin/bash

# This script builds and installs all the packages needed to cross-compile the
# complete operating system.  Packages are built in a manually defined sequence
# (see below) directly with rpmbuild commands, or with Mock when the "--mock"
# option is given on the command line.
#
# When using "--mock", the "--srpm" argument will build the SRPM locally and
# pass it to Mock (instead of Mock building the SRPM itself).  This will speed
# up the script due entering the build environment less often.
#
# The "--tmpfs" argument can be given along with "--mock" to create the build
# file system in RAM.  It needs at least 5GiB for the file system.
#
# Please try setup-sysroot.scm for a better alternative to this script.  It can
# build the packages in parallel, and it can be used to rebuild all packages
# affected by spec file updates.

set -ex
shopt -s expand_aliases nullglob

arch=$(rpm -E %_arch)
specdir=$(rpm -E %_specdir)
rpmdir=$(rpm -E %_rpmdir)


dnf_opts="--repofrompath='gnuxc-local,$rpmdir' --enablerepo='gnuxc-local' \
--setopt='gnuxc-local.name=gnuxc - Locally built cross-compiler packages' \
--setopt='gnuxc-local.includepkgs=gnuxc-*' \
--setopt='gnuxc-local.gpgcheck=0' \
--setopt='gnuxc-local.metadata_expire=0'"

# Delete these definitions when DNF works correctly (see above).
repo_conf="[gnuxc-local]
name=gnuxc - Locally built cross-compiler packages
baseurl=file://$rpmdir
includepkgs=gnuxc-*
gpgcheck=0
metadata_expire=0
enabled=0"
dnf_opts="--config=/dev/stdin --enablerepo='gnuxc-local' \
<<< \"\`cat /etc/dnf/dnf.conf ; echo '$repo_conf'\`\""

alias dnf-install="sudo dnf --disablerepo='*' $dnf_opts -y install"
alias rpmbuild="rpmbuild --clean --define='_disable_source_fetch 0' \
"'--with$([ "$bootstrap" ] || echo out)=bootstrap'


# Aliases need to be defined outside the if-blocks due to the bash parser.

# Non-mock definitions
alias dnf-builddep="sudo dnf $dnf_opts -y builddep \
"'--define="_with$([ "$bootstrap" ] || echo out)_bootstrap 1"'

# Mock definitions
distro=fedora-$(rpm -E %fedora)-$arch
resultdir=/var/lib/mock/$distro/result
sourcedir=$(rpm -E %_sourcedir)
srpmdir=$(rpm -E %_srcrpmdir)
[[ "$*" == *tmpfs* ]] && tmpfs_arg='--enable-plugin=tmpfs ' || tmpfs_arg=
[[ "$*" == *srpm* ]] && local_srpm=yes || local_srpm=
alias run_mock="mock --root=$distro $tmpfs_arg\
--enablerepo='gnuxc-local' --define='_disable_source_fetch 0' \
"'--with$([ "$bootstrap" ] || echo out)=bootstrap'


if [[ "$*" != *mock* ]] ; then

function do_the_build() {
        dnf-builddep "$1" ||
                echo "Failed to install dependencies of $2 (ignoring)" 1>&2
        rpmbuild -ba "$1" ||
                { echo "Failed to build the $2 package" 1>&2 ; exit 1 ; }
}

else

function install_user_mock_config() {
        # There is no way to feed configuration to mock from a file descriptor.
        test -s ~/.config/mock.cfg || cat << EOF > ~/.config/mock.cfg
# Install the RPM macros in the base file system, and define the local repo.
config_opts['chroot_setup_cmd'] += ' gnuxc-filesystem'
config_opts['yum.conf'] += """
$repo_conf
"""

# Configure the tmpfs plugin to use 5 GiB of RAM.  (Blame GCC.)
config_opts['plugin_conf']['tmpfs_opts'] = {}
config_opts['plugin_conf']['tmpfs_opts']['keep_mounted'] = False
config_opts['plugin_conf']['tmpfs_opts']['max_fs_size'] = '5120m'
config_opts['plugin_conf']['tmpfs_opts']['mode'] = '0755'
config_opts['plugin_conf']['tmpfs_opts']['required_ram_mb'] = 0
EOF
}

function init_repo() {
        # Stupidly provide a non-mock filesystem RPM for 'chroot_setup_cmd'.
        install_user_mock_config
        run_mock --scrub=all
        mkdir -p "$rpmdir/$arch" "$rpmdir/noarch" "$srpmdir"
        rpmbuild -bb "$specdir/gnuxc-filesystem.spec"
        createrepo_c --no-database --simple-md-filenames "$rpmdir"
        [ -z "$local_srpm" ] || dnf-install gnuxc-filesystem
}

function mock_build_everything() {
        run_mock --buildsrpm --symlink-dereference \
            --sources "$sourcedir" --spec "$1" &&
        run_mock --rebuild /dev/stdin < "$resultdir"/*.src.rpm
}

function mock_build_from_local_srpm() {
        rm -fr "$srpmdir"/mocktmp
        rpmbuild --define="_srcrpmdir $srpmdir/mocktmp" -bs "$1" &&
        run_mock --rebuild /dev/stdin < "$srpmdir"/mocktmp/*.src.rpm &&
        rm -fr "$srpmdir"/mocktmp
}

function do_the_build() {
        [ "$2" != gnuxc-filesystem ] || init_repo
        if [ -n "$local_srpm" ]
        then mock_build_from_local_srpm "$1" "$2"
        else mock_build_everything "$1" "$2"
        fi ||
                { echo "Failed to build the $2 package" 1>&2 ; exit 1 ; }
        for x in "$resultdir"/*.{$arch,noarch,src}.rpm
        do
                case "$x" in
                        *.$arch.rpm) cp -p "$x" "$rpmdir/$arch/" ;;
                        *.noarch.rpm) cp -p "$x" "$rpmdir/noarch/" ;;
                        *.src.rpm) cp -p "$x" "$srpmdir/" ;;
                esac ||
                        { echo "Failed to save ${x##*/}" 1>&2 ; exit 1 ; }
        done
}

fi

function build_pkg() {
        local spec=$specdir/gnuxc-$1.spec
        local pkg=gnuxc-${2:-$1}
        for x in "$rpmdir"/{$arch,noarch}/"$pkg"-[0-9]*.rpm ; do ! ; done ||
                { echo "Skipping $pkg (already exists)" ; return 0 ; }
        do_the_build "$spec" "$pkg"
        createrepo_c --no-database --simple-md-filenames "$rpmdir" ||
                { echo "Failed to refresh the repo for $pkg" 1>&2 ; exit 1 ; }
}


# Build every RPM using this example dependency chain.
bootstrap=1
build_pkg filesystem
build_pkg pkg-config
build_pkg binutils
build_pkg gcc
build_pkg gnumach       gnumach-headers
build_pkg mig
build_pkg hurd          hurd-headers
build_pkg glibc
build_pkg libatomic_ops
build_pkg gc
unset bootstrap
build_pkg gcc           gcc-c++
build_pkg ncurses
build_pkg readline
build_pkg sqlite
build_pkg expat
build_pkg zlib
build_pkg bzip2
build_pkg hurd          hurd-libs
build_pkg e2fsprogs     libuuid
build_pkg parted
build_pkg binutils      binutils-libs
build_pkg tcl
build_pkg file
build_pkg json-c
build_pkg attr
build_pkg acl
build_pkg xz
build_pkg pcre
build_pkg libogg
build_pkg libvorbis
build_pkg flac
build_pkg speexdsp
build_pkg speex
build_pkg libsndfile
build_pkg gmp
build_pkg mpfr
build_pkg mpc
build_pkg libffi
build_pkg gc
build_pkg libunistring
build_pkg libtool       libltdl
build_pkg guile
build_pkg glib
build_pkg liboop
build_pkg libidn2
build_pkg libtasn1
build_pkg nettle
build_pkg p11-kit
build_pkg gnutls
build_pkg libgpg-error
build_pkg libgcrypt
build_pkg osl
build_pkg isl
build_pkg cloog
build_pkg libpng
build_pkg freetype
build_pkg flex
build_pkg gdbm
build_pkg icu4c
build_pkg libpipeline
build_pkg python
build_pkg libxml2
build_pkg libcroco
build_pkg gettext
# (xorg
build_pkg font-util
build_pkg fontconfig
build_pkg libpciaccess
build_pkg pixman
build_pkg xproto        ; build_pkg libXau           ; build_pkg libXdmcp
build_pkg xtrans        ; build_pkg libICE           ; build_pkg libSM
build_pkg xextproto
build_pkg xcb-proto     ; build_pkg libpthread-stubs
build_pkg libxcb        ; build_pkg xcb-util-keysyms
build_pkg kbproto       ; build_pkg inputproto       ; build_pkg libX11
build_pkg libxkbfile
build_pkg libXext       ; build_pkg libXt
build_pkg libXmu        ; build_pkg libXpm           ; build_pkg libXaw
build_pkg fontsproto    ; build_pkg libfontenc       ; build_pkg libXfont2
build_pkg renderproto   ; build_pkg libXrender       ; build_pkg libXft
build_pkg fixesproto    ; build_pkg libXfixes        ; build_pkg libXi
build_pkg damageproto   ; build_pkg libXdamage
build_pkg randrproto    ; build_pkg libXrandr
build_pkg recordproto   ; build_pkg libXtst
build_pkg xineramaproto ; build_pkg libXinerama
build_pkg libxshmfence
build_pkg glproto       ; build_pkg mesa
build_pkg bigreqsproto  ; build_pkg presentproto     ; build_pkg resourceproto
build_pkg videoproto    ; build_pkg xcmiscproto      ; build_pkg xf86dgaproto
build_pkg xorg-server
build_pkg spice-protocol
# xorg)
build_pkg tk
build_pkg cairo
build_pkg harfbuzz
build_pkg pango
build_pkg libjpeg-turbo
build_pkg jasper
build_pkg giflib
build_pkg jbigkit
build_pkg tiff
build_pkg gdk-pixbuf
build_pkg librsvg
build_pkg libwebp
build_pkg ImageMagick
# (mozilla
build_pkg libepoxy
build_pkg atk
build_pkg gtk+
build_pkg pulseaudio
build_pkg libevent
build_pkg libvpx
build_pkg nspr
build_pkg nss
build_pkg gtk2
# mozilla)

# Install any remaining compilers and development packages.
dnf-install \
    'gnuxc-*-devel' gnuxc-gcc-{gfortran,objc++} gnuxc-mig gnuxc-pkg-config \
    'gnuxc-*proto' gnuxc-{libpthread-stubs,spice-protocol,xorg-server,xtrans} \
    gnuxc-{bzip2,glibc,libuuid,parted,zlib}-static
