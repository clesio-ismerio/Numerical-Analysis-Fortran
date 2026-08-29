program bisection_method
    use iso_fortran_env, only: real64
    implicit none

    integer, parameter :: max_iter = 100
    integer :: iteration
    real(real64), parameter :: tolerance = 1.0e-10_real64
    real(real64) :: a, b, c
    real(real64) :: fa, fb, fc
    real(real64) :: error

    a = 1.0_real64
    b = 2.0_real64

    fa = function_f(a)
    fb = function_f(b)

    if (fa * fb >= 0.0_real64) then
        print *,'Error: the interval does not bracket a root.'
        stop
    end if

    open(unit=10,file='bisection_data.dat', status='replace', action='write')

    write(10,'(A)') '# iteration a b c f(c) error'

    print '(A)', 'Bisection Method'
    print '(A)', ' iter          a  b' // &
                 '               c f(c)' // &
                 '               error'

    do iteration = 1, max_iter

        c = 0.5_real64 * (a + b)
        fc = function_f(c)
        error = 0.5_real64 * abs(b - a)

        print '(I5,5ES20.10)', iteration, a, b, c, fc, error
        write(10,'(I6,5ES24.14)') iteration, a, b, c, fc, error

        if (abs(fc) < tolerance .or. error < tolerance) exit

        if (fa * fc < 0.0_real64) then
            b = c
            fb = fc
        else
            a = c
            fa = fc
        end if

    end do

    close(10)

    print *
    print '(A,ES24.15)','Approximate root = ', c
    print '(A,ES24.15)','Residual         = ', abs(function_f(c))
    print '(A,I0)','Iterations       = ', iteration

contains

    pure real(real64) function function_f(x)
        real(real64), intent(in) :: x

        function_f = x**3 - x - 2.0_real64
    end function function_f

end program bisection_method
