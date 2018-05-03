
# general helper functions for integrators.

"""
Create nonlinear solver object for a system of `N` equations with data type `DT`.
The function ``f(x)=0`` to be solved for is determined by a julia function
`function_stages!(x, b, params)`, where `x` is the current solution and `b` is
the output vector, s.th. ``b = f(x)``. `params` are a set of parameters depending
on the equation and integrator that is used.
The solver type is obtained from the config dictionary (`:nls_solver`).
"""
function create_nonlinear_solver(DT, N, params)
    # create solution vector for nonlinear solver
    x = zeros(DT, N)

    # create wrapper function f(x,b) that calls `function_stages!(x, b, params)`
    # with the appropriate `params`
    f = (x,b) -> function_stages!(x, b, params)

    # create nonlinear solver with solver type obtained from config dictionary
    s = get_config(:nls_solver)(x, f)
end


"""
Create a solution vector of type `Double{DT}` for a problem with `D` dimensions
and `M` independent initial conditions.
"""
function create_solution_vector_double_double(DT, D, M)
    x = Array{Vector{Double{DT}}}(M)

    for i in 1:M
        x[i] = zeros(Double{DT}, D)
    end

    return x
end


"""
Create a solution vector of type `Double{DT}` for a problem with `D` dimensions,
`NS' sample paths, and `NI` independent initial conditions.
"""
function create_solution_vector_double_double(DT, D, NS, NI)
    x = Array{Vector{Double{DT}}}(NS,NI)

    for i in 1:NS
        for j in 1:NI
            x[i,j] = zeros(Double{DT}, D)
        end
    end

    return x
end


function check_solution_dimension_asserts(sol::Solution, m::Int, n::Int)
    @assert m ≥ 1
    @assert m ≤ sol.ni

    @assert n ≥ 1
    @assert n ≤ sol.ntime
end


function update_solution!(x::Vector{T}, xₑᵣᵣ::Vector{T}, ẋ::Matrix{T}, b::Vector{T}, Δt::T) where {T}
    @assert length(x) == length(xₑᵣᵣ)
    @assert length(x) == size(ẋ, 1)
    @assert length(b) == size(ẋ, 2)

    for k in indices(ẋ, 1)
        for i in indices(ẋ, 2)
            x[k], xₑᵣᵣ[k] = compensated_summation(Δt * b[i] * ẋ[k,i], x[k], xₑᵣᵣ[k])
        end
    end
end

function update_solution!(x::Union{Vector{T}, Vector{Double{T}}}, ẋ::Matrix{T}, b::Vector{T}, Δt::T) where {T}
    @assert length(x) == size(ẋ, 1)
    @assert length(b) == size(ẋ, 2)

    local Δx::eltype(x)

    for k in indices(ẋ, 1)
        Δx = 0
        for i in indices(ẋ, 2)
            Δx += b[i] * ẋ[k,i]
        end
        x[k] += Δt * Δx
    end
end


# For stochastic Runge-Kutta methods
# x - the solution vector to be updated
# Vx - the matrix containing the drift vector evaluated at the internal stages v(Q_i)
# Bx - the array containing the diffusion matrix evaluated at the internal stages B(Q_i)
# bdrift - the Runge-Kutta coefficients for the drift part
# bdiff - the Runge-Kutta coefficients for the diffusion part
# Δt - the time step
# ΔW - the increments of the Brownian motion
function update_solution!(x::Union{Vector{T}, Vector{Double{T}}}, Vx::Matrix{T}, Bx::Array{T,3}, bdrift::Vector{T}, bdiff::Vector{T}, Δt::T, ΔW::Vector{T}) where {T}
    @assert length(x) == size(Vx, 1) == size(Bx, 1)
    @assert length(bdrift) == length(bdiff) == size(Vx, 2) == size(Bx, 3)
    @assert length(ΔW)== size(Bx, 2)

    local Δx::eltype(x)

    # Contribution from the drift part
    for k in indices(Vx, 1)
        Δx = 0.
        for i in indices(Vx, 2)
            Δx += bdrift[i] * Vx[k,i]
        end
        x[k] += Δt * Δx
    end

    local Δy = zeros(eltype(x), length(ΔW))

    # Contribution from the diffusion part
    for k in indices(Bx, 1)
        Δy .= zeros(eltype(x), length(ΔW))
        for i in indices(Bx, 3)
            Δy += bdiff[i] * Bx[k,:,i]
        end
        x[k] += dot(Δy,ΔW)
    end
