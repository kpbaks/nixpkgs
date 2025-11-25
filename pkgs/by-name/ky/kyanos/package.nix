{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  installShellFiles,
  nix-update-script,
}:

# is mostly C
# stdenv.mkDerivation (finalAttrs: {})
buildGoModule rec {
  pname = "kyanos";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "hengyoush";
    repo = "kyanos";
    rev = "v${version}";
    hash = "sha256-E7Ws4mbBGuZFY/h4LjLFkCcXr9mud9MHfCEnR2EzYn8=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-a08zueErS1D0Xxo5MaHx07uxN5OuQYCglrPHerkXg3Q=";

  # https://github.com/hengyoush/kyanos/blob/main/COMPILATION.md

  ldflags = [
    "-s"
    "-w"
    "-X=kyanos/version.Version=${version}"
    "-X=kyanos/version.CommitID=${src.rev}"
    "-X=kyanos/version.BuildTime=1970-01-01T00:00:00Z"
    "-linkmode"
    "external"
    "-extldflags"
    "-static"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Kyanos is a networking analysis tool using eBPF. It can visualize the time packets spend in the kernel, capture requests/responses, makes troubleshooting more efficient";
    homepage = "https://kyanos.io/";
    downloadPage = "https://github.com/hengyoush/kyanos";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "kyanos";
    platforms = lib.platforms.linux; # Requires eBPF
  };
}
