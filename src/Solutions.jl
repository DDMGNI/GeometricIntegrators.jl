__precompile__()

module Solutions

    using ..Equations

    export Timeseries, compute_timeseries!

    include("solutions/timeseries.jl")

    export Solution, SolutionODE, SolutionPODE, SolutionDAE, SolutionPDAE,
           copy_solution!, reset!, set_initial_conditions!, compute_time_steps!,
           createHDF5, writeSolutionToHDF5

    include("solutions/solutions.jl")
    include("solutions/solutions_ode.jl")
    include("solutions/solutions_pode.jl")
    include("solutions/solutions_dae.jl")
    include("solutions/solutions_pdae.jl")

end
