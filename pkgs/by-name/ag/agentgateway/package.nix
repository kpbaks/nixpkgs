{
  lib,
  buildNpmPackage,
  buildGoModule,
  installShellFiles,
  rustc,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  versionCheckHook,
  nix-update-script,
  withUi ? true,
}:

let
  version = "1.5.0";
  src = fetchFromGitHub {
    owner = "agentgateway";
    repo = "agentgateway";
    tag = "v${version}";
    hash = "sha256-QP0i9uUZ3CSF5q+BjO3p7rLIY2aj02OSJMzybT8Pnb8=";
  };

  webui = buildNpmPackage {
    pname = "agentgateway-webui";
    inherit version src;
    sourceRoot = "${src.name}/ui";

    npmDepsHash = lib.fakeHash;

    installPhase = ''
      mkdir -p $out/share
      mv dist $out/share/
    '';
  };
  agctl = buildGoModule (finalAttrs: {
    pname = "agctl";
    inherit version src;
    # sourceRoot = "${src.name}/controller";

    vendorHash = lib.fakeHash;

    nativeBuildInputs = [
      installShellFiles

    ];

    ldflags = [ "-s" ];

    subPackages = [ "controller" ];
    # TODO: install completion

    postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      installShellCompletion --cmd agctl \
        --bash <($out/bin/agctl completion bash) \
        --fish <($out/bin/agctl completion fish) \
        --zsh <($out/bin/agctl completion zsh)
    '';
  });
in

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "agentgateway";
  inherit version src;
  __structuredAttrs = true;

  cargoHash = "sha256-5Hswt0WgdBPvJns21MCJPDLiL18GM3Wf2++Dl+r9ZEs=";

  cargoFeatures = lib.optional withUi "ui";

  env.AGENTGATEWAY_BUILD_buildVersion = finalAttrs.version;
  env.AGENTGATEWAY_BUILD_buildGitRevision = finalAttrs.src.rev;
  env.AGENTGATEWAY_BUILD_RUSTC_VERSION = rustc.version;
  env.AGENTGATEWAY_BUILD_PROFILE_NAME = "release";
  env.AGENTGATEWAY_BUILD_TARGET = "";

  # rustPlatform.buildRustPackage uses this attribute for ... # TODO does it ?
  postPatch = ''
    substituteInPlace Cargo.toml --replace-fail 'version = "0.0.0"' 'version = "${version}"'
  '';

  preBuild = lib.optionals withUi ''
    mkdir -p internal/static/dist
    cp -r ${webui}/share/dist/* internal/static/dist
  '';
  # TODO: remove once build works
  buildType = "debug";
  checkType = "debug";

  # TODO: build agctl with go

  #   # `corepack pnpm` needs no `corepack enable`, so this works on a fresh checkout.
  # .PHONY: ui
  # ui:
  # 	cd ui && corepack pnpm install --frozen-lockfile && corepack pnpm build

  #   # vendorHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";

  # buildInputs = lib.optionals stdenv.isLinux [
  #   xorg.libX11
  # ];

  # ldflags = [ "-s" ];
  # export LDFLAGS := -X 'github.com/agentgateway/agentgateway/controller/pkg/version.Version=$(VERSION)' -s -w

  postInstall = ''
    mkdir -p $out/bin
    cp ${agctl}/bin/agctl $out/bin
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Next Generation Agentic Proxy for AI Agents and MCP servers";
    homepage = "https://agentgateway.dev/";
    downloadPage = "https://github.com/agentgateway/agentgateway";
    changelog = "https://github.com/agentgateway/agentgateway/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "agentgateway";
  };
})
