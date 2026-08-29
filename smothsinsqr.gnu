reset

set terminal pngcairo size 1400,1000 enhanced
set output "surface.png"

set xlabel "x"
set ylabel "y"
set zlabel "z"

set xrange [-10:10]
set yrange [-10:10]

set samples 200
set isosamples 200

set hidden3d
set pm3d depthorder

set palette defined ( \
    0 "dark-blue", \
    1 "blue", \
    2 "cyan", \
    3 "green", \
    4 "yellow", \
    5 "orange", \
    6 "red" )

unset key

set ticslevel 0
set view 60,45

splot sin(sqrt(x*x+y*y))
