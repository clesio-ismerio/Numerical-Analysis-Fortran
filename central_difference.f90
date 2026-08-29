program central_difference
    use iso_fortran_env, only: real64
    implicit none

    integer, parameter :: n = 101
    integer :: i
    real(real64), parameter :: pi = acos(-1.0_real64)
    real(real64) :: a, b, h, x
    real(real64) :: numerical_first
    real(real64) :: numerical_second
    real(real64) :: exact_first
    real(real64) :: exact_second
    real(real64) :: error_first
    real(real64) :: error_second

    a = 0.0_real64
    b = 2.0_real64*pi
    h = (b-a)/real(n-1, real64)

    open(unit=10, file='central_difference.dat', &
         status='replace', action='write')

    write(10,'(A)') &
        '# x numerical_df exact_df error_df ' // &
        'numerical_d2f exact_d2f error_d2f'

    do i = 1, n-2
        x = a + real(i, real64)*h

        numerical_first = &
            (f(x+h)-f(x-h))/(2.0_real64*h)

        numerical_second = &
            (f(x+h)-2.0_real64*f(x)+f(x-h))/(h*h)

        exact_first = df_exact(x)
        exact_second = d2f_exact(x)

        error_first = abs(numerical_first-exact_first)
        error_second = abs(numerical_second-exact_second)

        write(10,'(7(ES24.15,1X))') x, &
            numerical_first, exact_first, error_first, &
            numerical_second, exact_second, error_second
    end do

    close(10)

    print *, 'Central-difference calculation completed.'
    print *, 'Output file: central_difference.dat'
    print *, 'Step size h = ', h

contains

    pure function f(x) result(value)
        real(real64), intent(in) :: x
        real(real64) :: value

        value = sin(x)
    end function f

    pure function df_exact(x) result(value)
        real(real64), intent(in) :: x
        real(real64) :: value

        value = cos(x)
    end function df_exact

    pure function d2f_exact(x) result(value)
        real(real64), intent(in) :: x
        real(real64) :: value

        value = -sin(x)
    end function d2f_exact

end program central_difference
