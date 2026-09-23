{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "gotz";
  version = "0.1.15";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "merschformann";
    repo = "gotz";
    tag = "v${finalAttrs.version}";
    hash = "sha256-U/JJBb5Z64sv7LR2ugeFOidNSOUblzWp1xzrTiG7mQc=";
  };

  vendorHash = "sha256-wiGjlkE/1oCwhb8JRS9FZSjOlyJWThcdg1jSBsUoDo8=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
    "-X=main.commit=${finalAttrs.src.rev}"
    "-X=main.date=1970-01-01T00:00:00Z"
  ];

  # FIXME: when running `gotz -version` it tries to create ~/.config/gotz before printing the version
  # which fails due to fs sandbox
  doInstallCheck = false;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI timezone info";
    homepage = "https://github.com/merschformann/gotz";
    changelog = "https://github.com/merschformann/gotz/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "gotz";
  };
})
