{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "todo-tree";
  # TODO: cannot upstream before it gets a semver version release
  version = "unstable-2025-12-06";

  src = fetchFromGitHub {
    owner = "alexandretrotel";
    repo = "todo-tree";
    rev = "55832a5c14596e24e6314830dd4be123dbe960cb";
    hash = "sha256-22sHyDX9+E/fUViHdOo+/2YcrPexzqc7ZIgj1RYn1oU=";
  };

  cargoHash = "sha256-ZmWBU7fkk2fPMU+yASxhYMERS9zWnpw2SjGVavHB3+Y=";

  nativeBuildInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command-line tool to find and display TODO-style comments in your codebase";
    homepage = "https://github.com/alexandretrotel/todo-tree";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "todo-tree";
    # mainProgram = "tt";
  };
})
