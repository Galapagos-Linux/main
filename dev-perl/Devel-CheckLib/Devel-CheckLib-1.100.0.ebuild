# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MATTN
DIST_VERSION=1.10
inherit perl-module

DESCRIPTION="check that a library is available"

SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86"
IUSE="test"

RDEPEND="
	>=virtual/perl-File-Temp-0.160.0
	virtual/perl-Exporter
	virtual/perl-File-Spec
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-Test-Simple-0.620.0
		>=dev-perl/IO-CaptureOutput-1.80.100
		>=dev-perl/Mock-Config-0.20.0
	)
"
