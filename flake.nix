{
  description = "Electrum LiveCD";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

  outputs = { self, nixpkgs }:
  {
    nixosConfigurations = {
      electrumLiveCD = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({ pkgs, modulesPath, ... }: 
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
            imports = [ (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix") ];

            services.xserver.enable = true;
            services.xserver.autorun = false;
            services.xserver.displayManager.startx.enable = true;

            environment.systemPackages = [
              electrumAppImage
            ];
          })
        ];
      };
    };
  };
}
