{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "envdiff";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "GBerghoff";
    repo = "envdiff";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZUUxXtiFyQDePME2PK141x2YwjhqZmt3rbqa6snRhiw=";
  };

  vendorHash = "sha256-ol4pqPD/ZrU/PGqvebJa9zS7riptyrCh4x5r7grKgIg=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cli tool to snapshot and diff environments - helping find the differences that matter";
    homepage = "https://github.com/GBerghoff/envdiff";
    license = lib.licenses.unfree; # FIXME: nix-init did not find a license
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "envdiff";
  };
})
