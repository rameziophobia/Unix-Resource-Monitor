# add date function from https://serverfault.com/questions/310098/how-to-add-a-timestamp-to-bash-script-log
# configured to show UTC time
adddate() {
    while IFS= read -r line; do
        if [ -z "$line" ];
        then
            echo $line;
        else
            printf '%s %s\n' "$(date -u)" "$line";
        fi
    done
}

monitor_system() {
    # num cores  
    NUM_CORES=$(grep -c processor /proc/cpuinfo)
    echo "num cpu cores: $NUM_CORES"

    #average of CPU usage taken by doing 5 calculations with a 1 second interval in between
    echo 'CPU usage averaged across 5 readings'
    mpstat -P ALL 1 5 | tail -n `expr "$NUM_CORES" + "2"`

    echo ''
    echo "Memory usage"
    top -b | head -4 | tail -1
    
    echo ''
    echo "Uptime"
    uptime -p

    echo ''
    echo "Disk Health"
    lsblk | grep disk | awk '{print $1}' | while read device ; do smartctl -H /dev/$device ; done

    echo ''
    echo "Process Count" 
    ps -e | wc -l
        
    echo ''
    echo "Network Interfaces" 
    ip link show

    echo ''
    echo "Network Usage" 
    bmon -o ascii:quitafter=2 | tail -n +2 | awk '/Interfaces/,0'

    echo ''
    echo "Disk Information" 
    df
    # human readable option -H/h
    # df -h

    echo ''
    echo "Battery Information"
    acpi
    acpi -t

    # to get battery level without downloading packages (using grep)
    # cat /sys/class/power_supply/BAT0/capacity

    echo ''
    echo "Sensors"
    # to get temperatures and other sensors data
    sensors
}

monitor_system | adddate
