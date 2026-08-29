program generate_data
implicit none

integer :: i
real :: x

open(10,file="data3.dat")

do i=0,100
    x=0.1*i
    write(10,*) x,sin(x)
end do

close(10)

end program
