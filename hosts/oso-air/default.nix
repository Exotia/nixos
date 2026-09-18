{ ... }:

# MacBook Air M2 (Apple Silicon, Asahi). Everything here is specific to this
# laptop; the portable half of the system lives in modules/common.nix.
{
  imports = [
    # Includes the results of the hardware scan (disk layout, kernel modules, etc.)
    ./hardware-configuration.nix
  ];

  # --- Boot & Hardware (Apple Silicon M2 Air) ---
  # Asahi support: kernel, GPU driver, peripheral firmware and speakers/mic DSP
  hardware.asahi = {
    enable = true;
    peripheralFirmwareDirectory = ./firmware; # must be tracked by git so the flake can see it
    setupAsahiSound = true;
  };

  # Bootloader configuration (systemd-boot behind Asahi's m1n1/U-Boot)
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5; # the Asahi EFI partition is small
  boot.loader.efi.canTouchEfiVariables = false; # U-Boot does not expose EFI variables

  ## Kernel level of logging (disable the message from the LY login at startup)
  boot.consoleLogLevel = 3;
  boot.kernelParams = [ "quiet" ];

  # iwd is the working Wi-Fi backend on Asahi (Broadcom)
  networking.networkmanager.wifi.backend = "iwd";

  # Power Management
  services.power-profiles-daemon.enable = true; # Manages power profiles (performance, balanced, power-saver) to save battery

  # wireplumber does not exit on SIGTERM at shutdown (Asahi audio driver), so systemd waited the default
  # 90 s before killing it on every reboot. A 5 s stop timeout makes reboot immediate; the kill is harmless.
  systemd.user.services.wireplumber = {
    overrideStrategy = "asDropin";
    serviceConfig.TimeoutStopSec = "5s";
  };

  # State version (Do not change this! It ensures backwards compatibility with databases created when you installed NixOS)
  system.stateVersion = "26.05";
}
