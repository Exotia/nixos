# Installing on a new machine

The flow is the same everywhere: install stock NixOS, clone this repo to
`~/nixos-dotfiles`, point a rebuild at the matching host, reboot.

The clone path matters. Everything under `config/` is symlinked live out of
`~/nixos-dotfiles/config`, so the repo has to sit at exactly that path or the
symlinks dangle and Hyprland starts with no configuration.

## Existing hosts

| Host | Machine | Attribute |
|---|---|---|
| `oso-air` | MacBook Air M2, Asahi | `.#oso-air` |
| `oso-pi` | Raspberry Pi 5 | `.#oso-pi` |

## Raspberry Pi 5

1. **Write a stock image.** Download the `nixos-unstable` generic AArch64 SD
   image. The 26.05 release images do not carry the Pi 5 boot files, so an
   unstable image is required.

   ```bash
   zstd -d nixos-sd-image-*-aarch64-linux.img.zst
   sudo dd if=nixos-sd-image-*-aarch64-linux.img of=/dev/sdX bs=4M status=progress conv=fsync
   ```

   Check `lsblk` for the right device first. This erases the card.

2. **Boot the Pi** with a keyboard and a monitor on HDMI. The stock image logs
   in as `nixos` with no password and grows the root partition on first boot.

3. **Get on the network.** Ethernet needs nothing. For Wi-Fi:

   ```bash
   sudo systemctl start wpa_supplicant
   nmtui          # or: wpa_cli, depending on the image
   ```

4. **Clone and build.**

   ```bash
   nix-shell -p git --run 'git clone https://github.com/Exotia/nixos.git ~/nixos-dotfiles'
   sudo nixos-rebuild boot --flake ~/nixos-dotfiles#oso-pi
   sudo reboot
   ```

   Use `boot` rather than `switch` here. The first activation replaces the
   bootloader and the firmware partition, and a reboot is cleaner than
   switching a running system out from under itself.

   This first build compiles the Raspberry Pi vendor kernel, which is in no
   binary cache. On the Pi itself that takes hours. To avoid it, either build
   on a faster `aarch64-linux` machine and push the result (see below), or
   switch the host to the cached mainline kernel by uncommenting the
   `boot.kernelPackages` line in `hosts/oso-pi/default.nix`.

5. **Log in** as `oso` with the initial password `nixos`, then change it:

   ```bash
   passwd
   ```

6. **Reconnect Wi-Fi** under your own account with `nmtui`. Wi-Fi is not
   declared in this repo, so nothing is pre-seeded.

### Building the Pi's system on the Air

Both machines are `aarch64-linux`, so the Air can build for the Pi natively and
copy the result over SSH. This is much faster than building on the Pi.

```bash
nixos-rebuild switch --flake ~/nixos-dotfiles#oso-pi \
  --target-host oso@oso-pi.local --use-remote-sudo
```

SSH on the Pi accepts only the key in `hosts/oso-pi/authorized_keys.pub`.
Replace that file if you use a different key. The Pi announces itself over
mDNS as `oso-pi.local`.

## Adding another machine

1. Install stock NixOS and set its hostname to the name you are about to use.
   The hostname has to match, because the `nrs` alias resolves the flake
   attribute from `hostname`.

2. Capture the hardware:

   ```bash
   mkdir -p ~/nixos-dotfiles/hosts/<name>
   sudo nixos-generate-config --show-hardware-config \
     > ~/nixos-dotfiles/hosts/<name>/hardware-configuration.nix
   ```

3. Write `hosts/<name>/default.nix` with whatever is specific to that machine:
   bootloader, firmware, drivers, `system.stateVersion`. Everything portable is
   already in `modules/common.nix`.

4. Write `home/profiles/<name>.nix`:

   ```nix
   { ... }:
   {
     imports = [ ../common.nix ];   # add ../packages/apps-heavy.nix if it can take it
   }
   ```

5. Add the host to `flake.nix`:

   ```nix
   <name> = mkHost {
     name = "<name>";
     system = "x86_64-linux";            # omit on aarch64
     modules = [ /* board support, e.g. nixos-hardware.nixosModules.* */ ];
   };
   ```

6. `git add` the new files. A flake cannot see files that Git does not track,
   and the error message for this is confusing, so do it before building.

7. `sudo nixos-rebuild boot --flake ~/nixos-dotfiles#<name>` and reboot.

## Day to day

```bash
nrs        # sudo nixos-rebuild switch --flake ~/nixos-dotfiles#$(hostname)
```

Only Nix files need a rebuild. Files under `config/` are live symlinks.
