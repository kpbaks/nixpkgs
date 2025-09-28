{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "poutine";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "boostsecurityio";
    repo = "poutine";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uvWovwfVH3x/Cr0fjbORWyARYL916Uw/550DuwNH5xo=";
  };

  vendorHash = "sha256-KOGOHqEFa2Ttgs2cyhdCVop94FSw85xxNQsDBV5kKNE=";

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd ${finalAttrs.meta.mainProgram} \
      --bash <($out/bin/${finalAttrs.meta.mainProgram} completion bash) \
      --fish <($out/bin/${finalAttrs.meta.mainProgram} completion fish) \
      --zsh <($out/bin/${finalAttrs.meta.mainProgram} completion zsh)
  '';

  # doInstallCheck = true;
  # nativeInstallCheckInputs = [ versionCheckHook ];
  # versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Security scanner that detects misconfigurations and vulnerabilities in build pipelines of repositories";
    homepage = "https://github.com/boostsecurityio/poutine";
    changelog = "https://github.com/boostsecurityio/poutine/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "poutine";
    broken = stdenv.hostPlatform.isDarwin;
  };
})
