{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  # versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pruner";
  version = "1.0.0-alpha.10";

  src = fetchFromGitHub {
    owner = "pruner-formatter";
    repo = "pruner";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IXI6S2r7spaUTkdOzkL1BWMQ9gXWejpM5b5Fn3UY7s0=";
  };

  cargoHash = "sha256-vbA4M/DBmy5JZ5D2quixcVWaIm1MRHl2cYyKhzvkftI=";

  # TODO: get to work
  doCheck = false;

  checkFlags = [
    # Error: Failed to read directory "tests/fixtures/grammars"
    # No such file or directory (os error 2)
    # "--skip=conditional_formatters_test"
    "--skip=injections_only_pipeline_condition_test"
    "--skip=root_only_pipeline_condition_test"
    "--skip=offset_dependent_printwidth"
  ];

  # TODO: outputs "0.0.0-dev"
  # doInstallCheck = true;
  # nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    # TODO: change title
    description = "TreeSitter-powered formatter orchestrator";
    homepage = "https://pruner-formatter.github.io/";
    downloadPage = "https://github.com/pruner-formatter/pruner";
    changelog = "https://github.com/pruner-formatter/pruner/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "pruner";
  };
})
