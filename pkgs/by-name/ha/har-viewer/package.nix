{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gradle,
  makeWrapper,
  openjdk,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "har-viewer";
  version = "1.2.0";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "nassendelft";
    repo = "har-viewer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xG8lnixEPbpV8nu85K2sATVA54REzTgBKNBLfL/Tl7Q=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    gradle
    makeWrapper
  ];

    gradleFlags = [ "-Dfile.encoding=utf-8" ];

  # defaults to "assemble"
  gradleBuildTask = "shadowJar";

  #   git clone --recurse-submodules https://github.com/nassendelft/har-viewer.git
  # cd har-viewer
  # ./gradlew :app:linkReleaseExecutableMacosArm64   # macOS Apple Silicon
  # ./gradlew :app:linkReleaseExecutableLinuxX64      # Linux x86-64
  # The binary is written to app/build/bin/<target>/releaseExecutable/app.kexe.

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal UI for inspecting HAR (HTTP Archive) files";
    homepage = "https://github.com/nassendelft/har-viewer";
    changelog = "https://github.com/nassendelft/har-viewer/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "har-view";
    platforms = lib.platforms.all;
  };
})
