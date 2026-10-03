{
  lib,
  stdenv,
  nodejs,
  pnpmConfigHook,
  pnpm,
  fetchPnpmDeps,
  fetchFromGitHub,
  pnpmBuildHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "automd";
  version = "0.4.3";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "unjs";
    repo = "automd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-C8ZmxeN04jb2QbFMlLQAgZ7kFfHyczJxONA+XtvRBgU=";
  };

  nativeBuildInputs = [
    nodejs # in case scripts are run outside of a pnpm call
    pnpmConfigHook
    pnpmBuildHook
    pnpm # At least required by pnpmConfigHook and pnpmBuildHook, if not other (custom) phases
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "";
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Automated markdown maintainer";
    homepage = "https://github.com/unjs/automd";
    downloadPage = "https://github.com/unjs/automd";
    changelog = "https://github.com/unjs/automd/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "automd";
    platforms = lib.platforms.all;
  };
})
