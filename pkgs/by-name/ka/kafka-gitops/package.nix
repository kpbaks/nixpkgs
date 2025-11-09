{
  lib,
  stdenv,
  fetchFromGitHub,
  gradle,
  makeWrapper,
  nix-update-script,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kafka-gitops";
  version = "0.2.15";

  src = fetchFromGitHub {
    owner = "devshawn";
    repo = "kafka-gitops";
    tag = finalAttrs.version;
    hash = "sha256-EmSPrenhAZeEQqTqB8vvKfY1FUs6WC6QZZhejoLk3FA=";
  };

  nativeBuildInputs = [
    gradle
    makeWrapper
  ];

  # if the package has dependencies, mitmCache must be set
  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  # this is required for using mitm-cache on Darwin
  __darwinAllowLocalNetworking = true;

  gradleFlags = [ "-Dfile.encoding=utf-8" ];

  # defaults to "assemble"
  gradleBuildTask = "shadowJar";

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Manage Apache Kafka topics and generate ACLs through a desired state file";
    homepage = "https://github.com/devshawn/kafka-gitops";
    changelog = "https://github.com/devshawn/kafka-gitops/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "kafka-gitops";
    platforms = lib.platforms.all;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # mitm cache
    ];
  };
})
