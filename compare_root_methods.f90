program compare_root_methods
    use iso_fortran_env, only: real64
    implicit none

    real(real64), parameter :: tolerance = 1.0e-10_real64
    integer, parameter :: max_iter = 100

    real(real64) :: root_bisection
    real(real64) :: root_false_position
    real(real64) :: root_fixed_point
    real(real64) :: root_newton
    real(real64) :: root_secant

    integer :: iter_bisection
    integer :: iter_false_position
    integer :: iter_fixed_point
    integer :: iter_newton
    integer :: iter_secant

    call bisection(1.0_real64, 2.0_real64, tolerance, &
                   max_iter, root_bisection, iter_bisection)

    call false_position(1.0_real64, 2.0_real64, tolerance, &
                        max_iter, root_false_position, &
                        iter_false_position)

    call fixed_point(1.5_real64, tolerance, max_iter, &
                     root_fixed_point, iter_fixed_point)

    call newton_raphson(1.5_real64, tolerance, max_iter, &
                        root_newton, iter_newton)

    call secant(1.0_real64, 2.0_real64, tolerance, &
                max_iter, root_secant, iter_secant)

    print *
    print '(A)', 'Comparison of Root-Finding Methods'
    print '(A)', repeat('-',78)
    print '(A25,A24,A15)', 'Method', 'Approximate root', 'Iterations'
    print '(A)', repeat('-',78)

    print '(A25,ES24.15,I15)', 'Bisection', &
          root_bisection, iter_bisection

    print '(A25,ES24.15,I15)', 'False position', &
          root_false_position, iter_false_position

    print '(A25,ES24.15,I15)', 'Fixed point', &
          root_fixed_point, iter_fixed_point

    print '(A25,ES24.15,I15)', 'Newton--Raphson', &
          root_newton, iter_newton

    print '(A25,ES24.15,I15)', 'Secant', &
          root_secant, iter_secant

    print '(A)', repeat('-',78)

contains

    pure real(real64) function function_f(x)
        real(real64), intent(in) :: x

        function_f = x**3 - x - 2.0_real64
    end function function_f

    pure real(real64) function derivative_f(x)
        real(real64), intent(in) :: x

        derivative_f = 3.0_real64*x**2 - 1.0_real64
    end function derivative_f

    pure real(real64) function iteration_g(x)
        real(real64), intent(in) :: x

        iteration_g = sign(abs(x + 2.0_real64)**(1.0_real64 / &
                      3.0_real64), x + 2.0_real64)
    end function iteration_g

    subroutine bisection(a_initial, b_initial, tol, &
                         maximum_iterations, root, iterations)
        real(real64), intent(in) :: a_initial, b_initial, tol
        integer, intent(in) :: maximum_iterations
        real(real64), intent(out) :: root
        integer, intent(out) :: iterations

        real(real64) :: a, b, c
        real(real64) :: fa, fc, error

        a = a_initial
        b = b_initial
        fa = function_f(a)

        open(unit=11, file='comparison_bisection.dat', &
             status='replace', action='write')

        write(11,'(A)') '# iteration estimate error residual'

        do iterations = 1, maximum_iterations
            c = 0.5_real64*(a+b)
            fc = function_f(c)
            error = 0.5_real64*abs(b-a)

            write(11,'(I6,3ES24.14)') iterations, c, error, abs(fc)

            if (error < tol .or. abs(fc) < tol) exit

            if (fa*fc < 0.0_real64) then
                b = c
            else
                a = c
                fa = fc
            end if
        end do

        close(11)
        root = c
    end subroutine bisection

    subroutine false_position(a_initial, b_initial, tol, &
                              maximum_iterations, root, iterations)
        real(real64), intent(in) :: a_initial, b_initial, tol
        integer, intent(in) :: maximum_iterations
        real(real64), intent(out) :: root
        integer, intent(out) :: iterations

        real(real64) :: a, b, c, c_old
        real(real64) :: fa, fb, fc
        real(real64) :: error

        a = a_initial
        b = b_initial
        fa = function_f(a)
        fb = function_f(b)
        c_old = a

        open(unit=12, file='comparison_false_position.dat', &
             status='replace', action='write')

        write(12,'(A)') '# iteration estimate error residual'

        do iterations = 1, maximum_iterations
            c = (a*fb-b*fa)/(fb-fa)
            fc = function_f(c)
            error = abs(c-c_old)

            write(12,'(I6,3ES24.14)') iterations, c, error, abs(fc)

            if (abs(fc) < tol) exit

            if (iterations > 1 .and. error < tol) exit

            if (fa*fc < 0.0_real64) then
                b = c
                fb = fc
            else
                a = c
                fa = fc
            end if

            c_old = c
        end do

        close(12)
        root = c
    end subroutine false_position

    subroutine fixed_point(initial_value, tol, &
                           maximum_iterations, root, iterations)
        real(real64), intent(in) :: initial_value, tol
        integer, intent(in) :: maximum_iterations
        real(real64), intent(out) :: root
        integer, intent(out) :: iterations

        real(real64) :: x, x_new, error

        x = initial_value

        open(unit=13, file='comparison_fixed_point.dat', &
             status='replace', action='write')

        write(13,'(A)') '# iteration estimate error residual'

        do iterations = 1, maximum_iterations
            x_new = iteration_g(x)
            error = abs(x_new-x)

            write(13,'(I6,3ES24.14)') iterations, x_new, error, &
                                      abs(function_f(x_new))

            if (error < tol .or. abs(function_f(x_new)) < tol) exit

            x = x_new
        end do

        close(13)
        root = x_new
    end subroutine fixed_point

    subroutine newton_raphson(initial_value, tol, &
                              maximum_iterations, root, iterations)
        real(real64), intent(in) :: initial_value, tol
        integer, intent(in) :: maximum_iterations
        real(real64), intent(out) :: root
        integer, intent(out) :: iterations

        real(real64) :: x, x_new
        real(real64) :: error

        x = initial_value

        open(unit=14, file='comparison_newton.dat', &
             status='replace', action='write')

        write(14,'(A)') '# iteration estimate error residual'

        do iterations = 1, maximum_iterations
            x_new = x-function_f(x)/derivative_f(x)
            error = abs(x_new-x)

            write(14,'(I6,3ES24.14)') iterations, x_new, error, &
                                      abs(function_f(x_new))

            if (error < tol .or. abs(function_f(x_new)) < tol) exit

            x = x_new
        end do

        close(14)
        root = x_new
    end subroutine newton_raphson

    subroutine secant(first_value, second_value, tol, &
                      maximum_iterations, root, iterations)
        real(real64), intent(in) :: first_value, second_value, tol
        integer, intent(in) :: maximum_iterations
        real(real64), intent(out) :: root
        integer, intent(out) :: iterations

        real(real64) :: x0, x1, x2
        real(real64) :: f0, f1
        real(real64) :: error

        x0 = first_value
        x1 = second_value

        open(unit=15, file='comparison_secant.dat', &
             status='replace', action='write')

        write(15,'(A)') '# iteration estimate error residual'

        do iterations = 1, maximum_iterations
            f0 = function_f(x0)
            f1 = function_f(x1)

            x2 = x1-f1*(x1-x0)/(f1-f0)
            error = abs(x2-x1)

            write(15,'(I6,3ES24.14)') iterations, x2, error, &
                                      abs(function_f(x2))

            if (error < tol .or. abs(function_f(x2)) < tol) exit

            x0 = x1
            x1 = x2
        end do

        close(15)
        root = x2
    end subroutine secant

end program compare_root_methods
