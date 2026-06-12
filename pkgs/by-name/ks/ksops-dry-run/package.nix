{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "ksops-dry-run";
  version = "0.2.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "joshdk";
    repo = "ksops-dry-run";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JcsBquVfHh0q+1M/57IftDWUWafiFKOc8pxVp20MJZQ=";
  };

  vendorHash = "sha256-g+yaVIx4jxpAQ/+WrGKxhVeliYx7nLQe/zsGpxV4Fn4=";

  ldflags = [
    "-s"
    "-X=main.version=${finalAttrs.src.rev}"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Kustomize plugin to fake the decryption of ksops secrets";
    homepage = "https://github.com/joshdk/ksops-dry-run";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "ksops-dry-run";
  };
})
