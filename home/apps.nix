{ ... }:

# Web-app desktop entries and default applications for file types
{
  xdg.desktopEntries = {
    github = {
      name = "GitHub";
      exec = "brave https://github.com";
      icon = "github";
      terminal = false;
      categories = [ "Development" ];
    };
    youtube = {
      name = "YouTube";
      exec = "brave https://youtube.com";
      icon = "youtube";
      terminal = false;
      categories = [ "Video" ];
    };
  };

  # Default applications live in config/mimeapps.list (linked by dotfiles.nix).

  # Declare the standard user directories (~/Documents, ~/Downloads, ...) instead of relying on a stray user-dirs.dirs file
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };
}
