# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit cmake-utils eutils pam versionator bash-completion-r1

MY_P=${PN}_${PV}
DEB_REL=2

DESCRIPTION="Utility to execute commands in a chroot environment"
HOMEPAGE="http://packages.debian.org/source/sid/schroot"
SRC_URI="mirror://debian/pool/main/${PN::1}/${PN}/${MY_P}.orig.tar.xz
	mirror://debian/pool/main/${PN::1}/${PN}/${MY_P}-${DEB_REL}.debian.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="btrfs +dchroot debug doc lvm nls pam test"

COMMON_DEPEND="
	>=dev-libs/boost-1.42.0
	>=sys-apps/util-linux-2.16
	btrfs? ( >=sys-fs/btrfs-progs-0.19-r2 )
	lvm? ( sys-fs/lvm2 )
	pam? ( sys-libs/pam )
"

DEPEND="${COMMON_DEPEND}
	app-arch/xz-utils
	sys-apps/groff
	doc? (
		app-doc/doxygen
		media-gfx/graphviz
	)
	nls? (
		>=app-text/po4a-0.40
		sys-devel/gettext
	)
	test? ( >=dev-util/cppunit-1.10.0 )
"
RDEPEND="${COMMON_DEPEND}
	sys-apps/debianutils
	dchroot? ( !sys-apps/dchroot )
	nls? ( virtual/libintl )
"

PATCHES=(
	"${S}/debian/patches/Add-support-for-more-compression-formats.patch"
	"${S}/debian/patches/Add-SESSION_SOURCE-and-CHROOT_SESSION_SOURCE.patch"
	"${S}/debian/patches/10mount-Move-mount-directory-to-var-run.patch"
	"${S}/debian/patches/Support-union-mounts-with-overlay-as-in-Linux-4.0.patch"
	"${S}/debian/patches/GCC5-fixes-on-regexes.patch"
)

src_unpack() {
	unpack ${MY_P}.orig.tar.xz
	cd "${S}"
	unpack ${MY_P}-${DEB_REL}.debian.tar.xz
}

src_prepare() {
	sed -i -e 's/warn(/message(WARNING /' man/CMakeLists.txt || die
	sed -i -e '/^have schroot/d' etc/bash_completion/schroot || die

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-Dbtrfs-snapshot=$(usex btrfs)
		-Ddchroot=$(usex dchroot)
		-Ddchroot-dsa=$(usex dchroot)
		-Ddebug=$(usex debug)
		-Ddoxygen=$(usex doc)
		-Dlvm-snapshot=$(usex lvm)
		-Dnls=$(usex nls)
		-Dpam=$(usex pam)
		-Dtest=$(usex test)
		-Dbash_completion_dir="$(get_bashcompdir)"
		-DCMAKE_INSTALL_SYSCONFDIR="${EPREFIX}/etc"
		-DCMAKE_INSTALL_LOCALSTATEDIR="${EPREFIX}/var"
	)
	if ! use nls; then
		mycmakeargs+=(-DPO4A_EXECUTABLE=NOTFOUND)
	fi

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile all $(usev doc)
}

src_test() {
	if [[ $EUID -ne 0 ]]; then
		ewarn "Disabling tests because you are not root"
		return 0
	fi

	cmake-utils_src_test
}

src_install() {
	cmake-utils_src_install

	insinto /usr/share/doc/${PF}/contrib/setup.d
	doins contrib/setup.d/05customdir contrib/setup.d/09fsck contrib/setup.d/10mount-ssh

	newdoc debian/schroot.NEWS NEWS.debian

	newinitd "${FILESDIR}"/schroot.initd schroot
	newconfd "${FILESDIR}"/schroot.confd schroot

	if use doc; then
		docinto html/sbuild
		dohtml "${BUILD_DIR}"/doc/sbuild/html/*
		docinto html/schroot
		dohtml "${BUILD_DIR}"/doc/schroot/html/*
	fi

	if use pam; then
		rm -f "${ED}"etc/pam.d/schroot
		pamd_mimic_system schroot auth account session
	fi
}

pkg_postinst() {
	if [[ ${REPLACING_VERSIONS} == 1.[24]* ]]; then
		elog "Please read /usr/share/doc/${PF}/NEWS.debian* for important"
		elog "upgrade information."
	fi
	# If installing to a running system, upgrading from <=1.6.10-r3, then
	# make sure that the runtime dirs are still visible to the new install
	if [[ ${ROOT} == / && ${REPLACING_VERSIONS} ]] && ! version_is_at_least 1.6.10-r4 ${REPLACING_VERSIONS}; then
		ln -s "${EPREFIX}"/var/lib/schroot "${EPREFIX}"/var/run/schroot
	fi
}

pkg_postrm() {
	if [[ -z ${REPLACED_BY_VERSION} ]]; then
		for dir in $(find "${EROOT}"/var/lib/schroot/mount -maxdepth 1 -type d | tac); do
			rmdir "$dir" || elog "Failed to remove session mount directory $dir: Please check for any stray mounts or data under this directory and remove by hand."
		done
	fi
}
