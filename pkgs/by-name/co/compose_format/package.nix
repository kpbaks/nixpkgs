{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
}:

python3Packages.buildPythonApplication rec {
  pname = "compose_format";
  version = "1.2.0";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "funkwerk";
    repo = "compose_format";
    tag = version;
    hash = "sha256-Z30abGFaZqulICOk0V+25ssk8NGZpEVySYVZsL2g93I=";
  };

  build-system = [
    python3Packages.setuptools
    python3Packages.wheel
  ];

  # add ruamel-yaml

  # pythonImportsCheck = [
  #   "compose_format"
  # ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Format docker compose files using recipes from best practices";
    homepage = "https://github.com/funkwerk/compose_format";
    changelog = "https://github.com/funkwerk/compose_format/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "compose_format";
  };
}
