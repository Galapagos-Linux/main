# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy pypy3 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 eutils versionator

MY_PN="Sphinx"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python documentation generator"
HOMEPAGE="http://sphinx.pocoo.org/ https://pypi.python.org/pypi/Sphinx"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="doc latex test"

# Portage has only >= minimum required versions of all rdeps making
# setting of version borders unnecessary
RDEPEND="
	<dev-python/docutils-0.13[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	latex? (
		dev-texlive/texlive-latexextra
		app-text/dvipng
	)"
DEPEND="${DEPEND}
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

S="${WORKDIR}/${MY_P}"

python_compile() {
	distutils-r1_python_compile

	# Generate the grammar. It will be caught by install somehow.
	# Note that the tests usually do it for us. However, I don't want
	# to trust USE=test really running all the tests, especially
	# with FEATURES=test-fail-continue.
	pushd "${BUILD_DIR}"/lib > /dev/null || die
	"${PYTHON}" -m sphinx.pycode.__init__ \
		|| die "Grammar generation failed."
	popd > /dev/null || die
}

python_compile_all() {
	use doc && emake -C doc SPHINXBUILD='"${PYTHON}" "${S}/sphinx-build.py"' html
}

python_test() {
	cp -r -l tests "${BUILD_DIR}"/ || die

	if $(python_is_python3); then
		2to3 -w --no-diffs "${BUILD_DIR}"/tests || die
	fi

	nosetests -w "${BUILD_DIR}"/tests -v \
		|| die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/_build/html/. )

	distutils-r1_python_install_all
}

replacing_python_eclass() {
	local pv
	for pv in ${REPLACING_VERSIONS}; do
		if ! version_is_at_least 1.1.3-r4 ${pv}; then
			return 0
		fi
	done

	return 1
}

pkg_preinst() {
	if replacing_python_eclass; then
		# the old python.eclass ebuild will want to remove our pickles...
		backup_pickle() {
			# array to enable filename expansion
			local pickle_name=(
				"${D}$(python_get_sitedir)"/sphinx/pycode/Grammar*.pickle
			)

			local dest=${ROOT}${pickle_name[0]#${D}}.backup

			eumask_push 022
			mkdir -p "${dest%/*}" || die
			eumask_pop

			cp -p -v "${pickle_name[0]}" "${dest}" \
				|| die "Unable to backup grammar pickle from overwriting"
		}

		python_foreach_impl backup_pickle
	fi
}

pkg_postinst() {
	if replacing_python_eclass; then
		local warned

		restore_pickle() {
			local backup_name=(
				"${ROOT}$(python_get_sitedir)"/sphinx/pycode/Grammar*.pickle.backup
			)
			local dest=${backup_name[0]%.backup}

			mv -v "${backup_name[0]}" "${dest}" \
				|| die "Unable to restore grammar pickle backup"
		}

		python_foreach_impl restore_pickle

		[[ ${warned} ]] && ewarn "Please try rebuilding the package."
	fi
}
