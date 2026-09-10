{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libxkbcommon,
  stdenv,
  wayland,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jwt-ui";
  version = "1.3.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jwt-rs";
    repo = "jwt-ui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hul8QHBRUbKaTvlqykq7tT6KSEd2P0SB37eTK2kO5gI=";
  };

  cargoHash = "sha256-+086XOIQRLj/SS9Dv2oBTncGDmUlZ4UWC84vNugwd1s=";

  # TODO: have the program use OSC52 to copy to clipboard in a terminal
  # than depend on wayland and x11 stuff
  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libxkbcommon
  ]
  ++ lib.optionals stdenv.isLinux [
    wayland
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "TUI for decoding/encoding JSON Web Tokens";
    homepage = "https://jwtui.cli.rs/";
    downloadPage = "https://github.com/jwt-rs/jwt-ui";
    changelog = "https://github.com/jwt-rs/jwt-ui/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "jwt-ui";
  };
})
