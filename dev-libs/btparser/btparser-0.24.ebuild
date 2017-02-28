# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit eutils python-single-r1

DESCRIPTION="Parser and analyzer for backtraces produced by gdb"
HOMEPAGE="https://fedorahosted.org/btparser/"
SRC_URI="https://fedorahosted.org/released/${PN}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0/2"
KEYWORDS="amd64 x86"
IUSE="static-libs"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	>=dev-libs/glib-2.21:2"
DEPEND="${RDEPEND}
	app-arch/xz-utils"

src_configure() {
	export PYTHON_CFLAGS=$(python_get_CFLAGS)
	export PYTHON_LIBS=$(python_get_LIBS)

	econf \
		$(use_enable static-libs static) \
		--disable-maintainer-mode
}

src_install() {
	default
	prune_libtool_files --modules
}
