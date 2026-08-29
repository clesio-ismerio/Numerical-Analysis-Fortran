program gauss_seidel_method
    use iso_fortran_env, only: real64
    implicit none

    integer, parameter :: n = 3
    integer, parameter :: maximum_iterations = 1000

    real(real64) :: A(n,n), b(n)
    real(real64) :: x(n), x_old(n)
    real(real64) :: residual_vector(n)
    real(real64) :: sum_lower, sum_upper
    real(real64) :: error, residual
    real(real64), parameter :: tolerance = 1.0e-10_real64

    integer :: i, j, iteration
    integer :: output_unit
    logical :: converged

    A = reshape([ &
        10.0_real64, -1.0_real64,  2.0_real64, &
        -1.0_real64, 11.0_real64, -1.0_real64, &
         2.0_real64, -1.0_real64, 10.0_real64  &
    ], shape(A))

    b = [6.0_real64, 25.0_real64, -11.0_real64]

    x = 0.0_real64
    converged = .false.

    open(newunit=output_unit, &
         file='gauss_seidel_convergence.dat', &
         status='replace', action='write')

    write(output_unit,'(a)') &
        '# iteration error residual x1 x2 x3'

    do iteration = 1, maximum_iterations

        x_old = x

        do i = 1, n

            if (abs(A(i,i)) < 1.0e-14_real64) then
                write(*,*) 'Error: zero diagonal element.'
                stop
            end if

            sum_lower = 0.0_real64
            sum_upper = 0.0_real64

            do j = 1, i - 1
                sum_lower = sum_lower + A(i,j) * x(j)
            end do

            do j = i + 1, n
                sum_upper = sum_upper + A(i,j) * x_old(j)
            end do

            x(i) = (b(i) - sum_lower - sum_upper) / A(i,i)
        end do

        error = maxval(abs(x - x_old))

        residual_vector = b - matmul(A, x)
        residual = maxval(abs(residual_vector))

        write(output_unit,'(i8,1x,5(es20.10,1x))') &
            iteration, error, residual, x(1), x(2), x(3)

        if (residual < tolerance) then
            converged = .true.
            exit
        end if

    end do

    close(output_unit)

    if (converged) then
        write(*,'(a,i0,a)') &
            'Gauss-Seidel converged in ', iteration, ' iterations.'
    else
        write(*,'(a)') &
            'Gauss-Seidel did not converge within the limit.'
    end if

    write(*,'(a,es16.8)') 'Final residual = ', residual
    write(*,'(a)') 'Approximate solution:'

    do i = 1, n
        write(*,'(a,i0,a,es16.8)') 'x(', i, ') = ', x(i)
    end do

end program gauss_seidel_method
