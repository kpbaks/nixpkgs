{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "httpjail";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "coder";
    repo = "httpjail";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rjNrtYu9nGSWKgYPBuMzagjb2ViOw+JnQTtnjukXg9M=";
  };

  # TODO: figure out how to build with v8 dependency
  cargoHash = "sha256-05TSrbZPEZSBFqbKRsyuA44FcTPRRV83uBMbZVI4Obg=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "HTTP(s) request filter for processes";
    homepage = "https://github.com/coder/httpjail";
    changelog = "https://github.com/coder/httpjail/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.cc0;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "httpjail";
  };
})
