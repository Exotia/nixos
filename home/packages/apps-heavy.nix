{ pkgs, ... }:

# Large Electron applications. They are slow to start and heavy to download on
# small boards, so hosts opt in by importing this file from their profile.
{
  home.packages = with pkgs; [
    vesktop # Custom Discord client (supports screen sharing on Wayland and Vencord plugins)
    karere # WhatsApp client (replaces wasistlos, which was removed from nixpkgs)
    obsidian # Markdown-based note-taking application
    thunderbird # Mail service
  ];
}
