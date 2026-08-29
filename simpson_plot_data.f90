program simpson_plot_data
    use, intrinsic :: iso_fortran_env, only: real64
    implicit none

    integer, parameter :: number_of_points = 201

    integer :: i
    integer :: unit_function
    integer :: unit_parabola

    real(real64) :: a
    real(real64) :: b
    real(real64) :: midpoint
    real(real64) :: x
    real(real64) :: y
    real(real64) :: polynomial

    a = 0.0_real64
    b = 1.0_real64
    midpoint = 0.5_real64 * (a+b)

    open(newunit=unit_function, file='function.dat', &
         status='replace', action='write')

    open(newunit=unit_parabola, file='simpson_parabola.dat', &
         status='replace', action='write')

    do i = 0, number_of_points - 1
        x = a + real(i,real64)*(b-a) / &
            real(number_of_points-1,real64)

        y = f(x)

        polynomial = lagrange_quadratic( &
            x, a, midpoint, b, f(a), f(midpoint), f(b))

        write(unit_function,'(2ES24.14)') x, y
        write(unit_parabola,'(2ES24.14)') x, polynomial
    end do

    close(unit_function)
    close(unit_parabola)

    write(*,'(A)') 'Files function.dat and simpson_parabola.dat created.'

contains

    function f(x) result(y)
        real(real64), intent(in) :: x
        real(real64) :: y

        y = exp(-x*x)
    end function f

    function lagrange_quadratic(x, x0, x1, x2, &
                                y0, y1, y2) result(p)
        real(real64), intent(in) :: x
        real(real64), intent(in) :: x0
        real(real64), intent(in) :: x1
        real(real64), intent(in) :: x2
        real(real64), intent(in) :: y0
        real(real64), intent(in) :: y1
        real(real64), intent(in) :: y2

        real(real64) :: l0
        real(real64) :: l1
        real(real64) :: l2
        real(real64) :: p

        l0 = ((x-x1)*(x-x2)) / ((x0-x1)*(x0-x2))
        l1 = ((x-x0)*(x-x2)) / ((x1-x0)*(x1-x2))
        l2 = ((x-x0)*(x-x1)) / ((x2-x0)*(x2-x1))

        p = y0*l0 + y1*l1 + y2*l2
    end function lagrange_quadratic

end program simpson_plot_data
