{
  buildPackages,
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  cairo,
  doxygen,
  glib,
  libdicom,
  libjpeg,
  libpng,
  libtiff,
  libxml2,
  openjpeg,
  sqlite,
  zlib,
  zstd,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openslide";
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "openslide";
    repo = "openslide";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9OrPdhO6ysDL6xSzCGv6IYWvYErZeMwb/VkU9YZp5Zg=";
  };

  __structuredAttrs = true;
  strictDeps = true;
  outputs = [
    "out"
    "dev"
    "man"
  ];

  depsBuildBuild = [
    buildPackages.stdenv.cc
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    doxygen
  ];

  # The upstream developer test suite creates a virtualenv and downloads dependencies.
  doCheck = false;
  mesonFlags = [ "-Dtest=disabled" ];

  buildInputs = [
    cairo
    glib
    libdicom
    libjpeg
    libpng
    libtiff
    libxml2
    openjpeg
    sqlite
    zlib
    zstd
  ];

  passthru = {
    tests = {
      pkg-config = testers.hasPkgConfigModules {
        package = finalAttrs.finalPackage.dev;
        versionCheck = true;
      };
    };
  };

  meta = {
    homepage = "https://openslide.org";
    description = "C library that provides a simple interface to read whole-slide images";
    license = lib.licenses.lgpl21;
    changelog = "https://github.com/openslide/openslide/releases/tag/v${finalAttrs.version}";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ lromor ];
    mainProgram = "slidetool";
  };
})
