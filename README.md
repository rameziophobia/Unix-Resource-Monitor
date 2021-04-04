# Installation
1. extract the zip file to any location
2. run the following bash commands  
```shell
chmod +x setup.sh
sudo ./setup.sh  
```  

## Dependencies
The setup file will install the following tools
* **cron** (for scheduling)
* **sysstat** (for cpu usage information)
* **bmon** (used to monitor network usage)
* **smartmontools** (to monitor disk health)
* **acpi** (used to get battery information)
* **lm-sensors** (used to get sensors information)

it will also move the task bash file to /usr/local/sbin and create a crontab for the script

# Approach
## setup file
The goal was to automate the installation as much as possible and to only require that we run that file to deploy the script  
the file has 3 tasks
* write to the cronfile
* move the script to the path referenced to by the cronfile
* install the dependencies
* create the folder for storing logs

## System resources monitor script
* The taken approach is to try to run scripts that grep file systems for information and then look for other tools and packages when that will be too time consuming to provide the same level of detailed info. 

## Tools rationale
installing and using mpstat (sysstat) instead of grepping top, because that allows easier retrieval of by core cpu utilization. memory usage however is grepped from top easily.

df was used rather than fdisk because it shows the free space remaining and percentage used

bmon is chosen as it shows real time network usage across the interfaces. if we want a tool that gets the aggregated network usage however this will be tackled differently.

lm-sensors was used as it covers the requirements. That is to read the different sensor temperatures and fan speeds.

acpi was used for the battery information because it provides information on whether the battery is charging or discharging, how much battery time remaining and the battery's temperature. if only the battery percentage is needed, we can grep that without installing an extra tool

## Scheduling
using cron the script will run   minutes (*/5 * * * *)    
on each run the script will append to the log in /var/log/systemInfo/logfile


# Analysis
## Ways for improvement
organize the saved log file to make it more readable, consistent and easier to automate its reading.  

The implementation can use less dependencies according to the data requirements, some tools can be replaced with manual scripting. this may be needed if the system was deployed on devices with scarce storage resources for example. 

## Performance
The CPU usage readings are done by taking 5 readings with a 1 second interval. this is not computationally intensive but takes some time. since the script is automated it should not be a concern. further analysis for the dependencies performance can be inspected manually on low ends devices using top or htop  


