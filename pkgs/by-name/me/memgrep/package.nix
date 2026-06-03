{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  hyperscan,
  nix-update-script,
}:

# FIXME: requires nightly
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "memgrep";
  version = "1.2.3";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "eras";
    repo = "memgrep";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Myv7KQXHqGHn/WRp90FK8wlh3vWjddGVWtFEVVUuuF8=";
  };

  cargoHash = "sha256-yA3J1IM0fqQ9JNyj+FHSiaxiQyPOAk+KduVtj1cudNM=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    hyperscan
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool for grepping the memory of processes";
    homepage = "https://github.com/eras/memgrep";
    changelog = "https://github.com/eras/memgrep/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "memgrep";
  };
})
