{
  bash,
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  oniguruma,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "upmd";
  version = "0.2.7";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "rezigned";
    repo = "upmd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NoxrbqhxVhV4HieqpzU5UpsLkisVKGc+yOSlxE7ywXk=";
  };

  cargoHash = "sha256-diB32BJx9N5cVmDn48X5aW9KwznMdE/Bc/cEMOHjac0=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    oniguruma
  ];
  # FIXME: tries to access /bin/bash in tests

  nativeCheckInputs = [
    bash
  ];

  env = {
    RUSTONIG_SYSTEM_LIBONIG = true;
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Upmd - Run tasks and workflows from Markdown";
    homepage = "https://upmd.dev/";
    downloadPage = "https://github.com/rezigned/upmd";
    changelog = "https://github.com/rezigned/upmd/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "upmd";
  };
})
