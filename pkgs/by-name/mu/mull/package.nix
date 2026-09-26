{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mull";
  version = "0.28.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "stepchowfun";
    repo = "mull";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BFjmM4tlzAfN/Zj17eak1C2l4KaTzCjZj4drB9/lneg=";
  };

  cargoHash = "sha256-QLMrKQB4EA88c9GEctP1nJuCpKrP4kuXjbDL7hxD60Y=";

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
