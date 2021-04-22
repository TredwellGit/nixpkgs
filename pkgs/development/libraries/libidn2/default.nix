{ fetchurl, lib, stdenv, libiconv, libunistring, help2man, buildPackages }:

# Note: this package is used for bootstrapping fetchurl, and thus
# cannot use fetchpatch! All mutable patches (generated by GitHub or
# cgit) that are needed here should be included directly in Nixpkgs as
# files.

with lib;

stdenv.mkDerivation rec {
  pname = "libidn2";
  version = "2.3.0";

  src = fetchurl {
    url = "mirror://gnu/gnu/libidn/${pname}-${version}.tar.gz";
    sha256 = "1ddqr80kmz4l8g3r3gf7bmf2v29fgivlc2bgxfiscjg2sarivjz1";
  };

  hardeningDisable = [ "pie" ];

  outputs = [ "bin" "dev" "out" "info" "devdoc" ];

  patches = optional stdenv.isDarwin ./fix-error-darwin.patch;

  nativeBuildInputs = optional stdenv.isDarwin help2man;
  buildInputs = [ libunistring ] ++ optional stdenv.isDarwin libiconv;
  depsBuildBuild = [ buildPackages.stdenv.cc ];

  meta = {
    homepage = "https://www.gnu.org/software/libidn/#libidn2";
    description = "Free software implementation of IDNA2008 and TR46";

    longDescription = ''
      Libidn2 is believed to be a complete IDNA2008 and TR46 implementation,
      but has yet to be as extensively used as the IDNA2003 Libidn library.

      The installed C library libidn2 is dual-licensed under LGPLv3+|GPLv2+,
      while the rest of the package is GPLv3+.  See the file COPYING for
      detailed information.
    '';

    repositories.git = "https://gitlab.com/jas/libidn2";
    license = with lib.licenses; [ lgpl3Plus gpl2Plus gpl3Plus ];
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ fpletz ];
  };
}
