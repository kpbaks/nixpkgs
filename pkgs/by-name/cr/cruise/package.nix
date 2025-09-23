{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "cruise";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "NucleoFusion";
    repo = "cruise";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0xIugbLlKlMODbMvsFzQXjKNNGY61tF4P/0loPlfs6o=";
  };

  vendorHash = "sha256-Zx1rZl5ljlsBNV1eQKPtQ+SgJV9l5rS8hwBe8nX9dYQ=";

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd cruise \
      --bash <($out/bin/cruise completion bash) \
      --fish <($out/bin/cruise completion fish) \
      --zsh <($out/bin/cruise completion zsh)
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "";
    # description = "Cruise is a powerful, intuitive, and fully-featured TUI (Terminal User Interface) for interacting with Docker. Built with Go and Bubbletea, it offers a visually rich, keyboard-first experience for managing containers, images, volumes, networks, logs and more — all from your terminal";
    homepage = "https://nucleofusion.github.io/cruise/";
    downloadPage = "https://github.com/NucleoFusion/cruise";
    changelog = "https://github.com/NucleoFusion/cruise/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "cruise";
  };
})
