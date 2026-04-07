{
  lib,
  python3,
  fetchFromGitHub,
  nix-update-script,
  fetchPypi,
  versionCheckHook,
}:

let
  globre = python3.pkgs.buildPythonPackage rec {
    pname = "globre";
    version = "0.1.5";

    format = "setuptools";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-7iFCBPI36RFLj2HuthwqvR5mXKO1nlpqCwcJccC7EuI=";
    };

    nativeBuildInputs = [
      python3.pkgs.setuptools
    ];

    pythonImportsCheck = [ "globre" ];

    meta = {
      description = "Glob-style regex matching for Python";
      license = lib.licenses.mit;
    };
  };
in

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "gitlabber";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ezbz";
    repo = "gitlabber";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yfhAyrhDpm4oC6Pgv9G7jNJMW7/ZqtG30utonwojZBo=";
  };

  build-system = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  dependencies =
    with python3.pkgs;
    [
      anytree
      gitpython
      # globre
      pydantic
      pydantic-settings
      python-gitlab
      pyyaml
      rich
      typer
    ]
    ++ [ globre ];

  optional-dependencies = with python3.pkgs; {
    keyring = [
      keyring
    ];
    test = [
      coverage
      pytest
      pytest-cov
      pytest-integration
    ];
  };

  pythonImportsCheck = [
    "gitlabber"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Gitlabber - clones or pulls entire groups tree from gitlab";
    homepage = "https://github.com/ezbz/gitlabber";
    changelog = "https://github.com/ezbz/gitlabber/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "gitlabber";
  };
})
