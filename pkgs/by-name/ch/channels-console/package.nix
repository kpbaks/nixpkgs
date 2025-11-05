{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "channels-console";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "pawurb";
    repo = "channels-console";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SiLLM920VPF6rA0GjEZTZuwPzq+OApXzOr4y89b5djU=";
  };

  buildFeatures = [ "tui" ];

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  # doCheck = false;
  checkFlags = [
    "--skip=tests::test_data_endpoints"
    # FIXME: there is some doc tests failing
  ];

  # buildInputs = lib.optionals stdenv.isDarwin [
  #   darwin.apple_sdk.frameworks.Security
  # ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Real-time monitoring, metrics and logs for Rust channels";
    homepage = "https://github.com/pawurb/channels-console";
    changelog = "https://github.com/pawurb/channels-console/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "channels-console";
  };
})
