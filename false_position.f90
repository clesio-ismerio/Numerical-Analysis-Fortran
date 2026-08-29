program false_position_method
    use iso_fortran_env, only: real64
    implicit none

    integer, parameter :: max_iter = 100
    integer :: iteration
    real(real64), parameter :: tolerance = 1.0e-10_real64
    real(real64), parameter :: small_value = 1.0e-14_real64
    real(real64) :: a, b, c, c_old
    real(real64) :: fa, fb, fc
    real(real64) :: denominator, error

    a = 1.0_real64
    b = 2.0_real64

    fa = function_f(a)
    fb = function_f(b)

    if (fa * fb >= 0.0_real64) then
        print *,'Error: the interval does not bracket a root.'
        stop
    end if

    c_old = a

    open(unit=10, file='false_position_data.dat',status='replace', action='write')

    write(10,'(A)') '# iteration a b c f(c) error'

    print '(A)', 'False Position Method'
    print '(A)',' iter        a                   b' // &
    '                       c                  f(c)' // &
    '               error'

    do iteration = 1, max_iter

        denominator = fb - fa

        if (abs(denominator) < small_value) then
            print *, 'Error: denominator is too small.'
            stop
        end if

        c = (a * fb - b * fa) / denominator
        fc = function_f(c)
        error = abs(c - c_old)

        print '(I5,5ES20.10)',iteration, a, b, c, fc, error
        write(10,'(I6,5ES24.14)') iteration,a, b, c, fc, error

        if (abs(fc) < tolerance) exit

        if (iteration > 1 .and. error < tolerance) exit

        if (fa * fc < 0.0_real64) then
            b = c
            fb = fc
        else
            a = c
            fa = fc
        end if

        c_old = c

    end do

    close(10)

    print *
    print '(A,ES24.15)','Approximate root = ', c
    print '(A,ES24.15)','Residual         = ', abs(function_f(c))
    print '(A,I0)',    'Iterations       = ', iteration

contains

    pure real(real64) function function_f(x)
        real(real64), intent(in) :: x

        function_f = x**3 - x - 2.0_real64
    end function function_f

end program false_position_method
