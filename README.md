# A free, simple, and secure alternative to hardware wallets

Hardware wallets seem to be the default suggestion for secure storage. I have two issues with this approach:
- It's difficult to verify what's actually implemented on the device. They're so niche, fragmented, and complex that I doubt there's enough verification
- Hardware wallets have only been around a few years. It's not clear how durable they are

Instead, here's a software focused strategy that's simple enough to verify yourself. I'm using electrum here, but any wallet would work. The same approach can also be used with other coins.

Online machine
1. install nix (or NixOS) on an internet connected system, https://nixos.org/download/. Enable flakes, https://nixos.wiki/wiki/Flakes
2. clone this repo and cd into it
3. if you want to update the lock file,
    - nix flake update
4. build the image,
    - nix build .#nixosConfigurations.electrumLiveCD.config.system.build.isoImage
5. write the image in result/iso onto a usb drive

Offline machine
1. boot into usb on an offline machine
2. run startx in tty
3. run electrum in xterm
4. create wallets, sign transactions, etc

This approach avoids the issues mentioned above
- this repo contains <50 lines of code so is easy to audit. IMO the dependencies, nix, xorg, and electrum are trustworthy enough because they're all opensource, heavily used, and have substantial investment behind them. Note that I'm pulling the appimage from the electrum website instead of using the nixpkg due to the potential of malicious code
- since this is software, you can rebuild and run on any systems you want

If you found this useful, tips are appreciated

bitcoin
- bc1qy3ac3l090uzr66k8j83rn0lvjtjrg3pur4fzzs

ethereum
- 0x3e984F5C8689eCa61f72AF1c312400964aEB564a
