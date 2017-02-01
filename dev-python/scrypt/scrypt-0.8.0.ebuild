# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python{2_7,3_4,3_5} pypy )

inherit distutils-r1

DESCRIPTION="Bindings for the scrypt key derivation function library"
HOMEPAGE="https://bitbucket.org/mhallin/py-scrypt"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD-2"
KEYWORDS="~amd64 ~arm64 x86"
SLOT="0"

IUSE="libressl"

# Tests fail due to silly import error, should be fixed next version
RESTRICT_USE="test"

DEPEND="${RDEPEND}
	!libressl? ( dev-libs/openssl )
	libressl? ( dev-libs/libressl )
	dev-python/setuptools[${PYTHON_USEDEP}]"

python_test() {
	esetup.py test
}
