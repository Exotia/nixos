{ pkgs, ... }:

# Cursor, GTK, Qt and dconf dark-mode preferences
{
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };

  # --- Theming (Force Dark Mode) ---
  # This ensures that GTK, Qt, and browser-based apps detect a system-wide dark mode preference.
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
  };

  # Tells GNOME/GTK apps (via dconf) that you prefer dark mode. 
  # This is what browsers like Brave/Chromium look for.
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  # Ensures Qt applications (like VLC or some tools) also use the GTK theme for consistency
  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "adwaita-dark";
  };
}
