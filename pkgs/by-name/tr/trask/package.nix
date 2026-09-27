{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "trask";
  version = "0-unstable-2026-09-21";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "marcsantiago";
    repo = "trask";
    rev = "b544922352d9e6fa6c8b6d75f073c63e00ec36e1";
    hash = "sha256-R6IL0s9ZfMvsnDMgdw2GotPmB3P1s/vCHr0Z0SobX7g=";
  };

  cargoHash = "sha256-Lv94MjCg1LzsDPtH4kqMQsSqTWsT6JX50ixghItNDkw=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "";
    homepage = "https://github.com/marcsantiago/trask";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "trask";
  };
})
