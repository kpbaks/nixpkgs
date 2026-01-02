{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "just-mcp";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "PromptExecution";
    repo = "just-mcp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OX4UrwXcMwSx1UKQSbh0pwZgnJ7n5HBsOioz7uoE8Kk=";
  };

  cargoHash = "sha256-Jl+AvjrfOuYMOHt5GYE6s+PVzKsegL59a1S5rqHXvO0=";

  # FIXME: outputs 0.1.1 anot 0.1.5
  # It is some real AI slop it seems ...
  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Mcp server for just";
    homepage = "https://github.com/PromptExecution/just-mcp";
    changelog = "https://github.com/PromptExecution/just-mcp/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "just-mcp";
  };
})
