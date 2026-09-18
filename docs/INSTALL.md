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
| `oso-pi` | Raspberry Pi 4 | `.#oso-pi` |

## Raspberry Pi 4

### 1. Write the stock image

The aarch64 image published by Hydra is the installer variant: it autologins
as `nixos`, gives that account passwordless sudo, and runs sshd. A
`nixos-unstable` image is used here because that is what this flake tracks.

Hydra's `latest/download/1` shortcut serves an HTML page rather than the
image, so resolve the build and its product name first:

```bash
job=https://hydra.nixos.org/job/nixos/trunk-combined/nixos.sd_image.aarch64-linux/latest
bid=$(curl -sL "$job" -H 'Accept: application/json' | jq -r .id)
name=$(curl -sL "https://hydra.nixos.org/build/$bid" -H 'Accept: application/json' \
         | jq -r '.buildproducts."1".name')
curl -L -o nixos-sd.img.zst "https://hydra.nixos.org/build/$bid/download/1/$name"
zstd -d nixos-sd.img.zst -o nixos-sd.img
```

Find the card, then write it. Check the size and model in the output before
running `dd`, because the wrong device here destroys the wrong disk.

```bash
lsblk -o NAME,SIZE,TYPE,MODEL,TRAN
sudo dd if=nixos-sd.img of=/dev/sdX bs=4M status=progress conv=fsync
```

If the Pi does not boot at all, try the `sd_image_new_kernel` job instead,
which ships a newer kernel.

Check which board you actually have before going further. `cat
/proc/device-tree/model` on the running Pi settles it, and the host in this
repo is built for a Pi 4. A Pi 5 needs `nixos-hardware`'s `raspberry-pi-5`
module instead, along with a different set of GPU firmware files.

### 2. First boot

Put the card in the Pi, attach HDMI and a keyboard, power it on. It autologins
as `nixos` and grows the root partition.

Get on the network. Ethernet needs nothing. For Wi-Fi:

```bash
sudo systemctl start wpa_supplicant
nmtui
```

### 3. Choose where to build

The Raspberry Pi vendor kernel is in no binary cache, so somebody has to
compile it. Building it on the Pi takes hours. The Air is also `aarch64-linux`,
so it can build the whole system natively and copy the result over. That is the
faster path by a wide margin.

**Build on the Air (recommended).** On the Pi, authorise the Air's key and note
the address:

```bash
mkdir -p ~/.ssh && curl -L https://github.com/Exotia.keys >> ~/.ssh/authorized_keys
ip -4 addr show scope global | grep inet
```

Then, from the Air:

```bash
nixos-rebuild switch --flake ~/nixos-dotfiles#oso-pi \
  --target-host nixos@<pi-ip> --use-remote-sudo
```

**Or build on the Pi.** Slow, but needs nothing else:

```bash
nix-shell -p git --run 'git clone https://github.com/Exotia/nixos.git ~/nixos-dotfiles'
sudo nixos-rebuild boot --flake ~/nixos-dotfiles#oso-pi
```

To skip the kernel compile entirely, uncomment the `boot.kernelPackages` line
in `hosts/oso-pi/default.nix` first. That uses the cached mainline kernel, at
some risk to HDMI and the GPU.

### 4. Reboot and finish

```bash
sudo reboot
```

Log in as `oso` with the initial password `nixos`, then immediately:

```bash
passwd
```

Clone the repo into place. Everything under `config/` is symlinked live from
`~/nixos-dotfiles`, so until this exists Hyprland starts with no configuration:

```bash
git clone https://github.com/Exotia/nixos.git ~/nixos-dotfiles
```

Log out and back in. Reconnect Wi-Fi under your own account with `nmtui`;
nothing about Wi-Fi is declared in this repo.

From here the Pi answers to `oso-pi.local`, and later rebuilds can come from
the Air:

```bash
nixos-rebuild switch --flake ~/nixos-dotfiles#oso-pi \
  --target-host oso@oso-pi.local --use-remote-sudo
```

That uses the key in `hosts/oso-pi/authorized_keys.pub`. Replace that file if
you use a different one.

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
