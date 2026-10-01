{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "opencode-copilot-credit-estimator";
  version = "0.4.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "springernature";
    repo = "opencode-copilot-credit-estimator";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mSu3ayoP4gkOPkfl6+u7fIOKuh4trOKsikfgBbjjwBA=";
  };

  build-system = [
    python3Packages.setuptools
  ];

  dependencies = with python3Packages; [
    textual
    textual-plotext
  ];

  #  FIXME: does not expose a script, we need to create a python env wrapper around estimator.py called `occe`

  # pythonImportsCheck = [
  #   "opencode_copilot_credit_estimator"
  # ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Estimate (quite accurately) the credits spent on GitHub Copilot in Opencode";
    homepage = "https://github.com/springernature/opencode-copilot-credit-estimator";
    changelog = "https://github.com/springernature/opencode-copilot-credit-estimator/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "occe";
  };
})
