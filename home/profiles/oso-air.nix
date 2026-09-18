{ ... }:

# MacBook Air M2. Gets everything, including the large Electron applications.
{
  imports = [
    ../common.nix
    ../packages/apps-heavy.nix
  ];
}
