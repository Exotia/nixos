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

  # Set default applications for specific file types (MIME types)
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "video/mp4" = [ "vlc.desktop" ];
      "video/mpeg" = [ "vlc.desktop" ];
      "video/ogg" = [ "vlc.desktop" ];
      "video/quicktime" = [ "vlc.desktop" ];
      "video/webm" = [ "vlc.desktop" ];
      "video/x-matroska" = [ "vlc.desktop" ];
      "video/x-ms-wmv" = [ "vlc.desktop" ];
      "video/x-flv" = [ "vlc.desktop" ];
      "video/x-msvideo" = [ "vlc.desktop" ];
      "video/avi" = [ "vlc.desktop" ];
    };
  };
}
