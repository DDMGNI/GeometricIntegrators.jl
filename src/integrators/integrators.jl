
using .SPARK
using .VPRK

#*****************************************************************************#
# General initialization functions for all integrators                        #
#*****************************************************************************#

"Print error for integrators not implemented, yet."
function Integrator(equation::Equation, tableau::Union{AbstractTableau,Tableau}, Δt)
    error("No integrator found for equation ", equation, " and tableau ", tableau)
end


#*****************************************************************************#
# Initialization functions for deterministic integrators                      #
#*****************************************************************************#

"Create integrator for Runge-Kutta tableau."
function Integrator(equation::ODE, tableau::Tableau, Δt)
    if isexplicit(tableau)
        # Create integrator for explicit Runge-Kutta tableau
        IntegratorERK(equation, tableau, Δt)
    elseif isdiagnonallyimplicit(tableau)
        # Create integrator for diagonally implicit Runge-Kutta tableau
        IntegratorDIRK(equation, tableau, Δt)
    elseif isfullyimplicit(tableau)
        # Create integrator for fully implicit Runge-Kutta tableau
        IntegratorFIRK(equation, tableau, Δt)
    end
end

"Create integrator for explicit partitioned Runge-Kutta tableau."
function Integrator(equation::Union{PODE,HODE}, tableau::TableauPRK, Δt)
    if isexplicit(tableau)
        IntegratorEPRK(equation, tableau, Δt)
    else
        IntegratorIPRK(equation, tableau, Δt)
    end
end

"Create integrator for implicit partitioned Runge-Kutta tableau."
function Integrator(equation::Union{IODE,VODE}, tableau::TableauPRK, Δt)
    IntegratorPRKimplicit(equation, tableau, Δt)
end

"Create integrator for variational partitioned Runge-Kutta tableau."
function Integrator(equation::IODE, tableau::TableauVPRK, Δt)
    IntegratorVPRK(equation, tableau, Δt)
end

"Create integrator for formal Lagrangian Runge-Kutta tableau."
function Integrator(equation::VODE, tableau::Tableau, Δt)
    IntegratorFLRK(equation, tableau, Δt)
end

"Create integrator for Projected Gauss-Legendre Runge-Kutta tableau."
function Integrator(equation::IODE, tableau::CoefficientsPGLRK, Δt)
    IntegratorPGLRK(equation, tableau, Δt)
end

"Create integrator for variational partitioned additive Runge-Kutta tableau."
function Integrator(equation::IDAE, tableau::TableauVPARK, Δt)
    IntegratorVPARK(equation, tableau, Δt)
end

"Create integrator for special partitioned additive Runge-Kutta tableau."
function Integrator(equation::IDAE, tableau::TableauSPARK, Δt)
    IntegratorSPARK(equation, tableau, Δt)
end

"Create integrator for variational special partitioned additive Runge-Kutta tableau."
function Integrator(equation::IDAE, tableau::TableauVSPARK, Δt)
    IntegratorVSPARK(equation, tableau, Δt)
end

"Create integrator for variational special partitioned additive Runge-Kutta tableau with projection on primary constraint."
function Integrator(equation::IDAE, tableau::TableauVSPARKprimary, Δt)
    IntegratorVSPARKprimary(equation, tableau, Δt)
end

"Create integrator for variational special partitioned additive Runge-Kutta tableau with projection on secondary constraint."
function Integrator(equation::VDAE, tableau::TableauVSPARKsecondary, Δt)
    IntegratorVSPARKsecondary(equation, tableau, Δt)
end

"Create integrator for Hamiltonian partitioned additive Runge-Kutta tableau."
function Integrator(equation::PDAE, tableau::TableauHPARK, Δt)
    IntegratorHPARK(equation, tableau, Δt)
end

"Create integrator for Hamiltonian special partitioned additive Runge-Kutta tableau."
function Integrator(equation::PDAE, tableau::TableauHSPARK, Δt)
    IntegratorHSPARK(equation, tableau, Δt)
end

"Create integrator for Hamiltonian special partitioned additive Runge-Kutta tableau with projection on primary constraint."
function Integrator(equation::PDAE, tableau::TableauHSPARKprimary, Δt)
    IntegratorHSPARKprimary(equation, tableau, Δt)
end

"Create integrator for splitting tableau."
function Integrator(equation::SODE, tableau::AbstractTableauSplitting, Δt)
    IntegratorSplitting(equation, tableau, Δt)
end


#*****************************************************************************#
# Constructor wrappers for deterministic integrators                          #
#*****************************************************************************#

"Create integrator constructor for exact solution."
function IntegratorConstructor(DT, D)
    (v::Function, Δt::Number; kwargs...) -> IntegratorExactODE{DT,D}(v, Δt; kwargs...)
end

