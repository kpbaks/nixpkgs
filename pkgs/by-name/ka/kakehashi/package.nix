{
  lib,
  rustPlatform,
  fetchFromGitHub,
  git,
  tree-sitter,
  stdenv,
  nix-update-script,
  versionCheckHook,
  makeWrapper,
  pkg-config,
  openssl,
  apple-sdk,
  libiconv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kakehashi";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "atusy";
    repo = "kakehashi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HVc94jpIgyJuEa6zjf2MhNPIHpRkSaoFdZhNdkFWHC0=";
  };

  cargoHash = "sha256-P7ypeDLV7DUQuij2jFM6tY7vI0XD7ZAFS3F5ZnB/xxg=";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    apple-sdk
    libiconv
  ];

  # Skip tests that require network access or debug-only assertions
  checkFlags = [
    "--skip=test_clone_repo"
    "--skip=test_edit_info_new_rejects_invalid_in_debug"
    "--skip=test_dynamic_lua_load"
    "--skip=test_try_install_returns_already_installing_on_duplicate"
    "--skip=test_language_list_command" # Tries to do HTTP request
  ];

  postInstall = ''
    # These are runtime dependencies
    wrapProgram $out/bin/${finalAttrs.meta.mainProgram} \
      --prefix PATH : '${
        lib.makeBinPath [
          git
          tree-sitter
          stdenv.cc
        ]
      }'
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Language server that bridges the gap between languages, editors, and tooling";
    homepage = "https://github.com/atusy/kakehashi";
    changelog = "https://github.com/atusy/kakehashi/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "kakehashi";
  };
})
