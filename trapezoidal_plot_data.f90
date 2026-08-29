program trapezoidal_plot_data
    use, intrinsic :: iso_fortran_env, only: real64
    implicit none

    integer, parameter :: number_of_points = 201

    integer :: i
    integer :: unit_function
    integer :: unit_trapezoid

    real(real64) :: a
    real(real64) :: b
    real(real64) :: x
    real(real64) :: y
    real(real64) :: y_line

    a = 0.0_real64
    b = 1.0_real64

    open(newunit=unit_function, file='function.dat', &
         status='replace', action='write')

    open(newunit=unit_trapezoid, file='trapezoid.dat', &
         status='replace', action='write')

    do i = 0, number_of_points - 1
        x = a + real(i, real64) * (b-a) / &
            real(number_of_points-1, real64)

        y = f(x)

        y_line = f(a) + (f(b)-f(a)) * (x-a) / (b-a)

        write(unit_function,'(2ES24.14)') x, y
        write(unit_trapezoid,'(2ES24.14)') x, y_line
    end do

    close(unit_function)
    close(unit_trapezoid)

    write(*,'(A)') 'Files function.dat and trapezoid.dat created.'

contains

    function f(x) result(y)
        real(real64), intent(in) :: x
        real(real64) :: y

        y = exp(-x*x)
    end function f

end program trapezoidal_plot_data
