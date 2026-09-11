{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dbml";
  version = "10.1.2-alpha.0";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "holistics";
    repo = "dbml";
    tag = "v${finalAttrs.version}";
    hash = "sha256-i1F/50utMqBQ/QbFRwq0BSF2RZRd5qpzuvHszi16rLc=";
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Database Markup Language (DBML), designed to define and document database structures";
    homepage = "https://github.com/holistics/dbml";
    changelog = "https://github.com/holistics/dbml/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "dbml";
    platforms = lib.platforms.all;
  };
})
