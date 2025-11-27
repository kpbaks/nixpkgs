{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  installShellFiles,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "savvy";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "getsavvyinc";
    repo = "savvy-cli";
    tag = finalAttrs.version;
    hash = "sha256-MYi3no+bLcKaVDqO4OfEUXwNvcBl3HKr71q9IgkaoNU=";
  };

  vendorHash = "sha256-aFZnGulDgRejO6rL+45jJq1ZuxauGHL1kuT8157E3YY=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/getsavvyinc/savvy-cli/config.version=${finalAttrs.version}"
  ];

  # TODO: figure out what to do with $out/bin/cmd, which is the chrome browser extension
  postInstall = ''
    mv $out/bin/savvy-cli $out/bin/savvy
  ''
  + (lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd savvy \
      --bash <($out/bin/savvy completion bash) \
      --fish <($out/bin/savvy completion fish) \
      --zsh <($out/bin/savvy completion zsh)
  '');

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Automatically capture and surface your team's tribal knowledge";
    homepage = "https://github.com/getsavvyinc/savvy-cli";
    changelog = "https://github.com/getsavvyinc/savvy-cli/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "savvy";
  };
})
