{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "whaler";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "P3GLEG";
    repo = "Whaler";
    # FIXME: project author needs to tag his release properly before this can be packaged :(
    tag = finalAttrs.version;
    hash = "sha256-gCNCLbFvqn8EHWmzQh9s4uwQy0WgxAjYeXlVD8CyTQI=";
  };

  vendorHash = lib.fakeHash;

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Program to reverse Docker images into Dockerfiles";
    homepage = "https://github.com/P3GLEG/Whaler";
    changelog = "https://github.com/P3GLEG/Whaler/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "whaler";
    platforms = lib.platforms.all;
  };
})
