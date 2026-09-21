{
  lib,
  stdenv,
  fetchFromGitHub,
  bison,
  flex,
  sqlite,
  cunit,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "graphqlite";
  version = "0.8.0";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "colliery-io";
    repo = "graphqlite";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6zkqp6eZRPg/6c9FYW6tDXGkr0/8Kk57tewttAHNja0=";
  };

  nativeBuildInputs = [
    bison
    flex
  ];

  buildInputs = [
    sqlite
  ];

  env = {
    RELEASE = 1;
    NIX_CFLAGS_LINK = toString [
      # "build/executor/graph_algo_astar.o: undefined reference to symbol 'sin@@GLIBC_2.2.5'"
      "-lm"
    ];
  };

  buildPhase = ''
    runHook preBuild
    make graphqlite
    make extension
    # make all
    runHook postBuild
  '';

  checkInputs = [ cunit ];

  postCheck = ''
    make test-all
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib}
    mv build/gqlite $out/bin
    mv build/graphqlite.so $out/lib

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "SQLite extension that adds graph database capabilities with Cypher query language support and built-in graph algorithms";
    downloadPage = "https://github.com/colliery-io/graphqlite";
    homepage = "https://colliery-io.github.io/graphqlite/latest/";
    changelog = "https://github.com/colliery-io/graphqlite/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "gqlite";
    platforms = lib.platforms.all;
  };
})
