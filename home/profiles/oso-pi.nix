{ ... }:

# Raspberry Pi 5. The same desktop, shell and editor as the Air, minus the
# large Electron applications: they are slow on this board and cost a lot of
# build time and SD card space. Add ../packages/apps-heavy.nix here to get them.
{
  imports = [ ../common.nix ];
}
