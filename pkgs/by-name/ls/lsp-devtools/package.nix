{
  lib,
  stdenv,
  fetchPypi,
  python3Packages,
  nix-update-script,
  versionCheckHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "lsp-devtools";
  version = "0.2.4";

  pyproject = true;

  # TODO: use fetchPyPi
  # src = fetchFromGitHub {
  #   owner = "swyddfa";
  #   repo = "lsp-devtools";
  #   rev = "pytest-lsp-v${version}";
  #   hash = "sha256-/xusBu2Kg1V4tGep284YDrLr5klDeLeN1ub+emBSRP4=";
  # };

  src = fetchPypi {
    inherit pname version;
    hash = lib.fakeHash;
  };

  build-system = with python3Packages; [
    hatchling
  ];

  dependencies = with python3Packages; [
    pygls
    textual
  ];

  # nativeInstallCheckInputs = [ versionCheckHook ];
  # versionCheckProgramArg = "--version";
  # doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tooling for working with language servers and clients";
    homepage = "https://github.com/swyddfa/lsp-devtools/tree/develop/lib/lsp-devtools";
    downloadPage = "https://pypi.org/project/lsp-devtools/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "lsp-devtools";
    platforms = lib.platforms.all;
  };
}
