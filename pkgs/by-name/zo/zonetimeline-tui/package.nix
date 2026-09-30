{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zonetimeline-tui";
  version = "0.4.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "findyourexit";
    repo = "zonetimeline-tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xOaj0GvGaLLSUb4+raiZSv0ZWuFBsw7EjlrFollOBvw=";
  };

  cargoHash = "sha256-3K4IQmhPm0ov+fUP4SZ8HKAroWBvwtsMAmjfMPm4X0g=";

  # > failures:
  # >
  # > ---- display_label_for_local_resolves_iana_name_with_suffix stdout ----
  # >
  # > thread 'display_label_for_local_resolves_iana_name_with_suffix' (3259) panicked at tests/comparison_model.rs:208:5:
  # > expected label to end with '(Local)', got: Local Timezone
  # > note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace
  # >
  # >
  # > failures:
  # >     display_label_for_local_resolves_iana_name_with_suffix
  # >
  # > test result: FAILED. 28 passed; 1 failed; 0 ignored; 0 measured; 0 filtered out; finished in 0.00s

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "TUI to visually compare time zones";
    homepage = "https://github.com/findyourexit/zonetimeline-tui";
    changelog = "https://github.com/findyourexit/zonetimeline-tui/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "zonetimeline-tui";
  };
})
