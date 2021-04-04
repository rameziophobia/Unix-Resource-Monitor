# num cores  
NUM_CORES=$(grep -c processor /proc/cpuinfo)
echo "num cpu cores: $NUM_CORES"

#average of CPU usage taken by doing 5 calculations with a 1 second interval in between
echo 'CPU usage averaged across 5 readings'
mpstat -P ALL 1 5 | tail -n `expr "$NUM_CORES" + "2"`

echo "\nMemory usage"
top -b | head -4 | tail -1
 
echo "\nUptime"
uptime -p

echo "\nDisk Health"
lsblk | grep disk | awk '{print $1}' | while read device ; do smartctl -H /dev/$device ; done

echo "\nProcess Count" 
ps -e | wc -l
    
echo "\nNetwork Interfaces" 
ip link show

echo "\nNetwork Usage" 
bmon -o ascii:quitafter=2 | tail -n +2 | awk '/Interfaces/,0'

echo "\nDisk Information" 
df
# human readable option -H/h
# df -h

echo "\nBattery Information"
acpi
acpi -t

# to get battery level without downloading packages (using grep)
# cat /sys/class/power_supply/BAT0/capacity

echo "\nSensors"
# to get temperatures and other sensors data
sensors
