{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "getplumber";
  version = "0.5.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "getplumber";
    repo = "plumber";
    tag = "v${finalAttrs.version}";
    hash = "sha256-d8wcW0gRrcDsg9Zo/U95I/IrxTjMhrzw+wu3ujjNASg=";
  };

  vendorHash = "sha256-O9ysHNp6L/bEj+78GUm6fqcTPxgF25H/9z9yufQyDFo=";

  ldflags = [
    "-s"
    "-X github.com/getplumber/plumber/cmd.Version=${finalAttrs.version}"
    "-X github.com/getplumber/plumber/cmd.Commit=${finalAttrs.src.rev}"
    # Datetime format set in the projects Dockerfile `BUILD_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")`
    "-X github.com/getplumber/plumber/cmd.BuildDate=1970-01-01T00:00:00Z"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd plumber \
      --bash <($out/bin/plumber completion bash) \
      --fish <($out/bin/plumber completion fish) \
      --zsh <($out/bin/plumber completion zsh)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Plumber detects CI/CD security issues in your GitHub workflows and gives you a score";
    homepage = "https://getplumber.io/docs/cli";
    downloadPage = "https://github.com/getplumber/plumber";
    changelog = "https://github.com/getplumber/plumber/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "plumber";
  };
})
