{ pkgs, ... }:

# Raspberry Pi 5. The board support itself (vendor kernel, vc4-kms-v3d display
# overlay, Broadcom Wi-Fi/Bluetooth firmware, declarative config.txt) comes from
# nixos-hardware's raspberry-pi-5 module, which flake.nix adds to this host.
{
  imports = [ ./hardware-configuration.nix ];

  # Repopulate the firmware partition on every rebuild, and chainload U-Boot so
  # it can read extlinux.conf and offer the usual NixOS generation menu.
  #
  # uboot.enable is not optional here. nixos-hardware replaces the stock SD
  # image's firmware step wholesale, so without it the card ends up with no
  # bootloader and no "kernel=u-boot.bin" line in config.txt.
  hardware.raspberry-pi.firmware = {
    enable = true;
    uboot.enable = true;

    # Drop the start*.elf GPU firmware, which is 22.5 MB of the 25 MB this
    # module would otherwise write. The Pi 5 never loads it: it boots from its
    # SPI EEPROM bootloader, unlike the Pi 4 and earlier.
    #
    # This is not a nicety. The firmware partition of the stock SD image is
    # 30 MB and already holds 24.6 MB, and this module adds every device tree
    # and all 371 overlays on top. Copying start*.elf as well runs the
    # partition out of space partway through, which fails activation. Measured
    # on the real image: it dies on start_db.elf with 4.8 MB free. Without
    # these files everything fits with 4.8 MB to spare.
    #
    # Only what this module writes is filtered. Any start*.elf already on the
    # card is left alone, so the board keeps a working boot path regardless.
    package = pkgs.runCommand "raspberrypi-firmware-no-gpu-boot" { } ''
      mkdir -p $out/share/raspberrypi/boot
      for f in ${pkgs.raspberrypifw}/share/raspberrypi/boot/*; do
        case "$(basename "$f")" in
          start*.elf) ;;
          *) ln -s "$f" $out/share/raspberrypi/boot/ ;;
        esac
      done
    '';
  };

  # nixos-hardware defaults to Raspberry Pi's own kernel, which is what Raspberry
  # Pi OS ships and the safest choice for HDMI and the V3D GPU. It is not in any
  # binary cache, so the first build compiles it (roughly an hour on an M2, far
  # longer on the Pi itself). To trade that for some display risk, use the
  # mainline kernel instead, which is cached:
  #
  #   boot.kernelPackages = pkgs.linuxPackages_latest;

  # Build on a faster machine and push the result:
  #   nixos-rebuild switch --flake ~/nixos-dotfiles#oso-pi \
  #     --target-host oso@oso-pi --use-remote-sudo
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };
  users.users.oso.openssh.authorizedKeys.keyFiles = [ ./authorized_keys.pub ];

  # Only applies the first time the account is created. Change it with `passwd`
  # after the first login; until then it sits in the world-readable Nix store.
  users.users.oso.initialPassword = "nixos";

  # Advertise the host as oso-pi.local so you can reach it without a fixed IP
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
    };
  };

  # Fresh install, so this tracks the release it was installed from rather than
  # the Mac's older value. Do not change it afterwards.
  system.stateVersion = "26.11";
}
