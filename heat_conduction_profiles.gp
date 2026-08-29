reset

set terminal pngcairo enhanced size 1000,700
set output 'heat_profiles.png'

set title 'Transient One-Dimensional Heat Conduction'
set xlabel 'Position, x (m)'
set ylabel 'Temperature, T'

set grid
set key outside right

set xrange [0:1]
set yrange [0:100]

set style line 1 lc rgb '#E41A1C' lw 2
set style line 2 lc rgb '#377EB8' lw 2
set style line 3 lc rgb '#4DAF4A' lw 2
set style line 4 lc rgb '#984EA3' lw 2
set style line 5 lc rgb '#FF7F00' lw 2
set style line 6 lc rgb '#00A6A6' lw 2

plot for [i=0:5] 'heat.dat' every :::i::i using 1:3 \
     with lines ls (i+1) \
     title sprintf('t = %d s', i*400)

unset output


