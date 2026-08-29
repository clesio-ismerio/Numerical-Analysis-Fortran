program higher_order_differences
    use iso_fortran_env, only: real64
    implicit none

    integer, parameter :: n = 201
    integer :: i
    real(real64), parameter :: pi = acos(-1.0_real64)
    real(real64) :: a, b, h, x
    real(real64) :: exact
    real(real64) :: d_forward_1
    real(real64) :: d_backward_1
    real(real64) :: d_central_2
    real(real64) :: d_forward_2
    real(real64) :: d_backward_2
    real(real64) :: d_central_4

    a = 0.0_real64
    b = 2.0_real64*pi
    h = (b-a)/real(n-1, real64)

    open(unit=10, file='higher_order_comparison.dat', &
         status='replace', action='write')

    write(10,'(A)') &
        '# x exact forward_O1 backward_O1 central_O2 ' // &
        'forward_O2 backward_O2 central_O4'

    do i = 2, n-3
        x = a + real(i, real64)*h

        exact = cos(x)

        d_forward_1 = &
            (f(x+h)-f(x))/h

        d_backward_1 = &
            (f(x)-f(x-h))/h

        d_central_2 = &
            (f(x+h)-f(x-h))/(2.0_real64*h)

        d_forward_2 = &
            (-3.0_real64*f(x) + &
             4.0_real64*f(x+h) - &
             f(x+2.0_real64*h)) / &
            (2.0_real64*h)

        d_backward_2 = &
            (3.0_real64*f(x) - &
             4.0_real64*f(x-h) + &
             f(x-2.0_real64*h)) / &
            (2.0_real64*h)

        d_central_4 = &
            (f(x-2.0_real64*h) - &
             8.0_real64*f(x-h) + &
             8.0_real64*f(x+h) - &
             f(x+2.0_real64*h)) / &
            (12.0_real64*h)

        write(10,'(8(ES24.15,1X))') x, exact, &
            d_forward_1, d_backward_1, d_central_2, &
            d_forward_2, d_backward_2, d_central_4
    end do

    close(10)

    call write_error_data()

    print *, 'Higher-order comparison completed.'
    print *, 'Output files:'
    print *, '  higher_order_comparison.dat'
    print *, '  higher_order_errors.dat'
    print *, 'Step size h = ', h

contains

    pure function f(x) result(value)
        real(real64), intent(in) :: x
        real(real64) :: value

        value = sin(x)
    end function f

    subroutine write_error_data()
        integer :: j
        real(real64) :: x_local
        real(real64) :: exact_local
        real(real64) :: e_forward_1
        real(real64) :: e_backward_1
        real(real64) :: e_central_2
        real(real64) :: e_forward_2
        real(real64) :: e_backward_2
        real(real64) :: e_central_4

        open(unit=20, file='higher_order_errors.dat', &
             status='replace', action='write')

        write(20,'(A)') &
            '# x error_FO1 error_BO1 error_CO2 ' // &
            'error_FO2 error_BO2 error_CO4'

        do j = 2, n-3
            x_local = a + real(j, real64)*h
            exact_local = cos(x_local)

            e_forward_1 = abs( &
                (f(x_local+h)-f(x_local))/h - &
                exact_local)

            e_backward_1 = abs( &
                (f(x_local)-f(x_local-h))/h - &
                exact_local)

            e_central_2 = abs( &
                (f(x_local+h)-f(x_local-h)) / &
                (2.0_real64*h) - exact_local)

            e_forward_2 = abs( &
                (-3.0_real64*f(x_local) + &
                 4.0_real64*f(x_local+h) - &
                 f(x_local+2.0_real64*h)) / &
                (2.0_real64*h) - exact_local)

            e_backward_2 = abs( &
                (3.0_real64*f(x_local) - &
                 4.0_real64*f(x_local-h) + &
                 f(x_local-2.0_real64*h)) / &
                (2.0_real64*h) - exact_local)

            e_central_4 = abs( &
                (f(x_local-2.0_real64*h) - &
                 8.0_real64*f(x_local-h) + &
                 8.0_real64*f(x_local+h) - &
                 f(x_local+2.0_real64*h)) / &
                (12.0_real64*h) - exact_local)

            write(20,'(7(ES24.15,1X))') x_local, &
                e_forward_1, e_backward_1, e_central_2, &
                e_forward_2, e_backward_2, e_central_4
        end do

        close(20)
    end subroutine write_error_data

end program higher_order_differences
