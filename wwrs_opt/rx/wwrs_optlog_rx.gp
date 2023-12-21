#!/usr/bin/gnuplot


set grid xtics ytics mytics  # draw lines for each ytics and mytics
#set ytics 5
set mytics 2           # set the spacing for the mytics
set grid               # enable the grid

set xlabel "Time since start (s)"
set ylabel "RX power (dBm)"
set title "WWRS RX power monitoring"

# Assigning labels to the y-axis for different columns
plot for [i=2:19] file using 1:i with points title sprintf("SFP %d", i-2)

pause 2
reread

