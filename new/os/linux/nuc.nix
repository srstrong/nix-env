# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

args@{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./nuc-hardware.nix

      # Common things
      #(import ./../../common (args // { hostOs = "linux"; } ))
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nixpkgs.config.allowUnfree = true;

  boot.kernel.sysctl = {
    "net.core.rmem_default" = 65536;
    "net.core.rmem_max" = 16777216;
    "net.core.wmem_default" = 65536;
    "net.core.wmem_max" = 16777216;
    "net.ipv4.udp_rmem_min" = 131072;
    "net.ipv4.udp_wmem_min" = 131072;
    "net.ipv4.udp_mem" = "65536 12582912 16777216";

    "net.ipv4.tcp_mem" = "12582912 12582912 12582912";
    "net.ipv4.tcp_wmem"  = "4096 12582912 16777216";
    "net.ipv4.tcp_rmem"  = "4096 12582912 16777216";

    "net.ipv4.tcp_window_scaling" = 1;
    "net.ipv4.route.flush" = 1;
    "net.core.netdev_max_backlog" = 100000;
  };

  networking.hostName = "nuc"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.eno1.useDHCP = true;
  networking.interfaces.enp5s0.useDHCP = true;
  networking.interfaces.wlp6s0.useDHCP = true;

  networking.extraHosts =
  ''
    192.168.1.93 nuc
  '';

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";


  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.steve = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
  };

  users.users.kapacitor.group = "kapacitor";
  users.groups.kapacitor = {};

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?

  systemd.services.nixos-upgrade.path = [ pkgs.git  ];

  boot.kernelModules = [ "intel-drm"  ];

  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };

  services.grafana = {
    enable   = true;
    dataDir  = "/var/lib/grafana";
    settings = {
      server = {
        protocol = "http";
        domain = "nuc";
        http_addr = "192.168.1.93";
        http_port = 8000;
      };
    };
  };

  services.influxdb = {
    enable   = true;
  };

  services.telegraf = {
    enable   = true;
    extraConfig = {
      agent    = {
        hostname = "nuc.gables.lan";
      };
      inputs = {
        cpu = { percpu = true; totalcpu = true; };
        disk = { ignore_fs = ["tmpfs" "devtmpfs"]; };
        diskio = {};
        kernel = {};
        linux_sysctl_fs = {};
        mem = {};
        processes = { };
        swap = {};
        system = {};
        net = { interfaces = [ "enp5s0" ]; };
        netstat = {};
        interrupts = {};
        conntrack = { files = ["ip_conntrack_count" "ip_conntrack_max" "nf_conntrack_count" "nf_conntrack_max"];
                      dirs = ["/proc/sys/net/ipv4/netfilter" "/proc/sys/net/netfilter"];
                    };
        internal = {};
        procstat = { exe = "beam"; };
      };
      outputs = {
         influxdb = { database = "telegraf_metrics"; urls = [ "http://localhost:8086" ]; };
      };
    };
  };

  services.kapacitor = {
    enable   = true;
  };

  # VAAPI
  #   # https://nixos.wiki/wiki/Accelerated_Video_Playback
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      vaapiIntel
      intel-media-driver
    ];
  };

  virtualisation.docker.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    libva-utils
    grafana
    telegraf
    kapacitor
    procps
    libev
    nginx
  ];

}
