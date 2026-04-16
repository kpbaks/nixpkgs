{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dockerfile-roast";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "immanuwell";
    repo = "dockerfile-roast";
    tag = finalAttrs.version;
    hash = "sha256-xSdbBQXacYYEWpn177/AyxZFVbFEbHtsZAJbOh0G1Pk=";
  };

  cargoHash = "sha256-Wjyta0RruWi/e5ZHV33Ge8Thytx2ap2bWbJbH5jbcNY=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd droast \
      --bash <($out/bin/droast completion bash) \
      --zsh <($out/bin/droast completion zsh) \
      --fish <($out/bin/droast completion fish)
  '';

  # FIXME: outputs "droast 0.1.0"
  doInstallCheck = false;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A dockerfile linter that actually has opinions";
    downloadPage = "https://github.com/immanuwell/dockerfile-roast";
    homepage = "https://ewry.net/droast-dockerfile-linter";
    changelog = "https://github.com/immanuwell/dockerfile-roast/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "droast";
  };
})
