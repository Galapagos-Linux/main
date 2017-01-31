# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit distutils-r1

DESCRIPTION="Bindings for the scrypt key derivation function library"
HOMEPAGE="https://bitbucket.org/mhallin/py-scrypt"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD-2"
KEYWORDS="amd64 ~arm64 x86"
SLOT="0"

# Tests fail due to silly import error, should be fixed next version
#IUSE="test"

DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

#python_test() {
#	esetup.py test
#}
