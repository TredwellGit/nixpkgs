{ lib, stdenv, fetchurl }:

# Note: this package is used for bootstrapping fetchurl, and thus
# cannot use fetchpatch! All mutable patches (generated by GitHub or
# cgit) that are needed here should be included directly in Nixpkgs as
# files.

stdenv.mkDerivation rec {
  pname = "patchelf";
  version = "0.12";

  src = fetchurl {
    url = "https://github.com/NixOS/${pname}/releases/download/${version}/${pname}-${version}.tar.bz2";
    sha256 = "14npmdxppmh0ci140w8i8cy7zg1pnqg81a1mdsnza711ab7k36k9";
  };

  hardeningDisable = [ "pie" ];

  setupHook = [ ./setup-hook.sh ];

  # fails 8 out of 24 tests, problems when loading libc.so.6
  doCheck = stdenv.name == "stdenv-linux";

  meta = with lib; {
    homepage = "https://github.com/NixOS/patchelf/blob/master/README";
    license = licenses.gpl3;
    description = "A small utility to modify the dynamic linker and RPATH of ELF executables";
    maintainers = [ maintainers.eelco ];
    platforms = platforms.all;
  };
}
