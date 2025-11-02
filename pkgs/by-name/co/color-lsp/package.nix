{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "color-lsp";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "huacnlee";
    repo = "color-lsp";
    rev = "zed-v${finalAttrs.version}";
    hash = "sha256-wMI+0xPICEfS7owgDAROBLgVKvnX7UX4jlOpioXJVYQ=";
  };

  cargoHash = "sha256-a+hkefgYbRppZ8wp3rOqBpzzZSjFl4qpHJFAPWXNI04=";

  # FIXME: outputs "v0.2.0" for version 0.2.1 ... 😡
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Language server to provide color annotations for color literals like '#ff0000'";
    homepage = "https://github.com/huacnlee/color-lsp";
    changelog = "https://github.com/huacnlee/color-lsp/releases/tag/zed-v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "color-lsp";
  };
})
