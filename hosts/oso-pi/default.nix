{ ... }:

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
