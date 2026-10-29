{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  zstd,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nix-options-search";
  version = "0.3.5";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "madsbv";
    repo = "nix-options-search";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0Y4PT6f/pttYliAM8hlAMKh47ACO50Cm6U6JjD3LKg4=";
  };

  cargoHash = "sha256-HVKt5sVbMpRrFP9VJcj8Kv4iAnU6NXHjhz2B4xE7yaA=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    zstd
  ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast and convenient command-line tool to look up options for configuring nix-darwin, nixOS, and home-manager quickly, with fuzzy finding";
    homepage = "https://github.com/madsbv/nix-options-search";
    changelog = "https://github.com/madsbv/nix-options-search/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      tost
      mit
    ];
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "nox";
  };
})
