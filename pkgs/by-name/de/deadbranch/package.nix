{
  lib,
  rustPlatform,
  fetchFromGitHub,
  git,
  nix-update-script,
  versionCheckHook,
  installShellFiles,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "deadbranch";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "armgabrielyan";
    repo = "deadbranch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PhMXJZANH2/sPbtZ+YgD/qlXfc98bnTXI2AEEniztsI=";
  };

  cargoHash = "sha256-Q3gnZ9PdeAqLSqdMaBhiYsnj/H/gBdWZdMMZDTKxz0c=";

  nativeBuildInputs = [ installShellFiles ];

  # FIXME: get the number of skipped tests down
  checkFlags = [
    "--skip=test_backup_clean_keeps_most_recent"
    "--skip=test_backup_clean_dry_run"
    "--skip=test_backup_clean_mutual_exclusion"
    "--skip=test_backup_clean_no_backups"
    "--skip=test_backup_clean_requires_current_or_repo"
    "--skip=test_backup_clean_nothing_to_clean"
    "--skip=test_backup_clean_shows_table"
    "--skip=test_backup_clean_with_yes_flag"
    "--skip=test_backup_clean_with_repo_flag"
    "--skip=test_backup_contains_branch_restore_command"
    "--skip=test_backup_list_current_no_backups"
    "--skip=test_backup_list_mutual_exclusion"
    "--skip=test_backup_list_current_shows_backups"
    "--skip=test_backup_list_repo_flag"
    "--skip=test_backup_list_current_shows_branch_count"
    "--skip=test_backup_list_shows_repository_after_clean"
    "--skip=test_backup_list_no_backups"
    "--skip=test_backup_restore_from_specific_backup"
    "--skip=test_backup_restore_branch_already_exists"
    "--skip=test_backup_restore_basic"
    "--skip=test_backup_restore_branch_not_in_backup"
    "--skip=test_backup_restore_no_backups"
    "--skip=test_backup_restore_with_as_flag"
    "--skip=test_backup_restore_shows_short_sha"
    "--skip=test_backup_stats_shows_repo_and_count"
    "--skip=test_backup_stats_shows_row_number"
    "--skip=test_backup_restore_with_force"
    "--skip=test_backup_stats_shows_table_columns"
    "--skip=test_clean_creates_backup"
    "--skip=test_multiple_cleans_create_multiple_backups"
    "--skip=test_clean_dry_run"
    "--skip=test_clean_merged_only_by_default"
    "--skip=test_clean_requires_confirmation"
    "--skip=test_config_set_default_days"
    "--skip=test_config_show"
    "--skip=test_list_empty_repo"
    "--skip=test_list_excludes_draft_branches"
    "--skip=test_list_excludes_wip_branches"
    "--skip=test_list_local_only"
    "--skip=test_list_respects_protected_branches"
    "--skip=test_list_with_days_filter"
    "--skip=test_list_with_new_branch"
    "--skip=test_list_with_old_branch"
    "--skip=test_current_branch_excluded"
    "--skip=test_list_merged_branches_only"
    "--skip=test_list_shows_age_information"
    "--skip=test_list_shows_merged_status"
    "--skip=test_multiple_old_branches"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd ${finalAttrs.meta.mainProgram} \
      --bash <($out/bin/${finalAttrs.meta.mainProgram} completions bash) \
      --fish <($out/bin/${finalAttrs.meta.mainProgram} completions fish) \
      --zsh <($out/bin/${finalAttrs.meta.mainProgram} completions zsh)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Clean up stale git branches safely";
    homepage = "https://github.com/armgabrielyan/deadbranch";
    changelog = "https://github.com/armgabrielyan/deadbranch/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "deadbranch";
  };
})
