#!/bin/bash

# Advanced Hyprland Installation Script by
# Shell Ninja ( https://github.com/shell-ninja )
# Moded by Xscriptor for DotHunter

# color defination
red="\e[1;31m"
green="\e[1;32m"
yellow="\e[1;33m"
blue="\e[1;34m"
megenta="\e[1;1;35m"
cyan="\e[1;36m"
orange="\x1b[38;5;214m"
end="\e[1;0m"

if command -v gum &> /dev/null; then

display_text() {
    gum style \
        --border rounded \
        --align center \
        --width 100 \
        --margin "1" \
        --padding "1" \
'
X   __  __                                  ____    _    _____ 
   / / / /_  ______  ______________  ____  / __/   | |  / /__ \
  / /_/ / / / / __ \/ ___/ ___/ __ \/ __ \/ /______| | / /__/ /
 / __  / /_/ / /_/ / /  / /__/ /_/ / / / / __/_____/ |/ // __/ 
/_/ /_/\__, / .___/_/   \___/\____/_/ /_/_/        |___//____/ 
      /____/_/                                                 
'
}

else
display_text() {
    cat << "EOF"
X   __  __                                  ____    _    _____ 
   / / / /_  ______  ______________  ____  / __/   | |  / /__ \
  / /_/ / / / / __ \/ ___/ ___/ __ \/ __ \/ /______| | / /__/ /
 / __  / /_/ / /_/ / /  / /__/ /_/ / / / / __/_____/ |/ // __/ 
/_/ /_/\__, / .___/_/   \___/\____/_/ /_/_/        |___//____/ 
      /____/_/                                                 

EOF
}
fi

clear && display_text
printf " \n \n"

###------ Startup ------###

# finding the presend directory and log file
# Use the script directory to keep relative paths stable.
dir="$(dirname "$(realpath "$0")")"
# log directory
log_dir="$dir/Logs"
log="$dir/Logs/hyprconf-v2.log"
mkdir -p "$log_dir"
touch "$log"

# message prompts
msg() {
    local actn=$1
    local msg=$2

    case $actn in
        act)
            printf "${green}=>${end} $msg\n"
            ;;
        ask)
            printf "${orange}??${end} $msg\n"
            ;;
        dn)
            printf "${cyan}::${end} $msg\n\n"
            ;;
        att)
            printf "${yellow}!!${end} $msg\n"
            ;;
        nt)
            printf "${blue}\$\$${end} $msg\n"
            ;;
        skp)
            printf "${magenta}[ SKIP ]${end} $msg\n"
            ;;
        err)
            printf "${red}>< Ohh sheet! an error..${end}\n   $msg\n"
            sleep 1
            ;;
        *)
            printf "$msg\n"
            ;;
    esac
}

# Need to install 2 packages (gum and parallel)________________________
installable_pkgs=(
    gum
    parallel
)

install() {
    local pkg=${1}

    if command -v pacman &> /dev/null; then
        sudo pacman -S --noconfirm $1
    elif command -v dnf &> /dev/null; then
        sudo dnf install $1 -y
    elif command -v zypper &> /dev/null; then
        sudo zypper in $1 -y
    fi
}

for pkg in "${installable_pkgs[@]}"; do
    if sudo pacman -Q "$pkg" &> /dev/null || rpm -q "$pkg" &> /dev/null || sudo zypper se -i "$pkg" &> /dev/null; then
        msg dn "Everything is fine. Proceeding to the next step"
    else
        msg att "Need to install $pkg. It's important."
        install "$pkg" &> /dev/null
    fi
done

sleep 2 && clear


# Directories ----------------------------
hypr_dir="$HOME/.config/hypr"
scripts_dir="$hypr_dir/scripts"
fonts_dir="$HOME/.local/share/fonts"

msg act "Now setting up the pre installed Hyprland configuration..."sleep 1

