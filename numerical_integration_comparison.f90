program numerical_integration_comparison
    use, intrinsic :: iso_fortran_env, only: real64
    implicit none

    integer, parameter :: number_of_tests = 9

    integer :: i
    integer :: n
    integer :: unit_output

    real(real64), parameter :: exact_value = &
        0.7468241328124271_real64

    real(real64) :: a
    real(real64) :: b
    real(real64) :: value_trapezoidal
    real(real64) :: value_simpson
    real(real64) :: value_gaussian
    real(real64) :: error_trapezoidal
    real(real64) :: error_simpson
    real(real64) :: error_gaussian

    a = 0.0_real64
    b = 1.0_real64

    write(*,'(A)') 'Simple methods'
    write(*,'(A,F20.12)') &
        'Simple trapezoidal = ', simple_trapezoidal(f,a,b)

    write(*,'(A,F20.12)') &
        'Simple Simpson     = ', simple_simpson(f,a,b)

    write(*,'(A,F20.12)') &
        'Gauss, 3 points    = ', gauss_three_point(f,a,b)

    open(newunit=unit_output, &
         file='integration_comparison.dat', &
         status='replace', action='write')

    write(unit_output,'(A)') &
        '# n trapezoidal_error simpson_error gaussian_error'

    do i = 1, number_of_tests
        n = 2**i

        value_trapezoidal = &
            composite_trapezoidal(f,a,b,n)

        value_simpson = &
            composite_simpson(f,a,b,n)

        value_gaussian = &
            composite_gauss_three_point(f,a,b,n)

        error_trapezoidal = &
            abs(exact_value-value_trapezoidal)

        error_simpson = &
            abs(exact_value-value_simpson)

        error_gaussian = &
            abs(exact_value-value_gaussian)

        write(unit_output,'(I8,3ES24.12)') &
            n, error_trapezoidal, error_simpson, &
            error_gaussian
    end do

    close(unit_output)

contains

    function f(x) result(y)
        real(real64), intent(in) :: x
        real(real64) :: y

        y = exp(-x*x)
    end function f

    function simple_trapezoidal(func,a,b) result(value)
        interface
            function func(x) result(y)
                import :: real64
                real(real64), intent(in) :: x
                real(real64) :: y
            end function func
        end interface

        real(real64), intent(in) :: a
        real(real64), intent(in) :: b
        real(real64) :: value

        value = 0.5_real64*(b-a)*(func(a)+func(b))
    end function simple_trapezoidal

    function simple_simpson(func,a,b) result(value)
        interface
            function func(x) result(y)
                import :: real64
                real(real64), intent(in) :: x
                real(real64) :: y
            end function func
        end interface

        real(real64), intent(in) :: a
        real(real64), intent(in) :: b

        real(real64) :: midpoint
        real(real64) :: value

        midpoint = 0.5_real64*(a+b)

        value = (b-a) * &
            (func(a)+4.0_real64*func(midpoint)+func(b)) / &
            6.0_real64
    end function simple_simpson

    function composite_trapezoidal(func,a,b,n) result(value)
        interface
            function func(x) result(y)
                import :: real64
                real(real64), intent(in) :: x
                real(real64) :: y
            end function func
        end interface

        real(real64), intent(in) :: a
        real(real64), intent(in) :: b
        integer, intent(in) :: n

        integer :: j

        real(real64) :: h
        real(real64) :: sum
        real(real64) :: value
        real(real64) :: x

        h = (b-a)/real(n,real64)
        sum = 0.5_real64*(func(a)+func(b))

        do j = 1,n-1
            x = a+real(j,real64)*h
            sum = sum+func(x)
        end do

        value = h*sum
    end function composite_trapezoidal

    function composite_simpson(func,a,b,n) result(value)
        interface
            function func(x) result(y)
                import :: real64
                real(real64), intent(in) :: x
                real(real64) :: y
            end function func
        end interface

        real(real64), intent(in) :: a
        real(real64), intent(in) :: b
        integer, intent(in) :: n

        integer :: j

        real(real64) :: h
        real(real64) :: sum_even
        real(real64) :: sum_odd
        real(real64) :: value
        real(real64) :: x

        if (mod(n,2) /= 0) then
            error stop 'Composite Simpson requires even n.'
        end if

        h = (b-a)/real(n,real64)
        sum_odd = 0.0_real64
        sum_even = 0.0_real64

        do j = 1,n-1
            x = a+real(j,real64)*h

            if (mod(j,2) == 0) then
                sum_even = sum_even+func(x)
            else
                sum_odd = sum_odd+func(x)
            end if
        end do

        value = (h/3.0_real64) * &
            (func(a)+4.0_real64*sum_odd + &
             2.0_real64*sum_even+func(b))
    end function composite_simpson

    function gauss_three_point(func,a,b) result(value)
        interface
            function func(x) result(y)
                import :: real64
                real(real64), intent(in) :: x
                real(real64) :: y
            end function func
        end interface

        real(real64), intent(in) :: a
        real(real64), intent(in) :: b

        real(real64), parameter :: nodes(3) = [ &
            -0.77459666924148337704_real64, &
             0.0_real64, &
             0.77459666924148337704_real64 ]

        real(real64), parameter :: weights(3) = [ &
            0.55555555555555555556_real64, &
            0.88888888888888888889_real64, &
            0.55555555555555555556_real64 ]

        integer :: j

        real(real64) :: half_length
        real(real64) :: midpoint
        real(real64) :: value
        real(real64) :: x

        midpoint = 0.5_real64*(a+b)
        half_length = 0.5_real64*(b-a)
        value = 0.0_real64

        do j = 1,3
            x = midpoint+half_length*nodes(j)
            value = value+weights(j)*func(x)
        end do

        value = half_length*value
    end function gauss_three_point

    function composite_gauss_three_point( &
        func,a,b,number_of_elements) result(value)

        interface
            function func(x) result(y)
                import :: real64
                real(real64), intent(in) :: x
                real(real64) :: y
            end function func
        end interface

        real(real64), intent(in) :: a
        real(real64), intent(in) :: b
        integer, intent(in) :: number_of_elements

        integer :: element

        real(real64) :: element_width
        real(real64) :: left_endpoint
        real(real64) :: right_endpoint
        real(real64) :: value

        element_width = (b-a) / &
            real(number_of_elements,real64)

        value = 0.0_real64

        do element = 0,number_of_elements-1
            left_endpoint = a + &
                real(element,real64)*element_width

            right_endpoint = left_endpoint+element_width

            value = value + &
                gauss_three_point( &
                    func,left_endpoint,right_endpoint)
        end do
    end function composite_gauss_three_point

end program numerical_integration_comparison
