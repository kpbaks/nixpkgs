{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "circleci-yaml-language-server";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "CircleCI-Public";
    repo = "circleci-yaml-language-server";
    tag = finalAttrs.version;
    hash = "sha256-6lR+/iQpqN41OZBoBNGiwDIJyXzDKi7Ade1InJvfQCc=";
  };

  vendorHash = "sha256-tw83xt651fs1m63r58oFOv1JsMmQIpmVgasbgAN1hio=";

  ldflags = [
    "-s"
    "-w"
    "-X 'github.com/CircleCI-Public/circleci-yaml-language-server/pkg/utils.ServerVersion=${finalAttrs.version}'"
  ];

  subPackages = [
    "cmd/start_server"
  ];

  nativeBuildInputs = [
    makeWrapper
  ];

  postInstall = ''
    install -Dm444 schema.json $out/share/schema.json
    install -Dm755 $out/bin/start_server $out/bin/circleci-yaml-language-server

    # NOTE: workaround until https://github.com/CircleCI-Public/circleci-yaml-language-server/issues/353 is fixed.
    wrapProgram $out/bin/circleci-yaml-language-server \
      --add-flags "-schema $out/share/schema.json"
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "-version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Official language server for CircleCI YAML configuration files";
    homepage = "https://github.com/CircleCI-Public/circleci-yaml-language-server";
    changelog = "https://github.com/CircleCI-Public/circleci-yaml-language-server/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "circleci-yaml-language-server";
  };
})
