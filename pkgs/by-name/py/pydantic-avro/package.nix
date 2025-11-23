{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
}:

python3Packages.buildPythonApplication rec {
  pname = "pydantic-avro";
  version = "0.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "godatadriven";
    repo = "pydantic-avro";
    rev = "v${version}";
    hash = "sha256-PKOE/eUUeCLpM3wTew9Eljt7kiXqCnlchr4xoyU2mWU=";
  };

  build-system = [
    python3Packages.poetry-core
  ];

  dependencies = with python3Packages; [
    pydantic
  ];

  pythonImportsCheck = [
    "pydantic_avro"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Convert a pydantic class to a avro schema or generate python code from a avro schema";
    homepage = "https://github.com/godatadriven/pydantic-avro";
    changelog = "https://github.com/godatadriven/pydantic-avro/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "pydantic-avro";
  };
}
