# Welcome
Welcome to my dotfiles! They have taken on many forms over the years (and I'm sure will take on many more). Currently they are implemented as a Nix Flake with support for NixOS. In the future I hope to support Darwin-NIX (for work) and standalone home-manager for other linux based systems. 

## NixOS
I'm currently running NixOS on an HP Firefly G10A both to try out NixOS, as well as to have a reasonably powerful and long lasting linux laptop. This configuration will deploy the wonderful [Niri](https://github.com/YaLTeR/niri) window manager along with the following to create a full desktop environment:
* [Waybar](https://github.com/Alexays/Waybar)
* [Walker](https://github.com/abenz1267/walker) (Launcher with extras)
* [Hypridle](https://github.com/hyprwm/hypridle)
* [Hyprlock](https://github.com/hyprwm/hyprlock)

## Secrets
This repo currently uses [git-agecrypt](https://github.com/vlaci/git-agecrypt) to encrypt files that need to be available early on during system build and not just at runtime.

This requires installing `git-agecrypt`, and then running `git-agecrypt init` and `git-agecrypt config add -i ~/.ssh/id_ed25519` to configure the local repository correctly. Once this is done the encrypted files should be decrypted upon checkout and automatically encrypted when committing.