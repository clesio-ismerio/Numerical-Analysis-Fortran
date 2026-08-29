reset

set terminal pngcairo enhanced size 1000,700
set output 'heat_profiles.png'

set title 'Transient One-Dimensional Heat Conduction'
set xlabel 'Position, x (m)'
set ylabel 'Temperature, T'
set grid
set key outside right
set xrange [0:1]

plot for [index=0:*] 'heat.dat' index index using 1:3 \
     with lines linewidth 2 \
     title sprintf('Profile %d', index)

set terminal pngcairo enhanced size 1000,700
set output 'heat_map.png'

set title 'Temperature Distribution'
set xlabel 'Position, x (m)'
set ylabel 'Time, t (s)'
set cblabel 'Temperature'
set view map
set pm3d map
unset key

splot 'heat.dat' using 1:2:3

unset output
