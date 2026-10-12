{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "vignore";
  version = "1.0.5";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "james4ever0";
    repo = "vignore";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ccjYR2QuviuCS1xhWTx0U7h6XrGfZwtDpkp6IMsshH0=";
  };

  build-system = [
    python3Packages.setuptools
  ];

  dependencies = with python3Packages; [
    numpy
    rich
    textual
    jinja2
    beartype
    # asyncio
    humanize
  ];

  pythonImportsCheck = [
    "vignore"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Visualize ignore files like .gitignore, .dockerignore, .fdignore etc.";
    homepage = "https://github.com/james4ever0/vignore";
    changelog = "https://github.com/james4ever0/vignore/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "vignore";
  };
})
