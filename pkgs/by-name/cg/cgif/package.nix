{
  stdenv,
  fetchFromGitHub,
  lib,
  meson,
  ninja,
  testers,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cgif";
  version = "0.5.4";

  __structedAttrs = true;
  strictDeps = true;
  doCheck = true;
  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "dloebl";
    repo = "cgif";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rWw7dlqS/NsrrtRfYfmnC6ubHJLie5301S9C0uognnw=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  nativeCheckInputs = [
    python3
  ];
  preCheck = ''
    patchShebangs ../tests/scripts
  '';

  passthru = {
    tests = {
      pkg-config = testers.hasPkgConfigModules {
        package = finalAttrs.finalPackage.dev;
        versionCheck = true;
      };
    };
  };

  meta = {
    homepage = "https://github.com/dloebl/cgif";
    description = "GIF encoder written in C";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      sandarukasa
    ];
    platforms = lib.platforms.unix;
  };
})
