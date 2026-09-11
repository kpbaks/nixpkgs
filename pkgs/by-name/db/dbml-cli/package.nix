{
  lib,
  stdenv,
  jq,
  # buildNpmPackage,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  yarnInstallHook,
  nodejs,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dbml-cli";
  version = "10.1.1";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "holistics";
    repo = "dbml";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NN27mXWKx/DgJI/cHDjAXC+x1cXrpqxERtTDfdFF4/Q=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-Lk2eUTdgefavCdSQOHF4lQXAVtxrrSfR/GdWU4UMMgM=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    yarnInstallHook
    # Needed for executing package.json scripts
    nodejs
  ];

  # Change `["packages/*", "dbml-playground"]` to `["packages/*"]`
  postPatch = ''
    ${jq}/bin/jq '.workspaces |= ["packages/*"] | .version = "${finalAttrs.version}"' < package.json > temp.json
    cp temp.json package.json
    cat package.json
    rm temp.json
  '';

  # yarnBuildFlags = [ ];

  # TODO: skip building @dbml/playground only @dbml/cli

  # todo: package https://github.com/holistics/dbml/tree/master/packages/dbml-cli/bin to $out/bin
  # probably using makeWrapper

  # dontYarnInstall = true;
  #
  # FIXME: `nix-build -A dmbl-cli` now succeeds, but nothing in $out/bin
  # packages/dbml-cli/package.json does define ".bin"

  # nativeInstallCheckInputs = [ versionCheckHook ];
  # doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI to work with Database Markup Language (DBML)";
    homepage = "https://dbml.dbdiagram.io/cli/";
    downloadPage = "https://github.com/holistics/dbml";
    changelog = "https://github.com/holistics/dbml/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "dbml2sql";
    platforms = lib.platforms.all;
  };
})
