{ pkgs, private, ... }:
let
in
{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    zsh
    kitty
    vim
  ];

  # Auto upgrade nix package and the daemon service.
  nix.package = pkgs.nixVersions.git;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina
  # programs.fish.enable = true;

  # Misc nix settings
  nix.settings.max-jobs = "auto";
  nix.settings.cores = 0;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;
  
  time.timeZone = "Europe/London";
  
  environment.shells = [ pkgs.zsh ];
  environment.variables = { GH_TOKEN = private.gh_token; };

  fonts.packages = with pkgs; [
    emacs-all-the-icons-fonts
    fira-code
    font-awesome
    inconsolata
#    nerdfonts
    roboto
    roboto-mono
  ];

}
