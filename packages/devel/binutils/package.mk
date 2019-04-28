# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="binutils"
PKG_LICENSE="GPL"

case "$BINUTILS_VER" in
  binutils-loongson-community)
    PKG_VERSION="2.31.1-gs2"
    PKG_SHA256="b5bb5108b342d4ad2b790e41ef67ea4470df1693a86f37229971265ecca12086"
    PKG_SITE="https://github.com/loongson-community/binutils-gdb"
    PKG_URL="https://github.com/loongson-community/binutils-gdb/archive/$PKG_NAME-$PKG_VERSION.tar.gz"
    PKG_DEPENDS_HOST="ccache:host bison:host flex:host linux:host"
    PKG_DEPENDS_TARGET="toolchain binutils:host"
    PKG_LONGDESC="A GNU collection of binary utilities."
    ;;
  binutils-loongson-lts)
    PKG_VERSION="2.24"
    PKG_SHA256="035c7069a664ca7af97d544cc2c1a72fc96c783e613e36460f3ab39de8dcee2f"
    PKG_COMMIT="64301c470c32067e73a4b3e894523b8cddf3064d"
    PKG_SITE="http://cgit.loongnix.org/cgit/binutils-2.24"
    PKG_URL="http://cgit.loongnix.org/cgit/binutils-2.24/snapshot/$PKG_NAME-$PKG_VERSION-$PKG_COMMIT.tar.gz"
    PKG_DEPENDS_HOST="ccache:host bison:host flex:host linux:host"
    PKG_DEPENDS_TARGET="toolchain binutils:host"
    PKG_LONGDESC="A GNU collection of binary utilities."
    ;;    
  *)
    PKG_VERSION="2.31.1"
    PKG_SHA256="e88f8d36bd0a75d3765a4ad088d819e35f8d7ac6288049780e2fefcad18dde88"
    PKG_SITE="http://www.gnu.org/software/binutils/"
    PKG_URL="http://ftpmirror.gnu.org/binutils/$PKG_NAME-$PKG_VERSION.tar.gz"
    PKG_DEPENDS_HOST="ccache:host bison:host flex:host linux:host"
    PKG_DEPENDS_TARGET="toolchain binutils:host"
    PKG_LONGDESC="A GNU collection of binary utilities."
    ;;
esac


PKG_CONFIGURE_OPTS_HOST="--target=$TARGET_NAME \
                         --with-sysroot=$SYSROOT_PREFIX \
                         --with-lib-path=$SYSROOT_PREFIX/lib:$SYSROOT_PREFIX/usr/lib \
                         --without-ppl \
                         --without-cloog \
                         --disable-werror \
                         --disable-multilib \
                         --disable-libada \
                         --disable-libssp \
                         --enable-version-specific-runtime-libs \
                         --enable-plugins \
                         --enable-gold \
                         --enable-ld=default \
                         --enable-lto \
                         --disable-nls \
                         --enable-static \
                         --enable-static"

PKG_CONFIGURE_OPTS_TARGET="--target=$TARGET_NAME \
                         --with-sysroot=$SYSROOT_PREFIX \
                         --with-lib-path=$SYSROOT_PREFIX/lib:$SYSROOT_PREFIX/usr/lib \
                         --without-ppl \
                         --without-cloog \
                         --enable-static \
                         --disable-shared \
                         --disable-werror \
                         --disable-multilib \
                         --disable-libada \
                         --disable-libssp \
                         --disable-plugins \
                         --disable-gold \
                         --disable-ld \
                         --disable-lto \
                         --disable-nls \
                         --enable-default-hash-style=sysv"

PKG_LDFLAGS_TARGET=" -Wl,--hash-style=sysv"

pre_configure_host() {
  unset CPPFLAGS
  unset CFLAGS
  unset CXXFLAGS
  unset LDFLAGS
}

make_host() {
  make configure-host
  make
}

makeinstall_host() {
  cp -v ../include/libiberty.h $SYSROOT_PREFIX/usr/include
  make install
}

make_target() {
  make configure-host
  make -C libiberty
  make -C bfd
}

makeinstall_target() {
  mkdir -p $SYSROOT_PREFIX/usr/lib
    cp libiberty/libiberty.a $SYSROOT_PREFIX/usr/lib
  make DESTDIR="$SYSROOT_PREFIX" -C bfd install
}
