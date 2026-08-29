program compare_iterative_methods
    use iso_fortran_env, only: real64
    implicit none

    integer, parameter :: n = 3
    integer, parameter :: maximum_iterations = 1000
    real(real64), parameter :: tolerance = 1.0e-12_real64

    real(real64) :: A(n,n), b(n)
    real(real64) :: x_jacobi(n), x_jacobi_new(n)
    real(real64) :: x_gs(n), x_gs_old(n)
    real(real64) :: residual_vector(n)
    real(real64) :: residual, sum_value
    real(real64) :: sum_lower, sum_upper
    integer :: i, j, iteration
    integer :: unit_jacobi, unit_gs

    A = reshape([ &
        10.0_real64, -1.0_real64,  2.0_real64, &
        -1.0_real64, 11.0_real64, -1.0_real64, &
         2.0_real64, -1.0_real64, 10.0_real64  &
    ], shape(A))

    b = [6.0_real64, 25.0_real64, -11.0_real64]

    ! ========================================================
    ! Jacobi method
    ! ========================================================

    x_jacobi = 0.0_real64

    open(newunit=unit_jacobi, &
         file='jacobi_residual.dat', &
         status='replace', action='write')

    write(unit_jacobi,'(a)') '# iteration residual'

    do iteration = 1, maximum_iterations

        do i = 1, n
            sum_value = 0.0_real64

            do j = 1, n
                if (j /= i) then
                    sum_value = sum_value + A(i,j) * x_jacobi(j)
                end if
            end do

            x_jacobi_new(i) = &
                (b(i) - sum_value) / A(i,i)
        end do

        residual_vector = b - matmul(A, x_jacobi_new)
        residual = maxval(abs(residual_vector))

        write(unit_jacobi,'(i8,1x,es20.10)') &
            iteration, residual

        x_jacobi = x_jacobi_new

        if (residual < tolerance) exit
    end do

    close(unit_jacobi)

    ! ========================================================
    ! Gauss-Seidel method
    ! ========================================================

    x_gs = 0.0_real64

    open(newunit=unit_gs, &
         file='gauss_seidel_residual.dat', &
         status='replace', action='write')

    write(unit_gs,'(a)') '# iteration residual'

    do iteration = 1, maximum_iterations

        x_gs_old = x_gs

        do i = 1, n
            sum_lower = 0.0_real64
            sum_upper = 0.0_real64

            do j = 1, i - 1
                sum_lower = sum_lower + A(i,j) * x_gs(j)
            end do

            do j = i + 1, n
                sum_upper = sum_upper + A(i,j) * x_gs_old(j)
            end do

            x_gs(i) = &
                (b(i) - sum_lower - sum_upper) / A(i,i)
        end do

        residual_vector = b - matmul(A, x_gs)
        residual = maxval(abs(residual_vector))

        write(unit_gs,'(i8,1x,es20.10)') &
            iteration, residual

        if (residual < tolerance) exit
    end do

    close(unit_gs)

    write(*,'(a)') 'Convergence data files were generated.'
    write(*,'(a)') '  jacobi_residual.dat'
    write(*,'(a)') '  gauss_seidel_residual.dat'

end program compare_iterative_methods
