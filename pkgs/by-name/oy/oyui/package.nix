{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  oniguruma,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "oyui";
  version = "0.1.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "emilien-jegou";
    repo = "oyui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zMG13ILr7hyzC4eTgwFDnb5IiiCdMdIZBy+oAOaKR9A=";
  };

  cargoHash = "sha256-1OODXkqEPRE8GXMtNPPWS0PxHhGhQdcXIas8lB724ZI=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    oniguruma
  ];

  env = {
    RUSTONIG_SYSTEM_LIBONIG = true;
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Modern TUI merge tool and interactive diff editor for Jujutsu (jj) and Git";
    homepage = "https://github.com/emilien-jegou/oyui";
    changelog = "https://github.com/emilien-jegou/oyui/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.unfree; # FIXME: nix-init did not find a license
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "oyui";
  };
})
