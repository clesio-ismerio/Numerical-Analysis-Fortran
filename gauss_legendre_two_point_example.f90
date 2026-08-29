program gauss_legendre_two_point_example
    use, intrinsic :: iso_fortran_env, only: real64
    implicit none

    real(real64) :: a
    real(real64) :: b
    real(real64) :: integral
    real(real64) :: exact_value
    real(real64) :: absolute_error

    a = 0.0_real64
    b = 1.0_real64

    integral = gauss_legendre_two_point(f, a, b)

    exact_value = 0.7468241328124271_real64
    absolute_error = abs(exact_value-integral)

    write(*,'(A,F20.12)') 'Two-point Gaussian value = ', integral
    write(*,'(A,F20.12)') 'Reference value          = ', exact_value
    write(*,'(A,ES20.10)') 'Absolute error           = ', absolute_error

contains

    function f(x) result(y)
        real(real64), intent(in) :: x
        real(real64) :: y

        y = exp(-x*x)
    end function f

    function gauss_legendre_two_point( &
        func, x_left, x_right) result(value)

        interface
            function func(x) result(y)
                import :: real64
                real(real64), intent(in) :: x
                real(real64) :: y
            end function func
        end interface

        real(real64), intent(in) :: x_left
        real(real64), intent(in) :: x_right

        real(real64) :: half_length
        real(real64) :: midpoint
        real(real64) :: node
        real(real64) :: x1
        real(real64) :: x2
        real(real64) :: value

        midpoint = 0.5_real64*(x_left+x_right)
        half_length = 0.5_real64*(x_right-x_left)

        node = 1.0_real64/sqrt(3.0_real64)

        x1 = midpoint-half_length*node
        x2 = midpoint+half_length*node

        value = half_length*(func(x1)+func(x2))
    end function gauss_legendre_two_point

end program gauss_legendre_two_point_example
