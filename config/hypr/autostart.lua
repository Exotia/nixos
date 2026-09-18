-- Programs started once with the session

hl.on("hyprland.start", function()
	-- Systemd & session setup
	hl.exec_cmd("systemctl --user import-environment $(env | cut -d'=' -f 1)")
	hl.exec_cmd("dbus-update-activation-environment --systemd --all")
	hl.exec_cmd("nix-theme-update")

	-- Core services
	hl.exec_cmd("waybar")
	hl.exec_cmd("uwsm-app -- hypridle")
	hl.exec_cmd("mako")
	hl.exec_cmd("swayosd-server")
	hl.exec_cmd("lxqt-policykit-agent")
	hl.exec_cmd("nm-applet --indicator")
	hl.exec_cmd("blueman-applet")

	-- Background
	hl.exec_cmd("mkdir -p ~/.cache")
	hl.exec_cmd(
		"[ -L ~/.cache/current-background ] || ln -sf ~/.config/theme/backgrounds/0-swirl-buck.jpg ~/.cache/current-background"
	)
	hl.exec_cmd("swaybg -i ~/.cache/current-background -m fill")

	-- Applications
	--hl.exec_cmd("vesktop")
	hl.exec_cmd("uwsm-app -- keepassxc")
end)
