{ lib, modulesPath, ... }:

# Disk layout for a Raspberry Pi 5 booted from the official NixOS aarch64 SD
# image, which labels its two partitions FIRMWARE and NIXOS_SD.
#
# If you install to NVMe or USB instead, replace this file with the output of
#   sudo nixos-generate-config --show-hardware-config
# run on the Pi itself, but keep the /boot/firmware entry below.
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXOS_SD";
    fsType = "ext4";
  };

  # The Raspberry Pi firmware partition. Unlike the stock sd-image module we do
  # not mark it "noauto": hardware.raspberry-pi.firmware refreshes config.txt,
  # the device trees and U-Boot here on every rebuild, and it silently skips the
  # whole step when the partition is not actually mounted.
  fileSystems."/boot/firmware" = {
    device = "/dev/disk/by-label/FIRMWARE";
    fsType = "vfat";
    options = [ "nofail" ];
  };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
