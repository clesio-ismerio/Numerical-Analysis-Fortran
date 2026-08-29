program gaussian_plot_data
    use, intrinsic :: iso_fortran_env, only: real64
    implicit none

    integer, parameter :: number_of_points = 301

    integer :: i
    integer :: unit_function
    integer :: unit_nodes

    real(real64), parameter :: standard_nodes(3) = [ &
        -0.77459666924148337704_real64, &
         0.0_real64, &
         0.77459666924148337704_real64 ]

    real(real64), parameter :: weights(3) = [ &
        0.55555555555555555556_real64, &
        0.88888888888888888889_real64, &
        0.55555555555555555556_real64 ]

    real(real64) :: a
    real(real64) :: b
    real(real64) :: half_length
    real(real64) :: midpoint
    real(real64) :: x
    real(real64) :: x_node

    a = 0.0_real64
    b = 1.0_real64

    midpoint = 0.5_real64*(a+b)
    half_length = 0.5_real64*(b-a)

    open(newunit=unit_function, file='function.dat', &
         status='replace', action='write')

    open(newunit=unit_nodes, file='gaussian_nodes.dat', &
         status='replace', action='write')

    do i = 0, number_of_points-1
        x = a + real(i,real64)*(b-a) / &
            real(number_of_points-1,real64)

        write(unit_function,'(2ES24.14)') x, f(x)
    end do

    do i = 1, 3
        x_node = midpoint+half_length*standard_nodes(i)

        write(unit_nodes,'(3ES24.14)') &
            x_node, f(x_node), weights(i)
    end do

    close(unit_function)
    close(unit_nodes)

    write(*,'(A)') &
        'Files function.dat and gaussian_nodes.dat created.'

contains

    function f(x) result(y)
        real(real64), intent(in) :: x
        real(real64) :: y

        y = exp(-x*x)
    end function f

end program gaussian_plot_data
