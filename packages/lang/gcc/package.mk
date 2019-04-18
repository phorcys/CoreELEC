# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="gcc"

PKG_LICENSE="GPL"
PKG_SITE="http://gcc.gnu.org/"
PKG_URL="http://ftpmirror.gnu.org/gcc/$PKG_NAME-$PKG_VERSION/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_BOOTSTRAP="ccache:host autoconf:host binutils:host gmp:host mpfr:host mpc:host"
PKG_DEPENDS_TARGET="gcc:host"
PKG_DEPENDS_HOST="ccache:host autoconf:host binutils:host gmp:host mpfr:host mpc:host glibc"
PKG_LONGDESC="This package contains the GNU Compiler Collection."

case "$GCC_VER" in
  gcc-loongson-community)
    PKG_VERSION="8.2.0-gs2"
    PKG_SHA256="fc7a038daa588c2b2ac52dab32ce54f7fffcb425197477fc7e9f6bb7802553a4"
    PKG_SITE="https://github.com/loongson-community/gcc"
    PKG_URL="https://github.com/loongson-community/gcc/archive/$PKG_NAME-$PKG_VERSION.tar.gz"
    PKG_DEPENDS_BOOTSTRAP="ccache:host autoconf:host binutils:host gmp:host mpfr:host mpc:host"
    PKG_DEPENDS_TARGET="gcc:host"
    PKG_DEPENDS_HOST="ccache:host autoconf:host binutils:host gmp:host mpfr:host mpc:host glibc"
    PKG_LONGDESC="This package contains the GNU Compiler Collection."
    ;;
  gcc-loongson-community-8.1)
    PKG_VERSION="8.1.0"
    PKG_SHA256="fc7a038daa588c2b2ac52dab32ce54f7fffcb425197477fc7e9f6bb7802553a4"
    PKG_SITE="https://github.com/loongson-community/gcc"
    PKG_URL="https://github.com/loongson-community/gcc/archive/$PKG_NAME-$PKG_VERSION.tar.gz"
    PKG_DEPENDS_BOOTSTRAP="ccache:host autoconf:host binutils:host gmp:host mpfr:host mpc:host"
    PKG_DEPENDS_TARGET="gcc:host"
    PKG_DEPENDS_HOST="ccache:host autoconf:host binutils:host gmp:host mpfr:host mpc:host glibc"
    PKG_LONGDESC="This package contains the GNU Compiler Collection."
    ;;    
  gcc-mainline)
    PKG_VERSION="8ed952e276bc366ee11b0b8f98c93912093df67f"
    PKG_SHA256="628d3a71634b2c8d60be99257d8f281ae30bcdc38ef039c1e85ed163e8d24217"
    PKG_SITE="https://github.com/gcc-mirror/gcc"
    PKG_URL="https://github.com/gcc-mirror/gcc/archive/$PKG_VERSION.tar.gz"
    PKG_SOURCE_DIR="$PKG_NAME-$PKG_VERSION*/gcc"
    PKG_DEPENDS_BOOTSTRAP="ccache:host autoconf:host binutils:host gmp:host mpfr:host mpc:host"
    PKG_DEPENDS_TARGET="gcc:host"
    PKG_DEPENDS_HOST="ccache:host autoconf:host binutils:host gmp:host mpfr:host mpc:host glibc"
    PKG_LONGDESC="This package contains the GNU Compiler Collection."
    ;;    
  *)
    PKG_VERSION="8.2.0"
    PKG_SHA256="196c3c04ba2613f893283977e6011b2345d1cd1af9abeac58e916b1aab3e0080"
    PKG_SITE="http://gcc.gnu.org/"
    PKG_URL="http://ftpmirror.gnu.org/gcc/$PKG_NAME-$PKG_VERSION/$PKG_NAME-$PKG_VERSION.tar.xz"
    PKG_DEPENDS_BOOTSTRAP="ccache:host autoconf:host binutils:host gmp:host mpfr:host mpc:host"
    PKG_DEPENDS_TARGET="gcc:host"
    PKG_DEPENDS_HOST="ccache:host autoconf:host binutils:host gmp:host mpfr:host mpc:host glibc"
    PKG_LONGDESC="This package contains the GNU Compiler Collection."
    ;;
esac

