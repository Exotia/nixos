{ pkgs, ... }:

# Raspberry Pi 4. The board support itself (vendor kernel, bcm2711 device
# trees, Broadcom Wi-Fi/Bluetooth firmware, declarative config.txt) comes from
# nixos-hardware's raspberry-pi-4 module, which flake.nix adds to this host.
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

    # Drop the GPU firmware for Pi 3 and earlier, keeping the start4* set this
    # board actually loads. That is about 12.5 MB of the 25 MB this module
    # would otherwise write.
    #
    # This is not a nicety. The firmware partition of the stock SD image is
    # 30 MB and already holds 24.6 MB, and this module adds every device tree
    # and all 371 overlays on top. Copying every start*.elf as well runs the
    # partition out of space partway through, which fails activation. Measured
    # against the real image: it dies on start_db.elf with 4.8 MB free.
    #
    # Only what this module writes is filtered. Anything already on the card is
    # left alone, so the board keeps a working boot path regardless.
    package = pkgs.runCommand "raspberrypi-firmware-pi4" { } ''
      mkdir -p $out/share/raspberrypi/boot
      for f in ${pkgs.raspberrypifw}/share/raspberrypi/boot/*; do
        case "$(basename "$f")" in
          start4*.elf) ln -s "$f" $out/share/raspberrypi/boot/ ;;
          start*.elf) ;; # Pi 3 and earlier; a Pi 4 never loads these
          *) ln -s "$f" $out/share/raspberrypi/boot/ ;;
        esac
      done
    '';
  };

  # Mainline kernel, not Raspberry Pi's vendor one. nixos-hardware defaults to
  # the vendor kernel, which no binary cache carries, so it costs about an hour
  # of compiling per bump.
  #
  # That price buys nothing here. The stock NixOS image booted this board on
  # mainline 6.18.52 with vc4 and v3d loaded and both HDMI outputs live, which
  # is the whole graphics stack Hyprland needs. The Pi 4's BCM2711 has been
  # mainlined for years; it is the Pi 5 that still needs the vendor tree.
  boot.kernelPackages = pkgs.linuxPackages;

  # Keep the GIC-400 interrupt controller settings that the stock NixOS SD
  # image puts in config.txt. nixos-hardware does not set these, but this board
  # is demonstrably using the GIC: its kernel log reports "Root IRQ handler:
  # gic_handle_irq". Our config.txt replaces the stock one wholesale, so
  # without these two lines the next boot would come up differently from the
  # one that is known to work here.
  #
  # armstub8-gic.bin comes from the stock image and stays on the firmware
  # partition: this module only ever prunes stale *.dtb and overlays/*, never
  # other files. A card written from scratch by some future flow would need it
  # copied over as well.
  hardware.raspberry-pi.configtxt.settings.pi4 = {
    enable_gic = true;
    armstub = "armstub8-gic.bin";
  };

  # Build on a faster machine and push the result:
  #   nixos-rebuild switch --flake ~/nixos-dotfiles#oso-pi \
  #     --target-host oso@oso-pi.local --use-remote-sudo
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      # Key only, never a password. Root login stays open to keys because
      # nixos-rebuild --target-host has to activate the new system: going
      # through oso instead would prompt for a sudo password on every deploy,
      # which does not work unattended.
      PermitRootLogin = "prohibit-password";
    };
  };
  users.users.oso.openssh.authorizedKeys.keyFiles = [ ./authorized_keys.pub ];
  users.users.root.openssh.authorizedKeys.keyFiles = [ ./authorized_keys.pub ];

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
