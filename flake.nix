{
  description = "Electrum LiveCD";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

  outputs = { self, nixpkgs }:
  {
    nixosConfigurations = {
      electrumLiveCD = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          ({ pkgs, lib, modulesPath, ... }: 
          let
            pname = "electrum";

            version = "4.5.8";

            src = builtins.fetchurl {
              url = "https://download.electrum.org/${version}/electrum-${version}-x86_64.AppImage";
              sha256 = "0h2nwxgca0d7w4p9pqlsk4g9gvs9b9gqavqgp5xv4f6k2mivs2fa";
            };

            electrumAppImage = pkgs.appimageTools.wrapType2 {
              inherit pname version src;
            };
          in
          {
            imports = [ (modulesPath + "/installer/cd-dvd/iso-image.nix") ];

            isoImage.makeEfiBootable = true;
            isoImage.makeUsbBootable = true;

            services.xserver.enable = true;
            services.xserver.autorun = false;
            services.xserver.displayManager.startx.enable = true;

            services.udev.extraRules = ''
              ACTION=="add", SUBSYSTEMS=="usb", SUBSYSTEM=="block", ENV{ID_FS_USAGE}=="filesystem", RUN{program}+="${pkgs.systemd}/bin/systemd-mount --owner=wallet --no-block --automount=yes --collect $devnode /home/wallet/media"
            '';

            users.mutableUsers = false;
            users.allowNoPasswordLogin = true;
            environment.systemPackages = [ electrumAppImage ];
            users.users.wallet = {
              isNormalUser  = true;
              home  = "/home/wallet";
            };
            services.getty.autologinUser = "wallet";

            systemd.user.services.autoElectrum= {
              enable = true;
              wantedBy = ["default.target"];
              script = ''
                      echo "exec startx" > ~/.bash_profile
                      echo "electrum" > ~/.xinitrc
              '';
            };

            system.stateVersion = lib.mkDefault lib.trivial.release;
          })
        ];
      };
    };
  };
}
