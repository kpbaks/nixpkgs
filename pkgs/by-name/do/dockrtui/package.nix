{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dockrtui";
  version = "unstable-2025-11-10";

  src = fetchFromGitHub {
    owner = "LuuNa-JD";
    repo = "dockrtui";
    rev = "7685b5e8341c5a3ff334f8b5742f5042db1e6b8b";
    hash = "sha256-P48F2QyyiD8XE12ezjTiozGsnn2Ero2LeDp87PSIYKs=";
  };

  cargoHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Keyboard-driven TUI to interact with Docker";
    homepage = "https://github.com/LuuNa-JD/dockrtui";
    license = lib.licenses.unfree; # FIXME: nix-init did not find a license
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "dockrtui";
  };
})
