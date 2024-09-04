
{ lib, config, pkgs, ... }:

let 
	unstable = import <unstable> {config.allowUnfree=true;};
in 
{
  imports = [
      ./hardware-configuration.nix
    ];
	nix.settings.experimental-features = [ "nix-command" "flakes" ];
	# Bootloader.
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;
	# fixing shutdown error
	hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
	  version = "555.58.02";
	  sha256_64bit = "sha256-xctt4TPRlOJ6r5S54h5W6PT6/3Zy2R4ASNFPu8TSHKM=";
	  sha256_aarch64 = "sha256-8hyRiGB+m2hL3c9MDA/Pon+Xl6E788MZ50WrrAGUVuY=";
	  openSha256 = "sha256-8hyRiGB+m2hL3c9MDA/Pon+Xl6E788MZ50WrrAGUVuY=";
	  settingsSha256 = "sha256-ZpuVZybW6CFN/gz9rx+UJvQ715FZnAOYfHn5jt5Z2C8=";
	  persistencedSha256 = "sha256-xctt4TPRlOJ6r5S54h5W6PT6/3Zy2R4ASNFPu8TSHKM=";
	};
	boot.kernelPackages = unstable.linuxPackages_6_1;

	networking.hostName = "nixos"; # Define your hostname.
	# GAMING SETTINGS
	hardware.opengl = {
		enable = true;
		driSupport = true;
		driSupport32Bit = true;
	};
	services.xserver.videoDrivers = ["nvidia"];
	hardware.nvidia.modesetting.enable = true;

	hardware.nvidia.prime = {
		# prefix with nvidia-offload some-game or nvidia-offload %command% in steam to use dedicated GPU
		offload = {
		      enable = true;
		      enableOffloadCmd = true;
		};
		# the correct options for these ids: nix shell nixpkgs#pciutils -c lspci | grep ' VGA '
		amdgpuBusId = "PCI:5:0:0"; # integrated GPU
		nvidiaBusId = "PCI:1:0:0"; # dedicated GPU
	};
	specialisation = {
		gaming-time.configuration = {
			hardware.nvidia = {
				prime.sync.enable = lib.mkForce true; 
				prime.offload = {
					enable = lib.mkForce false;
					enableOffloadCmd = lib.mkForce false;
				};
			};
		};
	};
	programs.steam.enable = true; 
	programs.steam.gamescopeSession.enable = true; #gamescope %command%
	programs.gamemode.enable = true; # requires the adding of commands like gamemoderun %command% in steam
		  
 
  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "fr";
    variant = "azerty";
  };

  # Configure console keymap
  console.keyMap = "fr";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  # Defining user account
  users.users.throgg = {
    isNormalUser = true;
    description = "throgg";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
	krita
	neofetch
	unstable.vivaldi
	unstable.obsidian
	unstable.qgis
	anki
	sticky
	whatsapp-for-linux
	gnomeExtensions.yakuake
    ];
    shell = pkgs.nushell;

  };


  # Install firefox.
  programs.firefox.enable = true;
  programs.kdeconnect.enable = true;
  # Tuxedo control center
  # hardware.tuxedo-rs = {enable = true; tailor-gui.enable = true; # a rust version of tuxedo control center};

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # unstable.config.allowUnfree = true;
hardware.tuxedo-rs = {
	tailor-gui.enable = true;
	enable = true;

};
  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
  	zoxide # replacement for cd
 	neovim
	mangohud # hud for gaming
	git
	gnomeExtensions.pop-shell # to make desktop environement look like pop os
	gnome.gnome-tweaks
	tuxedo-rs
	tailor-gui
  ];
  system.stateVersion = "24.05"; 
}