mkdir -p ~/.config
dirs=(
    btop
    starship
    gtk-3.0
    gtk-4.0
    hypr
    kitty
    Kvantum
    menus
    nvim
    nwg-look
    qt5ct
    qt6ct
    rofi
    satty
    swaync
    waybar
    wlogout
    xfce4
    xsettingsd
    yazi
    dolphinrc
    kwalletmanagerrc
    kwallertc
)


# if some main directories exists, backing them up.
if [[ -d "$HOME/.config/backup_hyprconfV2-${USER}" ]]; then
    msg att "a backup_hyprconfV2-${USER} directory was there. Archiving it..."
    cd "$HOME/.config"
    mkdir -p "archive_hyprconfV2-${USER}"
    tar -czf "archive_hyprconfV2-${USER}/backup_hyprconfV2-$(date +%d-%m-%Y_%I-%M-%p)-${USER}.tar.gz" "backup_hyprconfV2-${USER}" &> /dev/null
    rm -rf "backup_hyprconfV2-${USER}"
    msg dn "backup_hyprconfV2-${USER} was archived inside archive_hyprconfV2-${USER} directory..." && sleep 1
fi

for confs in "${dirs[@]}"; do
    mkdir -p "$HOME/.config/backup_hyprconfV2-${USER}"
    dir_path="$HOME/.config/$confs"
    if [[ -d "$dir_path" || -f "$dir_path" ]]; then
        mv "$dir_path" "$HOME/.config/backup_hyprconfV2-${USER}/" 2>&1 | tee -a "$log"
    fi
done

[[ -d "$HOME/.config/backup_hyprconfV2-${USER}/hypr" ]] && msg dn "Everything has been backuped in $HOME/.config/backup_hyprconfV2-${USER}..."

sleep 1


####################################################################

#_____ if OpenBangla Keyboard is installed
keyboard_path="/usr/share/openbangla-keyboard"

if [[ -d "$keyboard_path" ]]; then
    msg act "Setting up OpenBangla-Keyboard..."

    # Add fcitx5 environment variables to /etc/environment if not already present
    if ! grep -q "GTK_IM_MODULE=fcitx" /etc/environment; then
        printf "\nGTK_IM_MODULE=fcitx\n" | sudo tee -a /etc/environment 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log") &> /dev/null
    fi

    if ! grep -q "QT_IM_MODULE=fcitx" /etc/environment; then
        printf "QT_IM_MODULE=fcitx\n" | sudo tee -a /etc/environment 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log") &> /dev/null
    fi

    if ! grep -q "XMODIFIERS=@im=fcitx" /etc/environment; then
        printf "XMODIFIERS=@im=fcitx\n" | sudo tee -a /etc/environment 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log") &> /dev/null
    fi

fi

####################################################################


#_____ for virtual machine
# Check if the configuration is in a virtual box
if hostnamectl | grep -q 'Chassis: vm'; then
    msg att "You are using this script in a Virtual Machine..."
    msg act "Setting up things for you..." 
    sed -i '/env = WLR_NO_HARDWARE_CURSORS,1/s/^#//' "$dir/config/hypr/confs/env.conf"
    sed -i '/env = WLR_RENDERER_ALLOW_SOFTWARE,1/s/^#//' "$dir/config/hypr/confs/env.conf"
    mv "$dir/config/hypr/confs/monitor.conf" "$dir/config/hypr/confs/monitor-back.conf"
    cp "$dir/config/hypr/confs/monitor-vbox.conf" "$dir/config/hypr/confs/monitor.conf"
fi


#_____ for nvidia gpu. I don't know if it's gonna work or not. Because I don't have any gpu.
# uncommenting WLR_NO_HARDWARE_CURSORS if nvidia is detected
if lspci -k | grep -A 2 -E "(VGA|3D)" | grep -iq nvidia; then
  msg act "Nvidia GPU detected. Setting up proper env's" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log") || true
    sed -i '/env = WLR_NO_HARDWARE_CURSORS,1/s/^#//' "$dir/config/hypr/confs/env.conf"
    sed -i '/env = LIBVA_DRIVER_NAME,nvidia/s/^#//' "$dir/config/hypr/confs/env.conf"
    sed -i '/env = __GLX_VENDOR_LIBRARY_NAME,nvidia/s/^# //' "$dir/config/hypr/confs/env.conf"
