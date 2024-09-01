{ pkgs, lib, config, inputs, ... }:

{
  packages = [ pkgs.git ];

  enterShell = ''
    export PATH="$HOME/.mix/escripts:$PATH"
  '';

  languages.nix.enable = true;
  languages.elixir.enable = true;

  pre-commit.hooks.mix-format.enable = true;
}
