{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "pint";
  version = "0.74.8";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "pint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6KQZztqWwOhXgnVSjABhO3f0YrgZBgkAxr+SBaL5COI=";
  };

  vendorHash = "sha256-v2qN9vyOV8pm3Y2Zmjp4oFSNLG07S3IW0w57ggqPsIk=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
    "-X=main.commit=${finalAttrs.src.rev}"
  ];

  # TODO: limit or disable
  doCheck = false;

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Prometheus rule linter/validator";
    homepage = "https://github.com/cloudflare/pint";
    changelog = "https://github.com/cloudflare/pint/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "pint";
  };
})
