{ lib, stdenv, kernel, fetchFromGitHub, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "zenpower";
  version = "0.1.12";

  src = fetchFromGitHub {
    owner = "ocerman";
    repo = "zenpower";
    rev = "v${version}";
    sha256 = "116yrw4ygh3fqwhniaqq0nps29pq87mi2q1375f1ylkfiak8n63a";
  };

  hardeningDisable = [ "pic" "pie" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = [ "KERNEL_BUILD=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build" ];

  installPhase = ''
    install -D zenpower.ko -t "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/hwmon/zenpower/"
  '';

  meta = with lib; {
    description = "Linux kernel driver for reading temperature, voltage(SVI2), current(SVI2) and power(SVI2) for AMD Zen family CPUs.";
    homepage = "https://github.com/ocerman/zenpower";
    license = licenses.gpl2;
    maintainers = with maintainers; [ alexbakker ];
    platforms = [ "x86_64-linux" ];
    broken = versionOlder kernel.version "4.14";
  };
}
