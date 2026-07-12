{
  lib,
  stdenv,
  fetchFromGitHub,
  cargo,
  meson,
  ninja,
  pkg-config,
  rustPlatform,
  rustc,
  libxkbcommon,
  vulkan-loader,
  wayland,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "espanso-gui";
  version = "24.7";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "unobserved-io";
    repo = "espanso-gui";
    tag = finalAttrs.version;
    hash = "sha256-igp1b0ZW/QBzStbo1jM3pSRVfbh8Yw65GK0siynwIrQ=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-mOJfdfecauHC12H6JwFUzc4okJjtitjzLCEhgBJJw0M=";
  };

  nativeBuildInputs = [
    cargo
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    rustc
  ];

  buildInputs = [
    libxkbcommon
    vulkan-loader
  ]
  ++ lib.optionals stdenv.isLinux [
    wayland
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "GUI frontend for espanso";
    homepage = "https://github.com/unobserved-io/espanso-gui";
    changelog = "https://github.com/unobserved-io/espanso-gui/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "espanso-gui";
    platforms = lib.platforms.all;
  };
})
