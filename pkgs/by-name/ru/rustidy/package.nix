{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

# FIXME: depends on nightly rustc
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rustidy";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "zenithsiz";
    repo = "rustidy";
    tag = finalAttrs.version;
    hash = "sha256-pXsV7riO17h9MOlfsOJB8LsxEsfD9dgFGDZ6XEgC2To=";
  };

  cargoHash = "sha256-OPL3UusDbaKdOQAWIV6Ao5y7DpPrDQMyPn6myNVlpYw=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Rust source code formatter";
    homepage = "https://github.com/zenithsiz/rustidy";
    changelog = "https://github.com/Zenithsiz/rustidy/releases/tag/${finalAttrs.version}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "rustidy";
  };
})