GCC_COMMON_CONFIGURE_OPTS="--target=$TARGET_NAME \
                           --with-sysroot=$SYSROOT_PREFIX \
                           --with-gmp=$TOOLCHAIN \
                           --with-mpfr=$TOOLCHAIN \
                           --with-mpc=$TOOLCHAIN \
                           --with-gnu-as \
                           --with-gnu-ld \
                           --enable-plugin \
                           --enable-lto \
                           --enable-gold \
                           --enable-ld=default \
                           --with-linker-hash-style=gnu \
                           --disable-multilib \
                           --disable-nls \
                           --enable-checking=release \
                           --with-default-libstdcxx-abi=gcc4-compatible \
                           --without-ppl \
                           --without-cloog \
                           --disable-libada \
                           --disable-libmudflap \
                           --disable-libatomic \
                           --disable-libitm \
                           --disable-libquadmath \
                           --disable-libgomp \
                           --disable-libmpx \
                           --disable-libssp"

PKG_CONFIGURE_OPTS_BOOTSTRAP="$GCC_COMMON_CONFIGURE_OPTS \
                              --enable-languages=c \
                              --disable-__cxa_atexit \
                              --disable-libsanitizer \
                              --enable-cloog-backend=isl \
                              --disable-shared \
                              --disable-threads \
                              --without-headers \
                              --with-newlib \
                              --disable-decimal-float \
                              $GCC_OPTS"

PKG_CONFIGURE_OPTS_HOST="$GCC_COMMON_CONFIGURE_OPTS \
                         --enable-languages=c,c++ \
                         --enable-__cxa_atexit \
                         --enable-decimal-float \
                         --enable-tls \
                         --enable-shared \
                         --disable-static \
                         --enable-c99 \
                         --enable-long-long \
                         --enable-threads=posix \
                         --disable-libstdcxx-pch \
                         --enable-libstdcxx-time \
                         --enable-clocale=gnu \
                         $GCC_OPTS"

pre_configure_host() {
  export CXXFLAGS="$CXXFLAGS -std=gnu++98"
  unset CPP
}

post_make_host() {
  # fix wrong link
  rm -rf $TARGET_NAME/libgcc/libgcc_s.so
  ln -sf libgcc_s.so.1 $TARGET_NAME/libgcc/libgcc_s.so

  if [ ! "${BUILD_WITH_DEBUG}" = "yes" ]; then
    ${TARGET_PREFIX}strip $TARGET_NAME/libgcc/libgcc_s.so*
    ${TARGET_PREFIX}strip $TARGET_NAME/libstdc++-v3/src/.libs/libstdc++.so*
  fi
}

post_makeinstall_host() {
  cp -PR $TARGET_NAME/libstdc++-v3/src/.libs/libstdc++.so* $SYSROOT_PREFIX/usr/lib

  GCC_VERSION=`$TOOLCHAIN/bin/${TARGET_NAME}-gcc -dumpversion`
  DATE="0501`echo $GCC_VERSION | sed 's/\([0-9]\)/0\1/g' | sed 's/\.//g'`"
  CROSS_CC=${TARGET_PREFIX}gcc-${GCC_VERSION}
  CROSS_CXX=${TARGET_PREFIX}g++-${GCC_VERSION}

  rm -f ${TARGET_PREFIX}gcc

cat > ${TARGET_PREFIX}gcc <<EOF
#!/bin/sh
$TOOLCHAIN/bin/ccache $CROSS_CC "\$@"
EOF

  chmod +x ${TARGET_PREFIX}gcc

  # To avoid cache trashing
  touch -c -t $DATE $CROSS_CC

  [ ! -f "$CROSS_CXX" ] && mv ${TARGET_PREFIX}g++ $CROSS_CXX

cat > ${TARGET_PREFIX}g++ <<EOF
#!/bin/sh
$TOOLCHAIN/bin/ccache $CROSS_CXX "\$@"
EOF

  chmod +x ${TARGET_PREFIX}g++

  # To avoid cache trashing
  touch -c -t $DATE $CROSS_CXX

  # install lto plugin for binutils
  mkdir -p $TOOLCHAIN/lib/bfd-plugins
    ln -sf ../gcc/$TARGET_NAME/$GCC_VERSION/liblto_plugin.so $TOOLCHAIN/lib/bfd-plugins
}

configure_target() {
 : # reuse configure_host()
}

make_target() {
 : # reuse make_host()
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib
    cp -P $PKG_BUILD/.$HOST_NAME/$TARGET_NAME/libgcc/libgcc_s.so* $INSTALL/usr/lib
    cp -P $PKG_BUILD/.$HOST_NAME/$TARGET_NAME/libstdc++-v3/src/.libs/libstdc++.so* $INSTALL/usr/lib
}

configure_init() {
 : # reuse configure_host()
}

make_init() {
 : # reuse make_host()
}

makeinstall_init() {
  mkdir -p $INSTALL/usr/lib
    cp -P $PKG_BUILD/.$HOST_NAME/$TARGET_NAME/libgcc/libgcc_s.so* $INSTALL/usr/lib
}
