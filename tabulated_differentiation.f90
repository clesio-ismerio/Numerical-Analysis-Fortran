program tabulated_differentiation
    use iso_fortran_env, only: real64
    implicit none

    integer, parameter :: n = 101
    integer :: i
    real(real64), parameter :: pi = acos(-1.0_real64)
    real(real64) :: x(n), y(n), dy(n)
    real(real64) :: exact(n), error(n)
    real(real64) :: a, b, h

    a = 0.0_real64
    b = 2.0_real64*pi
    h = (b-a)/real(n-1, real64)

    do i = 1, n
        x(i) = a + real(i-1, real64)*h
        y(i) = sin(x(i))
        exact(i) = cos(x(i))
    end do

    ! Second-order forward difference at the left boundary.
    dy(1) = (-3.0_real64*y(1) + &
              4.0_real64*y(2) - y(3)) / &
             (2.0_real64*h)

    ! Second-order central difference at interior points.
    do i = 2, n-1
        dy(i) = (y(i+1)-y(i-1))/(2.0_real64*h)
    end do

    ! Second-order backward difference at the right boundary.
    dy(n) = (3.0_real64*y(n) - &
             4.0_real64*y(n-1) + y(n-2)) / &
            (2.0_real64*h)

    error = abs(dy-exact)

    open(unit=10, file='tabulated_differentiation.dat', &
         status='replace', action='write')

    write(10,'(A)') &
        '# x function numerical_derivative exact_derivative error'

    do i = 1, n
        write(10,'(5(ES24.15,1X))') &
            x(i), y(i), dy(i), exact(i), error(i)
    end do

    close(10)

    print *, 'Tabulated-data differentiation completed.'
    print *, 'Output file: tabulated_differentiation.dat'

end program tabulated_differentiation