end


# For stochastic Runge-Kutta methods
# x - the solution vector to be updated
# Vx - the matrix containing the drift vector evaluated at the internal stages v(Q_i)
# Bx - the array containing the diffusion matrix evaluated at the internal stages B(Q_i)
# bdrift - the Runge-Kutta coefficients for the drift part
# bdiff - the Runge-Kutta coefficients for the ΔW terms of the diffusion part
# bdiff2- the Runge-Kutta coefficients for the ΔZ terms of the diffusion part
# Δt - the time step
# ΔW - the increments of the Brownian motion
# ΔZ - the integrals of the increments of the Brownian motion
function update_solution!(x::Union{Vector{T}, Vector{Double{T}}}, Vx::Matrix{T}, Bx::Array{T,3}, bdrift::Vector{T}, bdiff::Vector{T}, bdiff2::Vector{T}, Δt::T, ΔW::Vector{T}, ΔZ::Vector{T}) where {T}
    @assert length(x) == size(Vx, 1) == size(Bx, 1)
    @assert length(bdrift) == length(bdiff) == length(bdiff2) == size(Vx, 2) == size(Bx, 3)
    @assert length(ΔW) == length(ΔZ) == size(Bx, 2)

    local Δx::eltype(x)

    # Contribution from the drift part
    for k in indices(Vx, 1)
        Δx = 0.
        for i in indices(Vx, 2)
            Δx += bdrift[i] * Vx[k,i]
        end
        x[k] += Δt * Δx
    end

    local Δy = zeros(eltype(x), length(ΔW))

    # Contribution from the diffusion part (ΔW terms)
    for k in indices(Bx, 1)
        Δy .= zeros(eltype(x), length(ΔW))
        for i in indices(Bx, 3)
            Δy += bdiff[i] * Bx[k,:,i]
        end
        x[k] += dot(Δy,ΔW)
    end

    # Contribution from the diffusion part (ΔZ terms)
    for k in indices(Bx, 1)
        Δy .= zeros(eltype(x), length(ΔW))
        for i in indices(Bx, 3)
            Δy += bdiff2[i] * Bx[k,:,i]
        end
        x[k] += dot(Δy,ΔZ)/Δt
    end
end


# For stochastic partitioned Runge-Kutta methods
# q, p - the solution vector to be updated
# Vqp, Fqp - the matrix containing the drift vectors evaluated at the internal stages v(Q_i), f(Q_i)
# Bqp, Gqp - the array containing the diffusion matrices evaluated at the internal stages B(Q_i), G(Q_i)
# bqdrift, bpdrift - the Runge-Kutta coefficients for the drift parts of the q and p equations
# bqdiff, bpdiff - the Runge-Kutta coefficients for the diffusion parts of the q and p equations
# Δt - the time step
# ΔW - the increments of the Brownian motion
function update_solution!(q::Union{Vector{T}, Vector{Double{T}}}, p::Union{Vector{T}, Vector{Double{T}}}, Vqp::Matrix{T}, Fqp::Matrix{T}, Bqp::Array{T,3}, Gqp::Array{T,3}, bqdrift::Vector{T}, bqdiff::Vector{T}, bpdrift::Vector{T}, bpdiff::Vector{T}, Δt::T, ΔW::Vector{T}) where {T}
    @assert length(q) == length(p) == size(Vqp, 1) == size(Fqp, 1) == size(Bqp, 1) == size(Gqp, 1)
    @assert length(bqdrift) == length(bqdiff) == length(bpdrift) == length(bpdiff) == size(Vqp, 2) == size(Fqp, 2) == size(Bqp, 3) == size(Gqp, 3)
    @assert length(ΔW) == size(Bqp, 2) == size(Gqp, 2)

    local Δq::eltype(q)
    local Δp::eltype(p)

    # Contribution from the drift part
    for k in indices(Vqp, 1)
        Δq = 0.
        Δp = 0.
        for i in indices(Vqp, 2)
            Δq += bqdrift[i] * Vqp[k,i]
            Δp += bpdrift[i] * Fqp[k,i]
        end
        q[k] += Δt * Δq
        p[k] += Δt * Δp
    end

    local Δy = zeros(eltype(q), length(ΔW))
    local Δz = zeros(eltype(p), length(ΔW))

    # Contribution from the diffusion part
    for k in indices(Bqp, 1)
        Δy .= zeros(eltype(q), length(ΔW))
        Δz .= zeros(eltype(p), length(ΔW))

        for i in indices(Bqp, 3)
            Δy += bqdiff[i] * Bqp[k,:,i]
            Δz += bpdiff[i] * Gqp[k,:,i]
        end

        q[k] += dot(Δy,ΔW)
        p[k] += dot(Δz,ΔW)
    end
