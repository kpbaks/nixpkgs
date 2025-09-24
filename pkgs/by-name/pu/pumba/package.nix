{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "pumba";
  version = "0.11.6";

  src = fetchFromGitHub {
    owner = "alexei-led";
    repo = "pumba";
    tag = finalAttrs.version;
    hash = "sha256-3HmEiCqb9++QzGnFxtKPJCb6VEKcLrl5Ff5WMzcLQCs=";
  };

  vendorHash = "sha256-RHiiB3Uer8UvkO7zAa6mSUWs8gfUzUW8SDM3uR2wqaM=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
    "-X main.commit=${finalAttrs.src.tag}"
    "-X main.branch=master"
    "-X main.buildTime=1970-01-01T00:00:00Z"
  ];

  postInstall = ''
    mv $out/bin/cmd $out/bin/pumba
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Chaos testing, network emulation, and stress testing tool for containers";
    homepage = "https://github.com/alexei-led/pumba";
    changelog = "https://github.com/alexei-led/pumba/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "pumba";
  };
})
