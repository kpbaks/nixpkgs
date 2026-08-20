{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "y509";
  version = "1.0.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "kanywst";
    repo = "y509";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DFoIO5WIBm01eYZPFHs8aBrH7WeS/wTc4YyA5qtIeTs=";
  };

  vendorHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";

  ldflags = [
    "-s"
    "-X=github.com/kanywst/y509/internal/version.Version=${finalAttrs.version}"
    "-X=github.com/kanywst/y509/internal/version.GitCommit=${finalAttrs.src.rev}"
    "-X=github.com/kanywst/y509/internal/version.BuildDate=1970-01-01T00:00:00Z"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal user interface tool for viewing and analyzing X.509 certificate chains";
    downloadPage = "https://github.com/kanywst/y509";
    homepage = "https://kanywst.github.io/y509/";
    changelog = "https://github.com/kanywst/y509/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "y509";
  };
})
