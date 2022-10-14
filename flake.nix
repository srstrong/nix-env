{
  description = "srstrong's systems configuration";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/release-22.05;
    darwin.url = github:lnl7/nix-darwin;
    home.url = github:nix-community/home-manager/release-22.05;
    nur.url = github:nix-community/NUR;
    private.url = git+ssh://git@github.com/srstrong/nix-env-priv?ref=main;
    #emacs.url = github:srstrong/emacs;
    emacs.url = github:cmacrae/emacs;
    emacs-overlay.url = github:nix-community/emacs-overlay;
    #rnix-lsp.url = github:nix-community/rnix-lsp;
    #deploy-rs.url = "github:serokell/deploy-rs";
    #spacebar.url = github:cmacrae/spacebar;
    #sops.url = github:Mic92/sops-nix;

    # Follows
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home.inputs.nixpkgs.follows = "nixpkgs";
    #rnix-lsp.inputs.nixpkgs.follows = "nixpkgs";
    #sops.inputs.nixpkgs.follows = "nixpkgs";
  };

  #outputs = { self, nixpkgs, darwin, home, deploy-rs, sops, ... }@inputs:
  outputs = { self, nixpkgs, darwin, home, ... }@inputs:
    let
      domain = "gables.lan";
      commonDarwinConfig = [
        ./modules/mac.nix
#        ./modules/applications.nix
        ./modules/linkapps.nix
        home.darwinModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
        {
          nixpkgs.overlays = with inputs; [
            nur.overlay
            emacs.overlay
            emacs-overlay.overlay
          ];
        }
      ];

    in
    {
      darwinConfigurations.macbookM1 = darwin.lib.darwinSystem {
        specialArgs = {
          nix-env-config.os = "darwin";
          private = inputs.private;
#          username = "steve";
        };
        system = "aarch64-darwin";
        modules = commonDarwinConfig ++ [
          (
            { pkgs, config, ... }: {
              networking.hostName = "macbookM1";

              home-manager.users.steve = {
                home.packages = with pkgs; [
                ];
              };

              homebrew.masApps = {
              };

              # home.activation = {
              #     # This should be removed once
              #     # https://github.com/nix-community/home-manager/issues/1341 is closed.
              #     aliasApplications = home.lib.hm.dag.entryAfter [ "writeBoundary" ] ''
              #       app_folder="$(echo ~/Applications)/Home Manager Apps"
              #       home_manager_app_folder="$genProfilePath/home-path/Applications"
              #       $DRY_RUN_CMD rm -rf "$app_folder"
              #       # NB: aliasing ".../home-path/Applications" to "~/Applications/Home Manager Apps" doesn't
              #       #     work (presumably because the individual apps are symlinked in that directory, not
              #       #     aliased). So this makes "Home Manager Apps" a normal directory and then aliases each
              #       #     application into there directly from its location in the nix store.
              #       $DRY_RUN_CMD mkdir "$app_folder"
              #       for app in $(find "$newGenPath/home-path/Applications" -type l -exec readlink -f {} \;)
              #       do
              #         $DRY_RUN_CMD osascript \
              #           -e "tell app \"Finder\"" \
              #           -e "make new alias file at POSIX file \"$app_folder\" to POSIX file \"$app\"" \
              #           -e "set name of result to \"$(basename $app)\"" \
              #           -e "end tell"
              #       done
              #     '';
              #   };

            }
          )
        ];
      };

#      darwinConfigurations.workbook = darwin.lib.darwinSystem {
#        system = "x86_64-darwin";
#        modules = commonDarwinConfig ++ [
#          (
#            { pkgs, ... }: {
#              networking.hostName = "workbook";
#
#              services.spacebar.config.right_shell_command = mailIndicator "work";
#
#              home-manager.users.cmacrae = {
#                home.packages = with pkgs; [
#                  argocd
#                  awscli
#                  aws-iam-authenticator
#                  terraform-docs
#                  vault
#                ];
#
#                accounts.email.accounts.fastmail.primary = false;
#                accounts.email.accounts.work =
#                  let
#                    mailAddr = name: domain: "${name}@${domain}";
#                  in
#                  rec {
#                    mu.enable = true;
#                    msmtp.enable = true;
#                    primary = true;
#                    address = mailAddr "calum.macrae" "nutmeg.com";
#                    userName = address;
#                    realName = "Calum MacRae";
#
#                    mbsync = {
#                      enable = true;
#                      create = "both";
#                      expunge = "both";
#                      remove = "both";
#                    };
#
#                    imap.host = "outlook.office365.com";
#                    smtp.host = "smtp.office365.com";
#                    smtp.port = 587;
#                    smtp.tls.useStartTls = true;
#                    # Office365 IMAP requires an App Password to be created
#                    # https://account.activedirectory.windowsazure.com/AppPasswords.aspx
#                    passwordCommand = "${pkgs.writeShellScript "work-mbsyncPass" ''
#                          ${pkgs.pass}/bin/pass Nutmeg/outlook.office365.com | head -n 1
#                        ''}";
#                  };
#              };
#            }
#          )
#        ];
#      };
#
#      nixosConfigurations.net1 = nixpkgs.lib.nixosSystem {
#        system = "aarch64-linux";
#        modules = [
#          ./modules/common.nix
#          ./modules/net1.nix
#          sops.nixosModules.sops
#
#          {
#            sops.defaultSopsFile = ./secrets.yaml;
#            sops.secrets.net1_wireguard_privatekey = { };
#          }
#        ];
#      };
#
#      nixosConfigurations.compute1 = nixpkgs.lib.nixosSystem {
#        system = "x86_64-linux";
#        modules = [
#          ./modules/common.nix
#          ./modules/compute.nix
#
#          {
#            compute.id = 1;
#            compute.hostId = "ef32e32d";
#            compute.efiBlockId = "9B1E-7DE0";
#            compute.domain = domain;
#
#            services.nzbget.enable = true;
#            services.nzbget.user = "admin";
#            services.nzbget.group = "admin";
#            services.nzbhydra2.enable = true;
#          }
#        ];
#      };
#
#      nixosConfigurations.compute2 = nixpkgs.lib.nixosSystem
#        {
#          system = "x86_64-linux";
#          modules = [
#            ./modules/common.nix
#            ./modules/compute.nix
#
#            {
#              compute.id = 2;
#              compute.hostId = "7df67865";
#              compute.efiBlockId = "0DDD-4E07";
#              compute.domain = domain;
#
#              services.radarr.enable = true;
#              services.radarr.user = "admin";
#              services.radarr.group = "admin";
#
#              services.sonarr.enable = true;
#              services.sonarr.user = "admin";
#              services.sonarr.group = "admin";
#
#              services.bazarr.enable = true;
#              services.bazarr.user = "admin";
#              services.bazarr.group = "admin";
#            }
#          ];
#        };
#
#      nixosConfigurations.compute3 = nixpkgs.lib.nixosSystem
#        {
#          system = "x86_64-linux";
#          modules = [
#            ./modules/common.nix
#            ./modules/compute.nix
#
#            {
#              compute.id = 3;
#              compute.hostId = "11dc35bc";
#              compute.efiBlockId = "A181-EEC7";
#              compute.domain = domain;
#
#              services.plex.enable = true;
#              services.plex.user = "admin";
#              services.plex.group = "admin";
#            }
#          ];
#        };
#
#      # Map each system in 'nixosConfigurations' to a common
#      # deployment description
#      deploy.nodes = (
#        builtins.mapAttrs
#          (
#            hostname: attr: {
#              inherit hostname;
#              fastConnection = true;
#              profiles = {
#                system = {
#                  sshUser = "admin";
#                  user = "root";
#                  path = deploy-rs.lib."${attr.config.nixpkgs.system}".activate.nixos
#                    self.nixosConfigurations."${hostname}";
#                };
#              };
#            }
#          )
#          self.nixosConfigurations
#      );
#
#      checks = builtins.mapAttrs
#        (system: deployLib: deployLib.deployChecks self.deploy)
#        deploy-rs.lib;
    };
}