"Create integrator constructor for Runge-Kutta tableau."
function IntegratorConstructor(DT, D, tableau::Tableau)
    if isexplicit(tableau)
        # Create integrator constructor for explicit Runge-Kutta tableau
        (v::Function, Δt::Number; kwargs...) -> IntegratorERK{DT,D}(v, tableau, Δt; kwargs...)
    elseif isdiagnonallyimplicit(tableau)
        # Create integrator constructor for diagonally implicit Runge-Kutta tableau
        (v::Function, Δt::Number; kwargs...) -> IntegratorDIRK{DT,D}(v, tableau, Δt; kwargs...)
    elseif isfullyimplicit(tableau)
        # Create integrator constructor for fully implicit Runge-Kutta tableau
        (v::Function, Δt::Number; kwargs...) -> IntegratorFIRK{DT,D}(v, tableau, Δt; kwargs...)
    end
end


#*****************************************************************************#
# General integration functions for all integrators                           #
#*****************************************************************************#

"Apply integrator for ntime time steps and return solution."
function integrate(equation::Equation, integrator::Integrator, ntime::Int; kwargs...)
    solution = Solution(equation, timestep(integrator), ntime; kwargs...)
    integrate!(integrator, solution)
    return solution
end

"Integrate given equation with given tableau for ntime time steps and return solution."
function integrate(equation::Equation, tableau::Union{AbstractTableau,Tableau}, Δt, ntime; kwargs...)
    return integrate(equation, Integrator(equation, tableau, Δt), ntime; kwargs...)
end

"Integrate ODE specified by vector field and initial condition with given tableau for ntime time steps and return solution."
function integrate(f::Function, x₀::Vector, tableau::Union{AbstractTableau,Tableau}, Δt, ntime; t₀=0., kwargs...)
    return integrate(ODE(f, t₀, x₀), tableau, Δt, ntime; kwargs...)
end

"Integrate PODE specified by two vector fields and initial conditions with given tableau for ntime time steps and return solution."
function integrate(v::Function, f::Function, q₀::Vector, p₀::Vector, tableau::Union{AbstractTableau,Tableau}, Δt, ntime; t₀=0., kwargs...)
    return integrate(PODE(v, f, t₀, q₀, p₀), tableau, Δt, ntime; kwargs...)
end


#*****************************************************************************#
# Integration functions for deterministic integrators                         #
#*****************************************************************************#

"Integrate equation for all initial conditions."
function integrate!(int::Integrator, sol::Solution)
    integrate!(int, sol, 1, nsamples(sol))
end


"Integrate ODE for initial conditions m with m₁ ≤ m ≤ m₂."
function integrate!(int::Integrator, sol::Solution, m1, m2)
    # integrate samples m with m₁ ≤ m ≤ m₂ for all time steps
    integrate!(int, sol, m1, m2, 1, ntime(sol))
end


"Integrate ODE for initial conditions m with m₁ ≤ m ≤ m₂ for time steps n with n₁ ≤ n ≤ n₂."
function integrate!(int::Integrator{DT,TT}, sol::Solution{AT,TT}, m1::Int, m2::Int, n1::Int, n2::Int) where {DT, TT, AT <: AbstractArray{DT}}
    @assert m1 ≥ 1
    @assert m2 ≥ m1
    @assert m2 ≤ nsamples(sol)

    @assert n1 ≥ 1
    @assert n2 ≥ n1
    @assert n2 ≤ ntime(sol)

    asol = AtomicSolution(sol, int)

    # loop over initial conditions showing progress bar
    for m in m1:m2
        # get cache from solution
        get_initial_conditions!(sol, asol, m, n1)
        initialize!(int, asol)

        # loop over time steps
        for n in n1:n2
            # try
            integrate!(int, sol, asol, m, n)
            # catch ex
            #     tstr = " in time step " * string(n)
            #
            #     if m1 ≠ m2
            #         tstr *= " for initial condition " * string(m)
            #     end
            #
            #     tstr *= "."
            #
            #     if isa(ex, DomainError)
            #         @warn("Domain error" * tstr)
            #     elseif isa(ex, ErrorException)
            #         @warn("Simulation exited early" * tstr)
            #         @warn(ex.msg)
            #     else
            #         @warn(string(typeof(ex)) * tstr)
            #         throw(ex)
            #     end
            # end
        end
    end
end


function integrate_common!(int::Integrator{DT,TT}, sol::Solution{AT,TT}, asol::AtomicSolution{DT,TT}, m::Int, n::Int) where {DT, TT, AT <: AbstractArray{DT}}
    # integrate one initial condition for one time step
    integrate_step!(int, asol)

    # take care of periodic solutions
    cut_periodic_solution!(asol, periodicity(sol))

    # copy solution from cache to solution
    set_solution!(sol, asol, n, m)
end

function integrate!(int::Integrator{DT,TT}, sol::Solution{AT,TT}, asol::AtomicSolution{DT,TT}, m::Int, n::Int) where {DT, TT, AT <: AbstractArray{DT}}
    integrate_common!(int, sol, asol, m, n)
end
