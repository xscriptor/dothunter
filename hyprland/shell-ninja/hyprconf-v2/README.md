<h1 align="center">Hyprconf-v2</h1>

<p align="center">
    <em>
	Custom version of <a href="https://github.com/shell-ninja">Shell Ninja</a> dot files adding <a href="https://github.com/xscriptor">X</a> theme.
    </em>
</p>

<h2 align="center">Features</h2>
<ul>
	<li>Preconfigured Hyprland layout with themes and wallpapers.</li>
	<li>Integrated theme switching across Waybar, Rofi, Kitty, Wlogout, and SwayNC.</li>
	<li>Optional Starship themes with a default selection.</li>
	<li>Helper scripts for wallpapers, power menu, and utilities.</li>
</ul>

<h2 align="center">Requirements</h2>
<ul>
	<li>Hyprland and Wayland environment.</li>
	<li>Common tools: rofi, kitty, waybar, wlogout, swaync, jq, curl.</li>
	<li>Optional: xsettingsd, kvantum, starship.</li>
</ul>

<h2 align="center">Download</h2>
<p align="center">
	Clone the repository and enter the config directory:
</p>
<pre>
git clone https://github.com/xscriptor/dothunter.git
cd dothunter/hyprland/shell-ninja/hyprconf-v2
</pre>

<h2 align="center">Install</h2>
<p align="center">
	Run the installer script. It will back up existing configs before applying the new setup.
</p>
<pre>
chmod +x hyprconf-v2.sh
./hyprconf-v2.sh
</pre>

<h2 align="center">Cheatsheet</h2>
<p align="center">
	See the keybinding cheatsheet at <code><a href="./CHEATSHEET.md">CHEATSHEET.md</a> </code>.
</p>

<h2 align="center">Notes</h2>
<ul>
	<li>After installation, log out and log back in to apply all changes.</li>
	<li>Theme selection is stored in <code>~/.config/hypr/.cache/.theme</code>.</li>
</ul>
