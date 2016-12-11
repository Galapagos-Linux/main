# Copyright 1999-2016 The Galapagos Linux Team
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Manipulate historical archives of files in compressed form"
HOMEPAGE="http://ftp.math.utah.edu/pub/zoo/"
SRC_URI="ftp://ftp.kiarchive.ru/pub/unix/arcers/${P}pl1.tar.gz
	mirror://gentoo/${P}-gcc-issues-fix.patch"

LICENSE="zoo"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~m68k-mint ~sparc-solaris ~x86-solaris"
IUSE=""

S=${WORKDIR}

PATCHES=(
	"${DISTDIR}"/${P}-gcc-issues-fix.patch
	"${FILESDIR}"/${P}-CAN-2005-2349.patch
	"${FILESDIR}"/${P}-febz-183426.patch
	"${FILESDIR}"/${P}-security_pathsize.patch
	"${FILESDIR}"/${P}-multiple-dos-fix.patch
	"${FILESDIR}"/${P}-gentoo-fbsd.patch
)

src_compile() {
	# emake no workie on FreeBSD
	make CC="$(tc-getCC)" linux || die
}

src_install() {
	dobin zoo fiz || die
	doman zoo.1 fiz.1
}

pkg_postinst() {
    einfo "This package is intended for historical use only and should not be used in production."
	einfo "Please see https://github.com/Galapagos-Linux/main/issues/5 for more info."
}
