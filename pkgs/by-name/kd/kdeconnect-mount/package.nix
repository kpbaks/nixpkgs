{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  kdePackages,
  util-linux,
  sshfs-fuse,
  fuse,
  iproute2,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kdeconnect-mount";
  version = "0-unstable-2026-08-07";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "uelel";
    repo = "kdeconnect-mount";
    rev = "8c0d791db791f0cb93919b35dfae527a9443705e";
    hash = "sha256-xn82McGWZQXCgwh0bZ1e49l2M6/94dY2ejKsbbt1srI=";
  };

  nativeBuildInputs = [ makeWrapper ];

  # /nix/store/92ayk7chbswiq7nbv5apm18f2bbnsfif-fuse-3.18.2-bin/bin/fusermount3: option allow_other only allowed if 'user_allow_other' is set in /etc/fuse.conf

  installPhase = ''
    install -D --mode 755 kdeconnect-mount.sh $out/bin/kdeconnect-mount
    patchShebangs --build $out/bin/kdeconnect-mount
    wrapProgram $out/bin/kdeconnect-mount \
      --prefix PATH : ${
        lib.makeBinPath [
          kdePackages.kdeconnect-kde # kdeconnect-cli
          kdePackages.qttools # qdbus
          util-linux # mountpoint mount
          sshfs-fuse
          fuse # fusermount
          iproute2 # ss
        ]
      }

  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Mount Android filesystem using KDE Connect";
    homepage = "https://github.com/uelel/kdeconnect-mount";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "kdeconnect-mount";
    platforms = lib.platforms.linux;
  };
})
