program classical_runge_kutta
    use iso_fortran_env, only: real64
    implicit none

    integer :: n, nsteps
    real(real64) :: x, y, x0, y0, xf, h
    real(real64) :: k1, k2, k3, k4
    real(real64) :: y_exact, error

    x0     = 0.0_real64
    y0     = 0.5_real64
    xf     = 2.0_real64
    nsteps = 20

    h = (xf - x0)/real(nsteps, real64)

    x = x0
    y = y0

    open(unit=10, file='rk4.dat', status='replace', &
         action='write')

    write(10,'(A)') '# x numerical exact absolute_error'

    y_exact = exact_solution(x)
    error   = abs(y - y_exact)

    write(10,'(4ES24.15)') x, y, y_exact, error

    do n = 1, nsteps
        k1 = f(x,y)

        k2 = f(x + 0.5_real64*h, &
               y + 0.5_real64*h*k1)

        k3 = f(x + 0.5_real64*h, &
               y + 0.5_real64*h*k2)

        k4 = f(x + h, y + h*k3)

        y = y + h*(k1 + 2.0_real64*k2 + &
                   2.0_real64*k3 + k4)/6.0_real64

        x = x + h

        y_exact = exact_solution(x)
        error   = abs(y - y_exact)

        write(10,'(4ES24.15)') x, y, y_exact, error
    end do

    close(10)

    print '(A)', 'RK4 integration completed.'
    print '(A,ES12.4)', 'Step size: ', h
    print '(A,ES12.4)', 'Final numerical value: ', y
    print '(A,ES12.4)', 'Final exact value:     ', &
                        exact_solution(x)
    print '(A,ES12.4)', 'Final absolute error:  ', &
                        abs(y - exact_solution(x))

contains

    pure function f(x,y) result(dydx)
        real(real64), intent(in) :: x, y
        real(real64) :: dydx

        dydx = y - x*x + 1.0_real64
    end function f

    pure function exact_solution(x) result(y)
        real(real64), intent(in) :: x
        real(real64) :: y

        y = (x + 1.0_real64)**2 - 0.5_real64*exp(x)
    end function exact_solution

end program classical_runge_kutta
