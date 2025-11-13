{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "s3grep";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "dacort";
    repo = "s3grep";
    rev = "v${finalAttrs.version}";
    hash = "sha256-bp69QxMd93G9oRz/ywPJsxVvSt9LMSu5vxuUx1vwiyA=";
  };

  cargoHash = "sha256-EoS/cmfmRX55DDqGIyZIymYSO2NNQwxY9+DVeGOw1Os=";

  checkFlags = [
    # Tries to access system TLS ca-certificate store
    "--skip=integration_s3::test_list_buckets_localstack"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  # TODO: test with a local instance of some s3 storage like garage

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI tool for searching logs and unstructured content in Amazon S3 buckets";
    homepage = "https://github.com/dacort/s3grep";
    changelog = "https://github.com/dacort/s3grep/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "s3grep";
  };
})
