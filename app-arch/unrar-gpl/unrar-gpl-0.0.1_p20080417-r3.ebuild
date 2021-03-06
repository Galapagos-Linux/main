# Copyright 2016 The Galapagos Linux Team
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools flag-o-matic

DESCRIPTION="Free RAR unpacker for old (pre-v3) RAR files"
HOMEPAGE="http://home.gna.org/unrar/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE=""
DEPEND="!elibc_glibc? (
	sys-libs/argp-standalone
	!elibc_musl? ( dev-libs/gnulib )
	)"
RDEPEND=""

DOCS="AUTHORS README"

S=${WORKDIR}/${PN/-gpl}

src_prepare() {
	epatch -p0 "${FILESDIR}"/${PN}-0.0.1-solaris.patch
	default

	sed -i configure.ac -e 's|AM_CONFIG_HEADER|AC_CONFIG_HEADERS|g' || die
	eautoreconf

	if [[ ${CHOST} == *-aix* || ${CHOST} == *-solaris* ]]; then
		append-cppflags -I"${EPREFIX}"/usr/$(get_libdir)/gnulib/include
		append-ldflags -L"${EPREFIX}"/usr/$(get_libdir)/gnulib/lib
		append-libs -lgnu
	fi
}

src_configure() {
	econf --program-suffix="-gpl"
}
