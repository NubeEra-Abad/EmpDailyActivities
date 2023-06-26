#!/bin/bash


echo "Welcome to bash script."
echo

# checking systemt uptime
echo "><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><"
echo "The uptime of the system is: "
uptime
echo

# Memory Utilization
echo "><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><" 
echo "Memory Utilizatin"
Free -m
echo

# Disk Utilization
echo "><><><><><><><><><><><><><><><><><><><><><><><><><><><>><><><><><><><><<"
echo "Disk Utilization"
df -h	
