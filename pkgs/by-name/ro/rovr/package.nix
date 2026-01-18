{
  lib,
  python3,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "rovr";
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "NSPC911";
    repo = "rovr";
    tag = "v${version}";
    hash = "sha256-9wnDeu1wEvbThJMwIC0RooJ/p8oIqRGC3MLowmCm4tE=";
  };

  build-system = [
    python3.pkgs.uv-build
  ];

  # FIXME: handle these constraint violations when running `nix-build -A rovr` Sun Jan 18 01:52:32 AM CET 2026
  # - humanize>=4.14.0 not satisfied by version 4.12.3
  # - rich-click>=1.9.3 not satisfied by version 1.8.9
  # - textual~=6.6.0 not satisfied by version 7.2.0
  # - tomli>=2.3.0 not satisfied by version 2.2.1
  # - ujson>=5.11.0 not satisfied by version 5.10.0
  dependencies = with python3.pkgs; [
    humanize
    jsonschema
    natsort
    pathvalidate
    pdf2image
    pillow
    platformdirs
    psutil
    rarfile
    rich-click
    send2trash
    textual
    textual-autocomplete
    textual-image
    tomli
    ujson
  ];

  pythonImportsCheck = [
    "rovr"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = false;
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A post-modern terminal file manager";
    homepage = "https://github.com/NSPC911/rovr?ref=terminaltrove";
    changelog = "https://github.com/NSPC911/rovr/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "rovr";
  };
}
