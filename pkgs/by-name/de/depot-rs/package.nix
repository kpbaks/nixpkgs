{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "depot-rs";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "quietpigeon";
    repo = "depot-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7FgmMxMzzFlKZ/9hawkCXAr5J9cbDlzFUEayGT2MlIM=";
  };

  cargoHash = "sha256-l4FwCnTrPrRneMoMnvggBOhGaHZvlYRE6Ivf88DxdwA=";

  # doInstallCheck = true;
  # nativeInstallCheckInputs = [ versionCheckHook ];
  # versionCheckProgramArg = "-h";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "TUI for managing Rust cargo crates";
    homepage = "https://github.com/quietpigeon/depot-rs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "depot";
  };
})