fi

sleep 1


#####################################################
# cloning the dotfiles repository into ~/.config/hypr
#####################################################

mkdir -p "$HOME/.config"
for item in "$dir/config"/*; do
    if [[ "$(basename "$item")" == "fish" ]]; then
        continue
    fi
    cp -r "$item" "$HOME/.config/"
done
sleep 0.5

msg act "Installing xfetch..."
curl -fsSL https://raw.githubusercontent.com/xscriptor/xfetch/main/install.sh | bash 2>&1 | tee -a "$log"

rc_file=""
if [[ -n "$SHELL" ]]; then
    case "$SHELL" in
        */zsh)
            rc_file="$HOME/.zshrc"
            ;;
        */bash)
            rc_file="$HOME/.bashrc"
            ;;
    esac
fi

if [[ -z "$rc_file" ]]; then
    if [[ -f "$HOME/.zshrc" ]]; then
        rc_file="$HOME/.zshrc"
    elif [[ -f "$HOME/.bashrc" ]]; then
        rc_file="$HOME/.bashrc"
    else
        rc_file="$HOME/.bashrc"
    fi
fi

if ! grep -qx "xfetch" "$rc_file"; then
    printf "\nxfetch\n" >> "$rc_file"
fi


sleep 1

if [[ -d "$scripts_dir" ]]; then
    # make all the scripts executable...
    chmod +x "$scripts_dir"/* 2>&1 | tee -a "$log"
    if [[ -d "$HOME/.config/fish/functions" ]]; then
        chmod +x "$HOME/.config/fish/functions"/* 2>&1 | tee -a "$log"
    fi
    msg dn "All the necessary scripts have been executable..."
    sleep 1
else
    msg err "Could not find necessary scripts.."
fi

# Install Fonts
msg act "Installing some fonts..."
if [[ ! -d "$fonts_dir" ]]; then
	mkdir -p "$fonts_dir"
fi

cp -r "$dir/extras/fonts" "$fonts_dir"
msg act "Updating font cache..."
sudo fc-cache -fv 2>&1 | tee -a "$log" &> /dev/null

# Setup dolphin files
if [[ -f "$HOME/.local/state/dolphinstaterc" ]]; then
    mv "$HOME/.local/state/dolphinstaterc" "$HOME/.local/state/dolphinstaterc.back"
    cp "$dir/extras/dolphinstaterc" "$HOME/.local/state/"
fi


wayland_session_dir=/usr/share/wayland-sessions
if [ -d "$wayland_session_dir" ]; then
    msg att "$wayland_session_dir found..."
else
    msg att "$wayland_session_dir NOT found, creating..."
    sudo mkdir $wayland_session_dir 2>&1 | tee -a "$log"
    sudo cp "$dir/extras/hyprland.desktop" /usr/share/wayland-sessions/ 2>&1 | tee -a "$log"
fi


############################################################
# setting theme
###########################################################
# setting up the waybar
ln -sf "$HOME/.config/waybar/configs/full-top" "$HOME/.config/waybar/config"
ln -sf "$HOME/.config/waybar/style/full-top.css" "$HOME/.config/waybar/style.css"

themeFile="$HOME/.config/hypr/.cache/.theme"
mkdir -p "$(dirname "$themeFile")"
if [[ ! -f "$themeFile" ]]; then
    echo "Catppuccin" > "$themeFile"
fi

theme="$(cat "$themeFile")"

if [[ ! -f "$HOME/.config/hypr/confs/themes/${theme}.conf" ]]; then
    theme="Catppuccin"
    echo "$theme" > "$themeFile"
fi

"$HOME/.config/hypr/scripts/Wallpaper.sh" &> /dev/null

# Function to safely symlink
safe_link() {
    local source_file="$1"
    local target_link="$2"
    if [[ -f "$source_file" ]]; then
        mkdir -p "$(dirname "$target_link")"
        ln -sf "$source_file" "$target_link"
    fi
}

# Apply UI themes (includes X theme when selected)
safe_link "$HOME/.config/hypr/confs/themes/${theme}.conf" "$HOME/.config/hypr/confs/decoration.conf"
safe_link "$HOME/.config/rofi/colors/${theme}.rasi" "$HOME/.config/rofi/themes/rofi-colors.rasi"
safe_link "$HOME/.config/kitty/colors/${theme}.conf" "$HOME/.config/kitty/theme.conf"
safe_link "$HOME/.config/waybar/colors/${theme}.css" "$HOME/.config/waybar/style/theme.css"
safe_link "$HOME/.config/wlogout/colors/${theme}.css" "$HOME/.config/wlogout/colors.css"

starshipTheme="starship-simple.toml"
case "$theme" in
    Gruvbox)
        starshipTheme="starship-gruvbox.toml"
        ;;
    TokyoNight)
        starshipTheme="starship-tokyonight.toml"
        ;;
    X)
        starshipTheme="starship-x.toml"
        ;;
esac

safe_link "$HOME/.config/starship/$starshipTheme" "$HOME/.config/starship.toml"

if command -v swaync &>/dev/null; then
    safe_link "$HOME/.config/swaync/colors/${theme}.css" "$HOME/.config/swaync/colors.css"
fi

# Apply new colors dynamically to Kitty
if pids=$(pidof kitty 2>/dev/null) && [[ -n "$pids" ]]; then
    kill -SIGUSR1 $pids
fi

# Setting VS Code / Kvantum theme based on selection
kvTheme=""
vscodeTheme=""

case "$theme" in
    Catppuccin)
        vscodeTheme="Catppuccin Mocha"
        kvTheme="Catppuccin"
        ;;
    Everforest)
        vscodeTheme="Everforest Dark"
        kvTheme="Everforest"
        ;;
    Gruvbox)
        vscodeTheme="Gruvbox Dark Soft"
        kvTheme="Gruvbox"
        ;;
    Neon)
        vscodeTheme="Neon Dark Theme"
        kvTheme="Nordic-Darker"
        ;;
    TokyoNight)
        vscodeTheme="Tokyo Storm Gogh"
        kvTheme="TokyoNight"
        ;;
    X)
        vscodeTheme="X"
        kvTheme="X"
        ;;
    *)
        kvTheme=""
        vscodeTheme=""
        ;;
esac

if [[ -n "$kvTheme" && -n "$vscodeTheme" ]]; then
    settingsFile="$HOME/.config/Code/User/settings.json"
    if [[ -f "$settingsFile" ]]; then
        sed -i -E 's/("workbench.colorTheme"[ \t]*:[ \t]*)"[^"]+"/\1"'"$vscodeTheme"'"/' "$settingsFile"
    fi

    crudini --set "$HOME/.config/Kvantum/kvantum.kvconfig" General theme "$kvTheme"
    crudini --set ~/.config/kdeglobals Icons Theme "Tela-circle-dracula"
fi

"$HOME/.config/hypr/scripts/wallcache.sh" &> /dev/null
"$HOME/.config/hypr/scripts/Refresh.sh" &> /dev/null

#############################################
# setting lock screen
#############################################
ln -sf "$HOME/.config/hypr/lockscreens/hyprlock-1.conf" "$HOME/.config/hypr/hyprlock.conf"

msg dn "Script execution was successful! Now logout and log back in and enjoy your hyprland..." && sleep 1

# === ___ Script Ends Here ___ === #
