# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_4 python3_5 )

inherit distutils-r1

DESCRIPTION="library for running  multi-thread, multi-process applications"
HOMEPAGE="https://pypi.python.org/pypi/oslo.concurrency"
SRC_URI="mirror://pypi/${PN:0:1}/oslo.concurrency/oslo.concurrency-${PV}.tar.gz"
S="${WORKDIR}/oslo.concurrency-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE="test"

CDPEND=">=dev-python/pbr-1.8[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	${CDEPEND}
	test? (
		>=dev-python/oslotest-1.10.0[${PYTHON_USEDEP}]
		>=dev-python/coverage-4.0[${PYTHON_USEDEP}]
		virtual/python-futures[${PYTHON_USEDEP}]
		>=dev-python/fixtures-3.0.0[${PYTHON_USEDEP}]
		>=dev-python/oslo-sphinx-4.7.0[${PYTHON_USEDEP}]
		>=dev-python/sphinx-1.2.1[${PYTHON_USEDEP}]
		<dev-python/sphinx-1.4[${PYTHON_USEDEP}]
		>=dev-python/reno-1.8.0[${PYTHON_USEDEP}]
		>=dev-python/eventlet-0.18.4[${PYTHON_USEDEP}]
	)"
RDEPEND="
	${CDEPEND}
	virtual/python-enum34[${PYTHON_USEDEP}]
	>=dev-python/oslo-config-3.14.0[${PYTHON_USEDEP}]
	!~dev-python/oslo-config-3.18.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-3.18.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/fasteners-0.7[${PYTHON_USEDEP}]
"

python_prepare_all() {
	sed -i '/^futures/d' test-requirements.txt || die
	sed -i '/^hacking/d' test-requirements.txt || die
	distutils-r1_python_prepare_all
}

python_test() {
	nosetests tests/ || die "test failed under ${EPYTHON}"
}
