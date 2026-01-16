{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-tree-tui";
  # TODO: wait for semver release
  version = "unstable-2026-01-12";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "cargo-tree-tui";
    rev = "5b3da7ba73bb9059e6ac21fb5f9595d46e77ee38";
    hash = "sha256-9au0L4zOfVyQwi5Ps+QTaZqhKZZBXRcAKjtGs+bOp5k=";
  };

  cargoHash = "sha256-V6BWZI5RuDgcSXaLtOnZ5Zz1BTTMd15PbkOKld4hQcw=";

  passthru.updateScript = nix-update-script { };

  meta = {
    # TODO: improve ddescription not clear what program does from it
    description = "Ratatuifying Rust's package manager";
    homepage = "https://github.com/orhun/cargo-tree-tui";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "cargo-tree-tui";
  };
})
