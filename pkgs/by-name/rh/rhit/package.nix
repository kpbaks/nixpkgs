{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libgit2,
  sqlite,
  zlib,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rhit";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "canop";
    repo = "rhit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UBcTHBRlCz0T2+3js9QxIkkdNMw11TI9ZxbMQ80//tg=";
  };

  cargoHash = "sha256-eTTzZupcFNFMyFlBci8s/xU/kEXaOUezkURRRcjeWVA=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libgit2
    sqlite
    zlib
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  # TODO: find an example /var/log/nginx file to test against

  meta = {
    description = "nginx log explorer";
    homepage = "https://dystroy.org/rhit/";
    downloadPage = "https://github.com/canop/rhit";
    changelog = "https://github.com/Canop/rhit/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "rhit";
  };
})
