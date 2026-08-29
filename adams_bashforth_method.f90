program adams_bashforth_method
    use iso_fortran_env, only: real64
    implicit none

    integer :: n, nsteps
    real(real64) :: x0, y0, xf, h
    real(real64) :: fn, fn1, fn2, fn3
    real(real64) :: y_exact, error
    real(real64), allocatable :: x(:), y(:)

    x0     = 0.0_real64
    y0     = 0.5_real64
    xf     = 2.0_real64
    nsteps = 20

    if (nsteps < 3) then
        error stop 'AB4 requires at least three startup steps.'
    end if

    allocate(x(0:nsteps))
    allocate(y(0:nsteps))

    h = (xf - x0)/real(nsteps, real64)

    x(0) = x0
    y(0) = y0

    ! Generate y(1), y(2), and y(3) using RK4.
    do n = 0, 2
        x(n+1) = x(n) + h
        y(n+1) = rk4_step(x(n), y(n), h)
    end do

    ! Apply the fourth-order Adams-Bashforth method.
    do n = 3, nsteps - 1
        fn  = f(x(n),   y(n))
        fn1 = f(x(n-1), y(n-1))
        fn2 = f(x(n-2), y(n-2))
        fn3 = f(x(n-3), y(n-3))

        y(n+1) = y(n) + h*( &
            55.0_real64*fn  - &
            59.0_real64*fn1 + &
            37.0_real64*fn2 - &
             9.0_real64*fn3)/24.0_real64

        x(n+1) = x(n) + h
    end do

    open(unit=10, file='adams_bashforth.dat', &
         status='replace', action='write')

    write(10,'(A)') '# x numerical exact absolute_error'

    do n = 0, nsteps
        y_exact = exact_solution(x(n))
        error   = abs(y(n) - y_exact)

        write(10,'(4ES24.15)') x(n), y(n), y_exact, error
    end do

    close(10)

    print '(A)', 'Adams-Bashforth integration completed.'
    print '(A,ES12.4)', 'Step size: ', h
    print '(A,ES12.4)', 'Final numerical value: ', y(nsteps)
    print '(A,ES12.4)', 'Final exact value:     ', &
                        exact_solution(x(nsteps))
    print '(A,ES12.4)', 'Final absolute error:  ', &
        abs(y(nsteps) - exact_solution(x(nsteps)))

    deallocate(x)
    deallocate(y)

contains

    pure function rk4_step(x,y,h) result(y_new)
        real(real64), intent(in) :: x, y, h
        real(real64) :: y_new
        real(real64) :: k1, k2, k3, k4

        k1 = f(x,y)

        k2 = f(x + 0.5_real64*h, &
               y + 0.5_real64*h*k1)

        k3 = f(x + 0.5_real64*h, &
               y + 0.5_real64*h*k2)

        k4 = f(x + h, y + h*k3)

        y_new = y + h*(k1 + 2.0_real64*k2 + &
            2.0_real64*k3 + k4)/6.0_real64
    end function rk4_step

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

end program adams_bashforth_method
