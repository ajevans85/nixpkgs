{ stdenv
, fetchurl
, gnupg21
, makeWrapper
, pinentry
}:
let
  gpg = gnupg21.override {
    pinentryCmd = "pinentry-curses"; #It's hard to set this in gpg-agent.conf as need hardcoded nix path
  };
in
stdenv.mkDerivation rec {
  name = "blackbox-${version}";
  version = "1.20160122";

  src = fetchurl {
    url = "https://github.com/StackExchange/blackbox/archive/v${version}.tar.gz";
    sha256 = "044ai1n8165yqaw4d3hlbvjp5jskksag6ja9nc28ds6v9zby2pdc";
  };

  buildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r bin/blackbox_* $out/bin
    cp -r bin/_* $out/bin
  '';

  postFixup = ''
    for script in "$out"/bin/blackbox_*; do
      wrapProgram "$script" \
        --prefix PATH : ${stdenv.lib.makeBinPath [ gpg pinentry ]};
    done
  '';


  meta = with stdenv.lib; {
    description = "Safely store secrets in Git/Mercurial/Subversion";
    homepage = https://github.com/StackExchange/blackbox;
    license = licenses.mit;
    maintainers = [ maintainers.ajevans ];
    platforms = platforms.all;
  };
}
