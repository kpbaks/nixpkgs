{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  zstd,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fuzzy-ruby-server";
  version = "0-unstable-2025-04-25";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "doompling";
    repo = "fuzzy_ruby_server";
    rev = "9a439496ae0666b1cee0213031a6dcc3e74662cd";
    hash = "sha256-rhscav/7MFuoJQcC30EAqzxayG1fTO9AKkpDvKBbY/s=";
  };

  cargoHash = "sha256-+gVEPyGZB8mOCjXQD6WaFFOKNBKVSxlpwvxQNP5iLbs=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    zstd
  ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A Ruby language server for large codebases";
    homepage = "https://github.com/doompling/fuzzy_ruby_server";
    license = lib.licenses.mit; # Set in package.json
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "fuzzy-ruby-server";
  };
})
