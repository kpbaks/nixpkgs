{
  lib,
  stdenv,
  wasmer,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,

}:
stdenv.mkDerivation (finalAttrs: {
  pname = "onyx";
  version = "0.1.13";

  src = fetchFromGitHub {
    owner = "onyx-lang";
    repo = "onyx";
    # rev = "0739f714db25f658111eb1dfe30e766705ae52b4";
    tag = "v${finalAttrs.version}-beta";
    hash = "sha256-RGy/LBXVm5ybI8P0nOrXS8Hiw57j8ZOklxyQJiBzuTk=";
  };

  nativeBuildInputs = [

  ];

  buildInputs = [ ];

  # https://github.com/onyx-lang/onyx/blob/master/compiler/build.sh
  # TODO: handle darwin arch
  # case "$ONYX_ARCH" in
  #     *darwin*)
  #         LIBS="$LIBS -lffi -framework CoreFoundation -framework SystemConfiguration"
  #         LIBRARY_BUILD_ARGS="-install_name @rpath/libonyx.dylib"
  #         AUTOCOMPILER_BUILD_ARGS="-rpath @loader_path/"
  #         ;;

  #     *linux*)
  #         LIBRARY_BUILD_ARGS=""
  #         AUTOCOMPILER_BUILD_ARGS="-Wl,-rpath,\$ORIGIN"
  #         ;;
  # esac

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Onyx is a general purpose, efficient, procedural and pragmatic programming language for application development.";
    homepage = "https://onyxlang.io/";
    changelog = "https://github.com/onyx-lang/onyx/blob/v${finalAttrs.version}-beta/CHANGELOG";
    downloadPage = "https://github.com/onyx-lang/onyx/releases/tag/v${finalAttrs.version}-beta";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "onyx";
  };
})
