{
  lib,
  rustPlatform,
  git,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ifttt-lint";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "simonepri";
    repo = "ifttt-lint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6diL52TPUq5cEG8wCIKKw6C/AmcCfLorfUp3ElYsNo4=";
  };

  cargoHash = "sha256-qAdWikq6+4Yq3dd8eBPC2+yAEUdj0zz3n27Uzjjfmag=";

  checkInputs = [ git ];

  doCheck = false;

  checkFlags = [
    "--skip=diff_with_explicit_range_reports_added_lines"
    "--skip=empty_when_no_match"
    "--skip=finds_matching"
    "--skip=tag_absent"
    "--skip=tag_present"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "IfThisThenThat linter — enforce atomic cross-file changes via LINT.IfChange / LINT.ThenChange directives";
    homepage = "https://github.com/simonepri/ifttt-lint";
    changelog = "https://github.com/simonepri/ifttt-lint/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "ifttt-lint";
  };
})
