#!/usr/bin/env python3
import os
import json
import subprocess
import re
import traceback
import shlex
import datetime

CONFIG_PATH = os.path.expanduser("~/nixos-dotfiles/config/fuzzel/custom-launcher.json")
CACHE_PATH = os.path.expanduser("~/.cache/fuzzel-launcher-cache.txt")
DESKTOP_DIRS = [
    os.path.expanduser("~/.local/share/applications"),
    "/etc/profiles/per-user/ole/share/applications",
    "/run/current-system/sw/share/applications"
]

def load_config():
    try:
        with open(CONFIG_PATH, "r") as f:
            return json.load(f)
    except Exception:
        return {"aliases": {}, "defaults": [], "hidden": []}

def get_max_mtime():
    """Gets the most recent modification time of the config and desktop directories."""
    mtimes = [0]
    if os.path.exists(CONFIG_PATH):
        mtimes.append(os.path.getmtime(CONFIG_PATH))
    for d in DESKTOP_DIRS:
        if os.path.exists(d):
            mtimes.append(os.path.getmtime(d))
    return str(max(mtimes))

def get_desktop_files():
    apps = {}
    for d in DESKTOP_DIRS:
        if os.path.exists(d):
            for f in os.listdir(d):
                if f.endswith(".desktop") and f not in apps:
                    apps[f] = os.path.join(d, f)
    return apps

def parse_desktop_file(path):
    try:
        with open(path, "r", encoding="utf-8") as f:
            content = f.read()
            
        data = {}
        in_entry = False
        for line in content.splitlines():
            line = line.strip()
            if line == "[Desktop Entry]":
                in_entry = True
            elif line.startswith("["):
                in_entry = False
            elif in_entry and "=" in line:
                k, v = line.split("=", 1)
                data[k.strip()] = v.strip()
        
        if data.get("NoDisplay") == "true" or not data.get("Name") or not data.get("Exec"):
            return None
            
        return {
            "name": data["Name"],
            "exec": re.sub(r"%[fFuUikInNvV]", "", data["Exec"]).strip(),
            "icon": data.get("Icon", "application-x-executable"),
            "terminal": data.get("Terminal") == "true"
        }
    except Exception:
        return None

def main():
    try:
        with open("/tmp/launcher.log", "a") as log:
            date_str = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
            log.write(f"\n--- Launcher started at {date_str} ---\n")
    except Exception:
        pass
        
    current_mtime = get_max_mtime()
    fuzzel_input = None
    
    # 1. Try to read from cache
    if os.path.exists(CACHE_PATH):
        try:
            with open(CACHE_PATH, "r", encoding="utf-8") as f:
                content = f.read().split("\n", 1)
                # If cache is valid (mtime matches), use it
                if len(content) == 2 and content[0] == current_mtime:
                    fuzzel_input = content[1]
        except Exception:
            pass

    # 2. If no valid cache, parse everything from scratch
    if not fuzzel_input:
        config = load_config()
        aliases = config.get("aliases", {})
        icons = config.get("icons", {})
        defaults = config.get("defaults", [])
        hidden = config.get("hidden", [])
        
        config_dir = os.path.dirname(CONFIG_PATH)
        for k, v in icons.items():
            if v.startswith("~/"):
                icons[k] = os.path.expanduser(v)
            elif v.startswith("./") or v.startswith("../"):
                icons[k] = os.path.normpath(os.path.join(config_dir, v))
        
        final_list = []
        for df_id, path in get_desktop_files().items():
            app = parse_desktop_file(path)
            if app:
                app["display_name"] = aliases.get(df_id, app["name"])
                app["icon"] = icons.get(df_id, app["icon"])
                app["prio"] = 0 if df_id in defaults else (2 if df_id in hidden else 1)
                final_list.append(app)

        final_list.sort(key=lambda x: (x["prio"], x["display_name"].lower()))
        lines = [f"{a['display_name']}\t{a['exec']}\t{a['terminal']}\0icon\x1f{a['icon']}" for a in final_list]
        
        if not lines:
            print("Error: No applications found!")
            return
            
        fuzzel_input = "\n".join(lines)
        
        # Save to cache for next time
        try:
            os.makedirs(os.path.dirname(CACHE_PATH), exist_ok=True)
            with open(CACHE_PATH, "w", encoding="utf-8") as f:
                f.write(f"{current_mtime}\n{fuzzel_input}")
        except Exception:
            pass
        
    # 3. Launch Fuzzel with our generated/cached list
    try:
        res = subprocess.run(
            ["fuzzel", "--dmenu", "--with-nth=1", "--accept-nth={2}\t{3}", "--nth-delimiter=\t", "-p", "", "--placeholder", "Search…"],
            input=fuzzel_input.encode("utf-8"),
            capture_output=True,
            check=True
        )
        
        output = res.stdout.decode("utf-8").strip()
        if output:
            parts = output.split("\t")
            cmd = parts[0]
            terminal = (len(parts) > 1 and parts[1] == "True")
            
            if terminal:
                os.execvp("uwsm-app", ["uwsm-app", "--", "xdg-terminal-exec"] + shlex.split(cmd))
            else:
                os.execvp("uwsm-app", ["uwsm-app", "--"] + shlex.split(cmd))
                
    except subprocess.CalledProcessError:
        pass # User canceled fuzzel
    except Exception as e:
        with open("/tmp/launcher.log", "a") as log:
            log.write(f"CRASH: {str(e)}\n{traceback.format_exc()}")

if __name__ == "__main__":
    main()