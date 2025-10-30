{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "dcv";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "tokuhirom";
    repo = "dcv";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OwfGZq+ce6RNb5dhNHsQ15iMPoEp7QlaYIUVYIiVqmI=";
  };

  vendorHash = "sha256-uXv+ITiPVVKibvyZudWbUFEHeudoat7v18yO5HpoobE=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "TUI viewer for docker-compose";
    homepage = "https://github.com/tokuhirom/dcv";
    license = lib.licenses.unfree; # FIXME: nix-init did not find a license
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "dcv";
  };
})
