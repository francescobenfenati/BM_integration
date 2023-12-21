#!/usr/bin/gnuplot

#set terminal pngcairo enhanced font 'Arial,12'
#set output 'plot.png'

set grid xtics ytics mytics  # draw lines for each ytics and mytics
#set ytics 5
set mytics 2           # set the spacing for the mytics
set grid               # enable the grid

set xlabel "Time since start (s)"
set ylabel "Temperature ({\260}C)"
set title "WWRS Temperatures monitoring"

# Assigning labels to the y-axis for different columns
plot file using 1:2 with points title "FPGA", \
     for [i=3:20] file using 1:i with points title sprintf("SFP %d", i-2)

pause 2
reread

