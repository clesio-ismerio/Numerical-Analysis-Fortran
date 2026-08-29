program forward_difference
    use iso_fortran_env, only: real64
    implicit none

    integer, parameter :: n = 101
    integer :: i
    real(real64), parameter :: pi = acos(-1.0_real64)
    real(real64) :: a, b, h, x
    real(real64) :: numerical_derivative
    real(real64) :: exact_derivative
    real(real64) :: absolute_error

    a = 0.0_real64
    b = 2.0_real64*pi
    h = (b-a)/real(n-1, real64)

    open(unit=10, file='forward_difference.dat', &
         status='replace', action='write')

    write(10,'(A)') '# x  f(x)  numerical_df  exact_df  absolute_error'

    do i = 0, n-2
        x = a + real(i, real64)*h

        numerical_derivative = &
            (f(x+h)-f(x))/h

        exact_derivative = df_exact(x)

        absolute_error = abs(numerical_derivative - &
                             exact_derivative)

        write(10,'(5(ES24.15,1X))') x, f(x), &
            numerical_derivative, exact_derivative, &
            absolute_error
    end do

    close(10)

    print *, 'Forward-difference calculation completed.'
    print *, 'Output file: forward_difference.dat'
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

end program forward_difference
