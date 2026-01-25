{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  bzip2,
  openssl,
  xz,
  zstd,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jbundle";
  version = "unstable-2026-01-24";

  src = fetchFromGitHub {
    owner = "avelino";
    repo = "jbundle";
    rev = "f722ab543a57e7fc496656c72198c71efe52e89c";
    hash = "sha256-8yk31QCqny3Zw2ZRBo+Vap+gCp3Hv5uueDVnEdlnh6U=";
  };

  cargoHash = "sha256-nJXmjkJB8dYj5JRZMHYciki3fcoDEL3yq40oGdYkY7E=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    bzip2
    openssl
    xz
    zstd
  ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Package JVM applications (Clojure, Java) into self-contained binaries. No JVM installation required to run the output";
    homepage = "https://github.com/avelino/jbundle";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "jbundle";
  };
})
