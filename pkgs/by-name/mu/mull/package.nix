{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mull";
  version = "0.39.5";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "stepchowfun";
    repo = "mull";
    tag = "v${finalAttrs.version}";
    hash = "";
  };

  cargoHash = "";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Organize your knowledge";
    homepage = "https://github.com/stepchowfun/mull";
    changelog = "https://github.com/stepchowfun/mull/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "mull";
  };
})
