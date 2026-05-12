#!/bin/bash

#### Advanced Hyprland Installation Script by ####
#### Shell Ninja ( https://github.com/shell-ninja ) ####

# color defination
red="\e[1;31m"
green="\e[1;32m"
yellow="\e[1;33m"
blue="\e[1;34m"
magenta="\e[1;1;35m"
cyan="\e[1;36m"
orange="\e[1;38;5;214m"
end="\e[1;0m"

display_text() {
    gum style \
        --border rounded \
        --align center \
        --width 60 \
        --margin "1" \
        --padding "1" \
'
   ___       __  ____ __      
  / _ \___  / /_/ _(_) /__ ___
 / // / _ \/ __/ _/ / / -_|_-<
/____/\___/\__/_//_/_/\__/___/
                               
'
}

clear && display_text
printf " \n \n"

###------ Startup ------###

dir="$(dirname "$(realpath "$0")")"
parent_dir="$(dirname "$dir")"
source "$parent_dir/interaction_fn.sh"

# log directory
log_dir="$parent_dir/Logs"
log="$log_dir/hyprconf-v2-$(date +%d-%m-%y).log"
mkdir -p "$log_dir"
touch "$log"

# hyprconf-v2 path inside dothunter repo
url="https://github.com/xscriptor/dothunter/archive/refs/heads/main.zip"
target_dir="$parent_dir/.cache/hyprconf-v2"
zip_path="$target_dir.zip"

echo

# Download the ZIP silently with a progress bar
curl -L "$url" -o "$zip_path"

# ---------------------- new ---------------------- #
# Extract only if download succeeded
if [[ -f "$zip_path" ]]; then
  mkdir -p "$target_dir"
  extract_paths=(
    "dothunter-main/hyprland/shell-ninja/hyprconf-v2/*"
  )

  extracted_root=""
  for pattern in "${extract_paths[@]}"; do
    if unzip -qq "$zip_path" "$pattern" -d "$target_dir" 2>/dev/null; then
      extracted_root="${pattern%/*}"
      break
    fi
  done

  if [[ -z "$extracted_root" ]]; then
    msg err "Could not extract hyprconf-v2 from the archive."
    rm -f "$zip_path"
    exit 1
  fi

  mv "$target_dir/$extracted_root/"* "$target_dir" && rmdir -p "$target_dir/$extracted_root"
  rm "$zip_path"
fi
# ---------------------- new ---------------------- #


# ---------------------- old ---------------------- #
# Clone the repository and log the output
# if [[ ! -d "$parent_dir/.cache/hyprconf-v2" ]]; then
#     msg act "Cloning hyprconf-v2 dotfiles repository..."
#     git clone --depth=1 https://github.com/shell-ninja/hyprconf-v2.git "$parent_dir/.cache/hyprconf-v2" 2>&1 | tee -a "$log" &> /dev/null
# fi
# ---------------------- old ---------------------- #

sleep 1

# if repo clonned successfully, then setting up the config
if [[ -d "$parent_dir/.cache/hyprconf-v2" ]]; then
  cd "$parent_dir/.cache/hyprconf-v2" || { msg err "Could not changed directory to $parent_dir/.cache/hyprconf-v2" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log"); exit 1; }

  if [[ ! -f "hyprconf-v2.sh" ]]; then
    msg err "hyprconf-v2.sh was not found after extraction."
    exit 1
  fi

  chmod +x hyprconf-v2.sh
  
  ./hyprconf-v2.sh || { msg err "Could not run the setup script for hyprconf-v2." 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log"); exit 1; }
fi

if [[ -f "$HOME/.config/hypr/scripts/startup.sh" ]]; then
  msg dn "Dotfiles setup was successful..." 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
else
  msg err "Could not setup dotfiles.." 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
  exit 1
fi

sleep 1 && clear
