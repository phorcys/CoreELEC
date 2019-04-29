# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="gcc-loongson-mips64"
PKG_VERSION="4.9.3-64-gnu"
PKG_SHA256="3a8f5a2d22c05d09025cbacdc41b71af261f50d0b73018865a9c6db0517bc749"
PKG_LICENSE="GPL"
PKG_SITE=""
PKG_URL="http://ftp.loongnix.org/loongsonpi/pi_2/toolchain/gcc-4.9.3-64-gnu.tar.gz"
PKG_DEPENDS_HOST="ccache:host"
PKG_LONGDESC="Loongson GNU Linux Binary Toolchain"
PKG_TOOLCHAIN="manual"

makeinstall_host() {
  echo "mkdir -p $TOOLCHAIN/lib/gcc-loongson-mips64/"
  mkdir -p $TOOLCHAIN/lib/gcc-loongson-mips64/
  echo "cp -ar gcc-4.9.3-64-gnu/* $TOOLCHAIN/lib/gcc-loongson-mips64"
  cp -ar gcc-4.9.3-64-gnu/* $TOOLCHAIN/lib/gcc-loongson-mips64
}
