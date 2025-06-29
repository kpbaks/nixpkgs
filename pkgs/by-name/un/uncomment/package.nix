{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uncomment";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "Goldziher";
    repo = "uncomment";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ApDlPf+rvv8WAcRzzRn0CUlThM+Hq5A7o9u+WWb2rzE=";
  };

  cargoHash = "sha256-8odUzsIluxC9L0BpqQmO9ekha0xgHXYW1Q7DwjBapHQ=";

  checkFlags = [
    # impure test dependent on the .gitignore file of the repos root folder.
    "--skip=test_gitignore_from_subdirectory"
    "--skip=test_gitignore_with_no_gitignore_flag"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command line tool for removing comments from code using tree-sitter grammars";
    homepage = "https://github.com/Goldziher/uncomment";
    license = [ lib.licenses.mit ];
    maintainers = [ lib.maintainers.kpbaks ];
    mainProgram = "uncomment";
    platforms = lib.platforms.all;
  };
})
