{ config, pkgs, ... }:

let
  inherit (pkgs.stdenv.lib) optionals;

  purerlSupport =
    builtins.fetchGit {
      url = "https://github.com/id3as/nixpkgs-purerl-support.git";
      ref = "master";
      rev = "c9a9140db5112e74030763292dc93de25adb3482";
    };

  pls = nixpkgs.nodePackages.purescript-language-server.override {
      version = "0.13.5";
      src = builtins.fetchurl {
        url = "https://registry.npmjs.org/purescript-language-server/-/purescript-language-server-0.13.5.tgz";
        sha256 = "0jr3hfa4ywb97ybrq4b64pbngwd1x297vppps7cqf4mmiwz9chb9";
      };
    };

  nixpkgs =
    import <nixpkgs> {
      overlays = [
        (import purerlSupport)

      ];
    };

in
{
  # Packages
  home.packages = with pkgs; [
    # GNU > BSD :)
    coreutils

    # Useful for system administration
    htop
    iftop
    wget

    # Development
    gitAndTools.tig
    git-lfs
    dhall
    ag
    ripgrep
    fzf
    jq
    python27Packages.jsmin
    websocat
    zlib.dev
    stack
    ghc

    nixpkgs.purerl-support.erlang_ls-0-4-1
    pls

    # inetutils
  ] ++ optionals stdenv.isLinux [ glibcLocales ] ++ optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  # Configuration
  imports = [
    ./steve/hm-fish.nix
    ./steve/hm-tmux.nix
    ./steve/hm-git.nix
    ./steve/hm-emacs.nix
    ./steve/hm-zsh.nix
    ./steve/hm-direnv.nix
    ./steve/hm-lorri.nix
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
