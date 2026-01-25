{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  installShellFiles,
  nix-update-script,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hotpath-rs";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "pawurb";
    repo = "hotpath-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uG3PV6JnOLnlTCsvC9JfZCXMbpfXiePyLb0fcShy5hY=";
  };

  cargoLock.lockFile = ./Cargo.lock;

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  nativeBuildInputs = [ installShellFiles ];
  # TODO: only build `hotpath` binary

  # buildNoDefaultFeatures = true;

  buildFeatures = [
    "tui"
    "hotpath"
    "hotpath-alloc"
  ];

  checkFlags = [
    # reason for disabling test TODO:
    # "--skip=tests::channels_crossbeam"
    "--skip=tests::test_data_endpoints"
  ];
  # postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
  #   installShellCompletion --cmd ${finalAttrs.meta.mainProgram} \
  #     --bash <($out/bin/${finalAttrs.meta.mainProgram} completion bash) \
  #     --fish <($out/bin/${finalAttrs.meta.mainProgram} completion fish) \
  #     --zsh <($out/bin/${finalAttrs.meta.mainProgram} completion zsh)
  # '';

  # nativeInstallCheckInputs = [ versionCheckHook ];
  # doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple async Rust profiler with memory and data-flow insights - quickly find and debug performance bottlenecks";
    homepage = "https://hotpath.rs/";
    downloadPage = "https://github.com/pawurb/hotpath-rs";
    changelog = "https://github.com/pawurb/hotpath-rs/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "hotpath";
  };
})
