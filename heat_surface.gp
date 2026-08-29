reset

set terminal pngcairo enhanced size 1200,800 font ",12"
set output "heat_surface.png"

set title "Transient Temperature Field" font ",16"

set xlabel "Position, x (m)"
set ylabel "Time, t (s)"
set zlabel "Temperature, T"

set xrange [0:1]
set yrange [0:2000]
set zrange [0:100]
set cbrange [0:100]

set xtics 0.2
set ytics 400
set ztics 20
set cbtics 20

set view 60,35,1.05,1.0
set xyplane at 0

unset grid
unset key

set palette rgbformulae 33,13,10

set colorbox
set cblabel "Temperature, T"

set pm3d at s
set pm3d depthorder
set pm3d interpolate 2,6

splot "heat.dat" using 1:2:3 with pm3d

unset output
