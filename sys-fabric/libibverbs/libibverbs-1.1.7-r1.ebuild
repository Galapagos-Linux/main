# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

OFED_VER="3.12"
OFED_RC="1"
OFED_RC_VER="1"
OFED_SUFFIX="1.gcbf2a35"

inherit openib multilib-minimal

DESCRIPTION="A library allowing programs to use InfiniBand 'verbs' for direct access to IB hardware"

KEYWORDS="~amd64 ~arm ~ppc64 ~x86 ~amd64-linux"
IUSE="static-libs"

DEPEND=""
RDEPEND="${DEPEND}
	!sys-fabric/openib-userspace"
block_other_ofed_versions

multilib_src_configure() {
	ECONF_SOURCE=${S} \
	econf $(use_enable static-libs static)
}

multilib_src_install_all() {
	einstalldocs
	use static-libs || find "${ED}/usr" -name '*.la' -delete
}
