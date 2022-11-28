{ pkgs, inputs, private, ... }:
let
  foo = "bar";
in
{
  home.file = ({
    ".config/kitty/kitty.conf".source = ../files/kitty.conf;
    ".alacritty.yml".source = ../files/alacritty.yml;
    ".ssh/config".source = ../files/ssh_config;
    ".nginx/config".source = ../files/nginx.config;
    ".nginx/m1.gables.com.crt".source = private.m1-gables-com-crt;
    ".nginx/m1.gables.com.key".source = private.m1-gables-com-key;
    ".config/nixpkgs/config.nix".text = ''
					{ ... }:

      { allowUnsupportedSystem = true; }
    '';
    ".doom.d" = {
      source = ../files/doom;
      recursive = true;
      onChange = builtins.readFile ../files/doom/bin/reload;
    };
    "Library/Application\ Support/erlang_ls".source = ../files/erlang-ls-config.yaml;
  } //
  (if nix-env-config.os == "darwin" then
    {
    "Library/Application\ Support/erlang_ls".source = ../files/erlang-ls-config.yaml;
    }
   else
     {
       ".erlang_ls".source = ../files/erlang-ls-config.yaml;
     }
  ));
}
