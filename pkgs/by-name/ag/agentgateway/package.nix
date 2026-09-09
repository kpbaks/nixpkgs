{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
  xorg,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "agentgateway";
  version = "1.5.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "agentgateway";
    repo = "agentgateway";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QP0i9uUZ3CSF5q+BjO3p7rLIY2aj02OSJMzybT8Pnb8=";
  };

  vendorHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";

  buildInputs = lib.optionals stdenv.isLinux [
    xorg.libX11
  ];

  ldflags = [ "-s" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Next Generation Agentic Proxy for AI Agents and MCP servers";
    homepage = "https://github.com/agentgateway/agentgateway";
    changelog = "https://github.com/agentgateway/agentgateway/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "agentgateway";
  };
})
