program composite_gaussian_example
    use, intrinsic :: iso_fortran_env, only: real64
    implicit none

    integer :: number_of_elements

    real(real64) :: a
    real(real64) :: b
    real(real64) :: integral
    real(real64) :: exact_value
    real(real64) :: absolute_error

    a = 0.0_real64
    b = 1.0_real64
    number_of_elements = 4

    integral = composite_gauss_three_point( &
        f, a, b, number_of_elements)

    exact_value = 0.7468241328124271_real64
    absolute_error = abs(exact_value-integral)

    write(*,'(A,I0)') &
        'Number of elements = ', number_of_elements

    write(*,'(A,F20.12)') &
        'Composite Gaussian = ', integral

    write(*,'(A,F20.12)') &
        'Reference value    = ', exact_value

    write(*,'(A,ES20.10)') &
        'Absolute error     = ', absolute_error

contains

    function f(x) result(y)
        real(real64), intent(in) :: x
        real(real64) :: y

        y = exp(-x*x)
    end function f

    function composite_gauss_three_point( &
        func, x_left, x_right, number_of_elements) result(value)

        interface
            function func(x) result(y)
                import :: real64
                real(real64), intent(in) :: x
                real(real64) :: y
            end function func
        end interface

        real(real64), intent(in) :: x_left
        real(real64), intent(in) :: x_right
        integer, intent(in) :: number_of_elements

        integer :: element
        integer :: i

        real(real64), parameter :: nodes(3) = [ &
            -0.77459666924148337704_real64, &
             0.0_real64, &
             0.77459666924148337704_real64 ]

        real(real64), parameter :: weights(3) = [ &
            0.55555555555555555556_real64, &
            0.88888888888888888889_real64, &
            0.55555555555555555556_real64 ]

        real(real64) :: element_width
        real(real64) :: half_length
        real(real64) :: left_endpoint
        real(real64) :: local_sum
        real(real64) :: midpoint
        real(real64) :: right_endpoint
        real(real64) :: value
        real(real64) :: x

        if (number_of_elements <= 0) then
            error stop 'The number of elements must be positive.'
        end if

        element_width = (x_right-x_left) / &
            real(number_of_elements,real64)

        value = 0.0_real64

        do element = 0, number_of_elements-1
            left_endpoint = x_left + &
                real(element,real64)*element_width

            right_endpoint = left_endpoint+element_width

            midpoint = 0.5_real64 * &
                (left_endpoint+right_endpoint)

            half_length = 0.5_real64 * &
                (right_endpoint-left_endpoint)

            local_sum = 0.0_real64

            do i = 1, 3
                x = midpoint+half_length*nodes(i)
                local_sum = local_sum+weights(i)*func(x)
            end do

            value = value+half_length*local_sum
        end do
    end function composite_gauss_three_point

end program composite_gaussian_example
