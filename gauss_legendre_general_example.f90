program gauss_legendre_general_example
    use, intrinsic :: iso_fortran_env, only: real64
    implicit none

    integer :: n

    real(real64) :: a
    real(real64) :: b
    real(real64) :: integral
    real(real64) :: exact_value
    real(real64) :: absolute_error

    a = 0.0_real64
    b = 1.0_real64
    exact_value = 0.7468241328124271_real64

    write(*,'(A)') &
        ' n       Approximation              Absolute error'

    do n = 1, 5
        integral = gauss_legendre(f, a, b, n)
        absolute_error = abs(exact_value-integral)

        write(*,'(I2,2ES26.14)') &
            n, integral, absolute_error
    end do

contains

    function f(x) result(y)
        real(real64), intent(in) :: x
        real(real64) :: y

        y = exp(-x*x)
    end function f

    function gauss_legendre(func, x_left, x_right, &
                            number_of_points) result(value)

        interface
            function func(x) result(y)
                import :: real64
                real(real64), intent(in) :: x
                real(real64) :: y
            end function func
        end interface

        real(real64), intent(in) :: x_left
        real(real64), intent(in) :: x_right
        integer, intent(in) :: number_of_points

        integer :: i

        real(real64) :: half_length
        real(real64) :: midpoint
        real(real64) :: value
        real(real64) :: x

        real(real64), allocatable :: nodes(:)
        real(real64), allocatable :: weights(:)

        call gauss_legendre_table( &
            number_of_points, nodes, weights)

        midpoint = 0.5_real64*(x_left+x_right)
        half_length = 0.5_real64*(x_right-x_left)

        value = 0.0_real64

        do i = 1, number_of_points
            x = midpoint+half_length*nodes(i)
            value = value+weights(i)*func(x)
        end do

        value = half_length*value
    end function gauss_legendre

    subroutine gauss_legendre_table(n, nodes, weights)
        integer, intent(in) :: n

        real(real64), allocatable, intent(out) :: nodes(:)
        real(real64), allocatable, intent(out) :: weights(:)

        allocate(nodes(n),weights(n))

        select case (n)

        case (1)
            nodes(1) = 0.0_real64

            weights(1) = 2.0_real64

        case (2)
            nodes = [ &
                -0.57735026918962576451_real64, &
                 0.57735026918962576451_real64 ]

            weights = [ &
                1.0_real64, &
                1.0_real64 ]

        case (3)
            nodes = [ &
                -0.77459666924148337704_real64, &
                 0.0_real64, &
                 0.77459666924148337704_real64 ]

            weights = [ &
                0.55555555555555555556_real64, &
                0.88888888888888888889_real64, &
                0.55555555555555555556_real64 ]

        case (4)
            nodes = [ &
                -0.86113631159405257522_real64, &
                -0.33998104358485626480_real64, &
                 0.33998104358485626480_real64, &
                 0.86113631159405257522_real64 ]

            weights = [ &
                0.34785484513745385737_real64, &
                0.65214515486254614263_real64, &
                0.65214515486254614263_real64, &
                0.34785484513745385737_real64 ]

        case (5)
            nodes = [ &
                -0.90617984593866399280_real64, &
                -0.53846931010568309104_real64, &
                 0.0_real64, &
                 0.53846931010568309104_real64, &
                 0.90617984593866399280_real64 ]

            weights = [ &
                0.23692688505618908751_real64, &
                0.47862867049936646804_real64, &
                0.56888888888888888889_real64, &
                0.47862867049936646804_real64, &
                0.23692688505618908751_real64 ]

        case default
            error stop &
                'This example supports only 1 to 5 points.'

        end select
    end subroutine gauss_legendre_table

end program gauss_legendre_general_example
