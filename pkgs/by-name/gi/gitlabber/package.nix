{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
  fetchPypi,
  versionCheckHook,
}:

let
  globre = python3Packages.buildPythonPackage rec {
    pname = "globre";
    version = "0.1.5";

    format = "setuptools";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-7iFCBPI36RFLj2HuthwqvR5mXKO1nlpqCwcJccC7EuI=";
    };

    nativeBuildInputs = [
      python3Packages.setuptools
    ];

    pythonImportsCheck = [ "globre" ];

    meta = {
      description = "Glob-style regex matching for Python";
      license = lib.licenses.mit;
    };
  };
in

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "gitlabber";
  version = "2.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ezbz";
    repo = "gitlabber";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2dPAFTackTPOl5qUlUgY2j31DoGNyK0QMoQZZD33dF0=";
  };

  build-system = [
    python3Packages.setuptools
    python3Packages.wheel
  ];

  dependencies =
    with python3Packages;
    [
      anytree
      gitpython
      pydantic
      pydantic-settings
      python-gitlab
      pyyaml
      rich
      typer
    ]
    ++ [ globre ];

  optional-dependencies = with python3Packages; {
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

  pythonRelaxDeps = [
    # Will error with "gitpython>=3.1.59 not satisfied by version 3.1.58" otherwise
    "gitpython"
  ];

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
