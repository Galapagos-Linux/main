# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# ebuild generated by hackport 0.5.9999
#hackport: flags: -mtl-compat

CABAL_FEATURES="bin lib profile haddock hoogle hscolour"
inherit haskell-cabal

MY_PN="DAV"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="RFC 4918 WebDAV support"
HOMEPAGE="http://floss.scru.org/hDAV"
SRC_URI="mirror://hackage/packages/archive/${MY_PN}/${PV}/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="+network-uri"

RDEPEND=">=dev-haskell/case-insensitive-0.4:=[profile?]
	dev-haskell/data-default:=[profile?]
	>=dev-haskell/exceptions-0.7:=[profile?]
	dev-haskell/haskeline:=[profile?]
	>=dev-haskell/http-client-0.4:=[profile?]
	>=dev-haskell/http-client-tls-0.2:=[profile?]
	>=dev-haskell/http-types-0.7:=[profile?]
	>=dev-haskell/lens-3.0:=[profile?]
	>=dev-haskell/mtl-2.2.1:=[profile?]
	>=dev-haskell/optparse-applicative-0.10.0:=[profile?]
	dev-haskell/transformers-base:=[profile?]
	>=dev-haskell/transformers-compat-0.3:=[profile?]
	dev-haskell/utf8-string:=[profile?]
	>=dev-haskell/xml-conduit-1.0:=[profile?]
	>=dev-haskell/xml-hamlet-0.4:=[profile?] <dev-haskell/xml-hamlet-0.5:=[profile?]
	>=dev-lang/ghc-7.8.2:=
	network-uri? ( >=dev-haskell/network-2.6:=[profile?]
			>=dev-haskell/network-uri-2.6:=[profile?] )
	!network-uri? ( >=dev-haskell/network-2.3:=[profile?] <dev-haskell/network-2.6:=[profile?] )
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.18.1.3
"

S="${WORKDIR}/${MY_P}"

src_configure() {
	haskell-cabal_src_configure \
		--flag=-mtl-compat \
		$(cabal_flag network-uri network-uri)
}
