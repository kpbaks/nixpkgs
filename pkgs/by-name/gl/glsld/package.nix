{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  vcpkg,
  catch2,
  # cxxopts,
  fmt,
  nix-update-script,
  pkg-config,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "glsld";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "daiyousei-qz";
    repo = "glsld";
    tag = finalAttrs.version;
    hash = "sha256-V4s+YT08xxSKmtZv6qG0Ace0ntF0fARiPbF9RyTx+FU=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    vcpkg
    pkg-config
  ];

  buildInputs = [
    fmt
    catch2
  ];

  # TODO: run test and use a static seed
  # ./cmake-build-release/glsld-test

  # FIXME: outputs 0.3.1
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A language server for OpenGL shading language";
    homepage = "https://github.com/daiyousei-qz/glsld";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "glsld";
    platforms = lib.platforms.all;
  };
})