end


function update_solution!(x::Vector{T}, xₑᵣᵣ::Vector{T}, ẋ::Matrix{T}, b::Vector{T}, b̂::Vector, Δt::T) where {T}
    update_solution!(x, xₑᵣᵣ, ẋ, b, Δt)
    update_solution!(x, xₑᵣᵣ, ẋ, b̂, Δt)
end

function update_solution!(x::Union{Vector{T}, Vector{Double{T}}}, ẋ::Matrix{T}, b::Vector{T}, b̂::Vector, Δt::T) where {T}
    update_solution!(x, ẋ, b, Δt)
    update_solution!(x, ẋ, b̂, Δt)
end

# For stochastic Runge-Kutta methods
function update_solution!(x::Union{Vector{T}, Vector{Double{T}}}, Vx::Matrix{T}, Bx::Array{T,3},
                            bdrift::Vector{T}, b̂drift::Vector, bdiff::Vector{T}, b̂diff::Vector, Δt::T, ΔW::Vector{T}) where {T}
    update_solution!(x, Vx, Bx, bdrift, bdiff, Δt, ΔW)
    update_solution!(x, Vx, Bx, b̂drift, b̂diff, Δt, ΔW)
end

# For stochastic partitioned Runge-Kutta methods
function update_solution!(q::Union{Vector{T}, Vector{Double{T}}}, p::Union{Vector{T}, Vector{Double{T}}}, Vqp::Matrix{T}, Fqp::Matrix{T}, Bqp::Array{T,3}, Gqp::Array{T,3},
                            bqdrift::Vector{T}, b̂qdrift::Vector, bqdiff::Vector{T}, b̂qdiff::Vector,
                            bpdrift::Vector{T}, b̂pdrift::Vector, bpdiff::Vector{T}, b̂pdiff::Vector, Δt::T, ΔW::Vector{T}) where {T}
    update_solution!(q, p, Vqp, Fqp, Bqp, Gqp, bqdrift, bqdiff, bpdrift, bpdiff, Δt, ΔW)
    update_solution!(q, p, Vqp, Fqp, Bqp, Gqp, b̂qdrift, b̂qdiff, b̂pdrift, b̂pdiff, Δt, ΔW)
end

function cut_periodic_solution!(x::Vector{T}, xₑᵣᵣ::Vector{T}, periodicity::Vector{T}) where {T}
    @assert length(x) == length(xₑᵣᵣ) == length(periodicity)

    for k in eachindex(x, periodicity)
        if periodicity[k] ≠ 0
            while x[k] < 0
                (x[k], xₑᵣᵣ[k]) = compensated_summation(+periodicity[k], x[k], xₑᵣᵣ[k])
            end
            while x[k] ≥ periodicity[k]
                (x[k], xₑᵣᵣ[k]) = compensated_summation(-periodicity[k], x[k], xₑᵣᵣ[k])
            end
        end
    end
end

function cut_periodic_solution!(x::Vector{T}, periodicity::Vector{T}) where {T}
    @assert length(x) == length(periodicity)

    for k in eachindex(x, periodicity)
        if periodicity[k] ≠ 0
            while x[k] < 0
                x[k] += periodicity[k]
            end
            while x[k] ≥ periodicity[k]
                x[k] -= periodicity[k]
            end
        end
    end
end

function cut_periodic_solution!(x::Vector{Double{T}}, periodicity::Vector{T}) where {T}
    @assert length(x) == length(periodicity)

    for k in eachindex(x, periodicity)
        if periodicity[k] ≠ 0
            while x[k].hi < 0
                x[k] += periodicity[k]
            end
            while x[k].hi ≥ periodicity[k]
                x[k] -= periodicity[k]
            end
        end
    end
end
