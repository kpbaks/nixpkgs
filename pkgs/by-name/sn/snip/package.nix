{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "snip";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "edouard-claude";
    repo = "snip";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Fg/D/sb8prdmiUZ+PfA/ZWTeRC9y8fX0xXnd3YrRpD0=";
  };

  vendorHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";

  ldflags = [ "-s" ];

  meta = {
    description = "CLI proxy that reduces LLM token consumption by 60-90% on common dev commands. Single Go binary";
    homepage = "https://github.com/edouard-claude/snip";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "snip";
  };
})
