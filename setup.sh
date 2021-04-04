echo 'creating directory for logs'
sudo mkdir /var/log/systemInfo

echo 'moving task file to usr local directory'
chmod +x task.sh
sudo mv ./task.sh /usr/local/sbin/task.sh

echo 'creating the crontab file'
sudo echo '*/5 * * * * root /usr/local/sbin/task.sh >> /var/log/systemInfo/logfile' >> /etc/crontab

echo 'installing required tools'
sudo apt-get update
sudo apt-get upgrade
# for scheduling
sudo apt-get install cron
# makes getting cpu usage info easier and allows per core information
sudo apt-get install sysstat
# used to monitor network usage
sudo apt-get install --assume-yes bmon
# installs systemctl, a tool to monitor disk health
sudo apt install --assume-yes smartmontools
systremctl enable smartd
# used to get battery information
sudo apt-get install acpi
# used to get sensors information
sudo apt-get install lm-sensors
sudo sensors-detect
