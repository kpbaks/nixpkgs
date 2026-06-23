{
  lib,
  stdenv,
  fetchFromGitHub,
  callPackage,
  zig,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ghostty-ls";
  version = "0.1.0";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "MKindberg";
    repo = "ghostty-ls";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JymBd6RKqBc7mT8Tf+aSpmM0XljyLNXzgRVf7GXqA9c=";
  };

  deps = callPackage ./deps.nix { };

  nativeBuildInputs = [
    zig
  ];

  dontSetZigDefaultFlags = true;
  zigBuildFlags = [
    "--system"
    "${finalAttrs.deps}"
    "-Dcpu=baseline"
    "-Doptimize=ReleaseFast"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Lanugage server for working with the ghostty config";
    homepage = "https://github.com/MKindberg/ghostty-ls";
    changelog = "https://github.com/MKindberg/ghostty-ls/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "ghostty-ls";
    inherit (zig.meta) platforms;
  };
})
