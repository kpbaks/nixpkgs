{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  sqlite,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nuze";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "ZettaScaleLabs";
    repo = "nuze";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8kW2jRkYSRDxf2f7QC8Q6luLr+8G6CxWiajYsxe73X8=";
  };

  cargoHash = "sha256-a0nTuzk9fruN2USs8ogaPw+/NSlaq4gMR2sa1qxWlZY=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    # TODO: can we remove this?
    sqlite
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Nu-Zenoh integration";
    longDescription = ''
      Zenoh Interactive Shell is a standalone command-line interpreter that
      extends Nushell with the Zenoh plugin.
    '';
    homepage = "https://github.com/ZettaScaleLabs/nuze";
    license = [ lib.licenses.asl20 ];
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "nuze";
  };
})
