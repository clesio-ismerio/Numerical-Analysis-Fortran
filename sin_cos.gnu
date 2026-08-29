set grid
set xlabel "x"
set ylabel "y"
set title "Sin and Cos Example"
plot sin(x) with lines lw 2 title "sin(x)", \
     cos(x) with points pt 7 title "cos(x)"
