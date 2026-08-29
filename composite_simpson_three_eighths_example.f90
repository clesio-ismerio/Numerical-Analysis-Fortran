program composite_simpson_three_eighths_example
    use, intrinsic :: iso_fortran_env, only: real64
    implicit none

    integer :: n

    real(real64) :: a
    real(real64) :: b
    real(real64) :: integral

    a = 0.0_real64
    b = 1.0_real64
    n = 12

    integral = composite_simpson_three_eighths(f, a, b, n)

    write(*,'(A,I0)') 'Number of subintervals = ', n
    write(*,'(A,F20.12)') &
        'Composite Simpson 3/8 = ', integral

contains

    function f(x) result(y)
        real(real64), intent(in) :: x
        real(real64) :: y

        y = exp(-x*x)
    end function f

    function composite_simpson_three_eighths( &
        func, x_left, x_right, number_of_intervals) result(value)

        interface
            function func(x) result(y)
                import :: real64
                real(real64), intent(in) :: x
                real(real64) :: y
            end function func
        end interface

        real(real64), intent(in) :: x_left
        real(real64), intent(in) :: x_right
        integer, intent(in) :: number_of_intervals

        integer :: i

        real(real64) :: h
        real(real64) :: sum
        real(real64) :: value
        real(real64) :: x

        if (number_of_intervals <= 0) then
            error stop 'The number of intervals must be positive.'
        end if

        if (mod(number_of_intervals,3) /= 0) then
            error stop 'The interval count must be divisible by 3.'
        end if

        h = (x_right-x_left) / &
            real(number_of_intervals,real64)

        sum = func(x_left) + func(x_right)

        do i = 1, number_of_intervals-1
            x = x_left + real(i,real64)*h

            if (mod(i,3) == 0) then
                sum = sum + 2.0_real64*func(x)
            else
                sum = sum + 3.0_real64*func(x)
            end if
        end do

        value = 3.0_real64*h*sum/8.0_real64
    end function composite_simpson_three_eighths

end program composite_simpson_three_eighths_example
