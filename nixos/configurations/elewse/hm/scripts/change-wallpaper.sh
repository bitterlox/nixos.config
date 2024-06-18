WALLPAPER_DIR=$1
WALLPAPER_PATH="$(find "$WALLPAPER_DIR" -type f | grep -v ./source.txt | shuf -n 1)"

hyprctl hyprpaper unload all
hyprctl hyprpaper preload "$WALLPAPER_PATH"
hyprctl hyprpaper wallpaper eDP-1,"$WALLPAPER_PATH"

