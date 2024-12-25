
bat=/sys/class/power_supply/BAT1/
per="$(cat "$bat/capacity")"

icon() {

[ "$(cat "$bat/status")" = Charging ] && echo "󰂄" && exit

if [ "$per" -gt "90" ]; then
	icon="󰁹"
elif [ "$per" -gt "80" ]; then
	icon="󰂂"
elif [ "$per" -gt "70" ]; then
	icon="󰂁"
elif [ "$per" -gt "60" ]; then
	icon="󰂀"
elif [ "$per" -gt "50" ]; then
	icon="󰁿"
elif [ "$per" -gt "40" ]; then
	icon="󰁾"
elif [ "$per" -gt "30" ]; then
	icon="󰁽"
elif [ "$per" -gt "20" ]; then
	icon="󰁼"
elif [ "$per" -gt "10" ]; then
	icon="󰁻"
	notify-send -u critical "Battery Low" "Connect Charger" -e 60000
elif [ "$per" -gt "0" ]; then
	icon="󰁺"
	notify-send -u critical "Battery Very Low" "Connect Charger" -e 60000
else
        echo "󰂎" && exit
fi
echo "$icon"
}

percent() {
echo "$per"
}

[ "$1" = "icon" ] && icon && exit
[ "$1" = "percent" ] && percent && exit
exit