while true; do

FULL=$(cat /sys/class/power_supply/BAT0/energy_full)
CHARGE=$(cat /sys/class/power_supply/BAT0/energy_now)
STATUS=$(cat /sys/class/power_supply/BAT0/status)
	
if [ -d /sys/class/power_supply/BAT0 ]; then

CHARGE=$((${CHARGE}*100/${FULL}))

	case $STATUS in
        Unknown)
          SIGN="% === AC";;
        Charging)
          SIGN="% ===+ AC";;
        Discharging)
          SIGN="% ===-";;
	esac

POWERB="BATT: ${CHARGE}${SIGN}"

else
      POWERB=$(echo AC)
fi

VOL="`amixer get Master |awk '/Front\ Left:/ {print $4}'`"

read cpu a b c previdle rest < /proc/stat
  prevtotal=$((a+b+c+previdle))
  sleep 0.5
  read cpu a b c idle rest < /proc/stat
  total=$((a+b+c+idle))
  cpu="$((100*( (total-prevtotal) - (idle-previdle) ) / (total-prevtotal) ))"


xsetroot -name "$(echo $POWERB)|RAM $(free -m | grep '^Mem' | awk '{print $3"MB"}')|CPU $cpu % $(sensors | grep 'temp1:' | cut -c16-17 | head -1)C°|VOL:$VOL|$(date +"%H:%M")" 

sleep 1s
done &
redshift &
compton -b &
xbindkeys -f .xbindkeysrc &
feh --bg-fill ~/Immagini/Wallpapers/1536398325130.png &
exec dwm 
