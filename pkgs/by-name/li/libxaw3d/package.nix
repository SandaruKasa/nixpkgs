{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  pkg-config,
  util-macros,
  bison,
  flex,
  libxext,
  libxmu,
  libxpm,
  libxt,
  xorgproto,
  nix-update-script,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libxaw3d";
  version = "1.6.6";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "lib";
    repo = "libxaw3d";
    tag = "libXaw3d-${finalAttrs.version}";
    hash = "sha256-7w5FnvxbztfdH7QPPqvHyJdAhTyNfe0Je4x+J80dJIY=";
  };

  __structuredAttrs = true;
  strictDeps = true;
  doCheck = false; # no tests
  enableParallelBuilding = true;
  outputs = [
    "out"
    "doc"
    "dev"
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    util-macros
    bison
    flex
  ];

  buildInputs = [
    libxext
    libxpm
  ];

  propagatedBuildInputs = [
    libxmu
    libxt
    xorgproto
  ];

  passthru = {
    updateScript = nix-update-script { extraArgs = [ "--version-regex=libXaw3d-(.*)" ]; };
    tests = {
      pkg-config = testers.hasPkgConfigModules {
        package = finalAttrs.finalPackage.dev;
        versionCheck = true;
      };
    };
  };

  meta = {
    description = "3D appearance variant of the X Athena Widget Set";
    homepage = "https://gitlab.freedesktop.org/xorg/lib/libxaw3d";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sandarukasa ];
    platforms = lib.platforms.unix;
    pkgConfigModules = [ "xaw3d" ];
  };
})
