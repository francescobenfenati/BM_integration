#!/bin/bash

# Function to display script usage/help
display_help() {
    echo "Usage: ./wwrs_tempmon.sh <IP_WWRS> <filename>"
    echo "Description: This script logs SFP and FPGA temperature data on the file,"
    echo "             then after 1 minute launches a Gnuplot script"
    echo "             to plot the data. Press Ctrl+C to stop both processes."
}

# Check if the script is invoked with the help option
if [[ $# -eq 0 || "$1" == "--help" || "$1" == "-h" || "$1" == "--h" ]]; then
    display_help  # Display help message
    exit 0
fi



ip=$1
name=$2
filename="${name}.txt"

# Start the data-producing script in the background
./templog.sh $1 $2 &
# Save the PID of the data-producing script
data_pid=$!

# Wait for 1 minute
sleep 60

# Launch the Gnuplot script in the background
gnuplot -e "file='${filename}'" wwrs_templog.gp &
gnuplot_pid=$!

# Function to clean up and exit
cleanup() {
    echo "Stopping processes..."
    # Save the plot before terminating Gnuplot
    echo "set terminal pngcairo; set output '${name}.png'; set grid xtics ytics mytics; set mytics 2; set grid; set xlabel 'Time since start (s)'; set ylabel 'Temperature (°C)'; set title 'WWRS Temperatures monitoring'; plot '${filename}' using 1:2 with points title 'FPGA', \
     for [i=3:20] '${filename}' using 1:i with points title sprintf('SFP %d', i-2)" | gnuplot
    #pkill -P $$  # Kills all child processes of this script (data-producing script and Gnuplot)
    kill $data_pid $gnuplot_pid
    exit 0
}

# Trap Ctrl+C and execute cleanup function
trap cleanup INT

# Wait for Ctrl+C to terminate processes
echo "Press Ctrl+C to stop the processes."
wait
