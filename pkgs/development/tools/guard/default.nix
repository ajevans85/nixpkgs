{ stdenv, lib, bundlerEnv, ruby, pkgconfig}:

bundlerEnv {
  name = "guard-2.14.0";

  inherit ruby;

  gemfile = ./Gemfile;
  lockfile = ./Gemfile.lock;
  gemset = ./gemset.nix;

  meta = with lib; {
    description = "Guard automates various tasks by running custom rules whenever file or directories are modified";
    homepage    = https://github.com/guard/guard;
    license     = licenses.mit;
    maintainers = with maintainers; [ aevans ];
    platforms   = platforms.unix;
  };
}
