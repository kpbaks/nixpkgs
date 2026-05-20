{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nginx-lint";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "walf443";
    repo = "nginx-lint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bT4z6PZvAMVvDbXe1HUrycFWe+1Ia4NZsfNO+Bu8RRo=";
  };

  cargoHash = "sha256-Pibsgmp7x8f53ORcaYxiprRt3Kbv57t4EbOHFBbkhZs=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Linter for nginx configuration files with WASM plugin support";
    homepage = "https://walf443.github.io/nginx-lint/";
    downloadPage = "https://github.com/walf443/nginx-lint";
    changelog = "https://github.com/walf443/nginx-lint/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "nginx-lint";
  };
})
