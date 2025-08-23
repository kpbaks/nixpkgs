{
  lib,
  stdenv,
  pkg-config,
  cmake,
  python3,
  zig,
  fetchFromGitHub,
  nix-update-script,
  makeWrapper,
  versionCheckHook,
}:

# fixes https://github.com/NixOS/nixpkgs/issues/393700
stdenv.mkDerivation (finalAttrs: {
  pname = "lightpanda";
  version = "nightly";

  src = fetchFromGitHub {
    owner = "lightpanda-io";
    repo = "browser";
    # rev = "e26d4afce26f983efe196f5b594612c481538acf";
    # TODO: wait for a semver release
    tag = "${finalAttrs.version}";
    hash = "sha256-wrE0adv9RaD+HmLM7hYB4SdiAnk9wcDlEQjWYp2Bx3k=";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
    python3
    zig.hook
    makeWrapper
  ];

  # TODO: disable telemetry using makeWrapper
  # https://github.com/lightpanda-io/browser#telemetry

  passthru.updateScript = nix-update-script { };

  # nativeInstallCheckInputs = [ versionCheckHook ];
  # versionCheckProgramArg = "--version";
  # doInstallCheck = true;

  meta = {
    description = "";
    homepage = "";
    maintainers = with lib.maintainers; [ kpbaks ];
    license = [ ];
    mainProgram = "lightpanda";
  };
})
