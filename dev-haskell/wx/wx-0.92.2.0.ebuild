# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

# ebuild generated by hackport 0.4.7.9999

WX_GTK_VER="3.0"

CABAL_FEATURES="lib profile haddock hoogle hscolour"
inherit haskell-cabal

DESCRIPTION="wxHaskell"
HOMEPAGE="https://wiki.haskell.org/WxHaskell"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="wxWinLL-3.1"
SLOT="${WX_GTK_VER}/${PV}"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND="dev-haskell/stm:=[profile?]
	>=dev-haskell/wxcore-0.92:${WX_GTK_VER}=[profile?]
	>=dev-lang/ghc-7.6.1:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.16.0
"

src_configure() {
	# ghc DCE bug: https://ghc.haskell.org/trac/ghc/ticket/9155
	[[ $(ghc-version) == 7.8.2 ]] && replace-hcflags -O[2-9] -O1
	# ghc DCE bug: https://ghc.haskell.org/trac/ghc/ticket/9303
	[[ $(ghc-version) == 7.8.3 ]] && replace-hcflags -O[2-9] -O1

	haskell-cabal_src_configure \
		--flag=newbase
}
