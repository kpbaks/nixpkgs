{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  sqlite,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "otot";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "idiomattic";
    repo = "otot";
    rev = "v${finalAttrs.version}";
    hash = "sha256-CX7zoW80PRC6zIC8nVGqrbCfvv1cMhoD1yiQlv4lKMs=";
  };

  cargoHash = "sha256-glU/pruWlPtgA50CNrCkkhPd5bbakwXvg2cRWiwXM80=";

  buildInputs = [ sqlite ];

  checkFlags = [
    # reason for disabling test TODO:
    "--skip=tests::app_builder_uses_defaults_when_not_specified"
    "--skip=empty_address"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fuzzy URL opener for the terminal";
    homepage = "https://github.com/idiomattic/otot";
    changelog = "https://github.com/idiomattic/otot/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.unfree; # FIXME: nix-init did not find a license
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "otot";
  };
})
