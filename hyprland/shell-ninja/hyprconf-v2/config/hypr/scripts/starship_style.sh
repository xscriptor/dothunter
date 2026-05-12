#!/usr/bin/env bash

# Change Starship style by swapping the active config symlink.

starship_dir="$HOME/.config/starship"
active_config="$HOME/.config/starship.toml"

if [[ ! -d "$starship_dir" ]]; then
    echo "Starship themes directory not found: $starship_dir"
    exit 1
fi

mapfile -t themes < <(ls -1 "$starship_dir"/starship-*.toml 2>/dev/null | xargs -n1 basename)

if [[ ${#themes[@]} -eq 0 ]]; then
    echo "No Starship themes found in $starship_dir"
    exit 1
fi

echo "=> Choose a Starship style..."
for i in "${!themes[@]}"; do
    idx=$((i + 1))
    name="${themes[$i]}"
    echo "  $idx. ${name#starship-}"
done

read -r -p "Choose: " choice

if ! [[ "$choice" =~ ^[0-9]+$ ]]; then
    echo "Invalid input."
    exit 1
fi

if (( choice < 1 || choice > ${#themes[@]} )); then
    echo "Invalid selection."
    exit 1
fi

selected="${themes[$((choice - 1))]}"
ln -sf "$starship_dir/$selected" "$active_config"
echo "-> Active Starship theme: ${selected#starship-}"
