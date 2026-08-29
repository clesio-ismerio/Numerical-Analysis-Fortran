program population_growth
    use iso_fortran_env, only: real64
    implicit none

    integer, parameter :: dp = real64

    real(dp) :: initial_population
    real(dp) :: population, exact_population
    real(dp) :: growth_parameter, carrying_capacity
    real(dp) :: time, dt, final_time
    real(dp) :: instantaneous_growth
    real(dp) :: absolute_error
    integer :: step, number_of_steps
    integer :: output_unit

    initial_population = 50.0_dp
    growth_parameter   = 0.30_dp
    carrying_capacity  = 1000.0_dp

    dt = 0.05_dp
    final_time = 40.0_dp
    number_of_steps = nint(final_time / dt)

    population = initial_population
    time = 0.0_dp

    open(newunit=output_unit, file='population.dat', &
         status='replace', action='write')

    do step = 0, number_of_steps
        exact_population = carrying_capacity / &
            (1.0_dp + &
            ((carrying_capacity - initial_population) / &
             initial_population) * &
             exp(-growth_parameter * time))

        instantaneous_growth = growth_parameter * population * &
                               (1.0_dp - &
                               population/carrying_capacity)

        absolute_error = abs(population - exact_population)

        write(output_unit,'(5(es20.10,1x))') &
            time, population, exact_population, &
            instantaneous_growth, absolute_error

        if (step < number_of_steps) then
            call rk4_step(time, population, dt, growth_parameter, &
                          carrying_capacity)
            time = time + dt
        end if
    end do

    close(output_unit)

    print '(a,f12.4)', 'Initial population: ', initial_population
    print '(a,f12.4)', 'Carrying capacity:  ', carrying_capacity
    print '(a,f12.4)', 'Final population:   ', population
    print '(a)', 'Output file: population.dat'

contains

    pure function logistic_derivative(population, &
                                      growth_parameter, &
                                      carrying_capacity) result(dpdt)
        real(dp), intent(in) :: population
        real(dp), intent(in) :: growth_parameter
        real(dp), intent(in) :: carrying_capacity
        real(dp) :: dpdt

        dpdt = growth_parameter * population * &
               (1.0_dp - population/carrying_capacity)
    end function logistic_derivative

    subroutine rk4_step(time, population, dt, growth_parameter, &
                        carrying_capacity)
        real(dp), intent(in)    :: time, dt
        real(dp), intent(inout) :: population
        real(dp), intent(in)    :: growth_parameter
        real(dp), intent(in)    :: carrying_capacity

        real(dp) :: k1, k2, k3, k4

        if (time < -huge(time)) stop

        k1 = logistic_derivative(population, growth_parameter, &
                                 carrying_capacity)

        k2 = logistic_derivative(population + 0.5_dp*dt*k1, &
                                 growth_parameter, carrying_capacity)

        k3 = logistic_derivative(population + 0.5_dp*dt*k2, &
                                 growth_parameter, carrying_capacity)

        k4 = logistic_derivative(population + dt*k3, &
                                 growth_parameter, carrying_capacity)

        population = population + dt * &
                     (k1 + 2.0_dp*k2 + 2.0_dp*k3 + k4) / 6.0_dp
    end subroutine rk4_step

end program population_growth
