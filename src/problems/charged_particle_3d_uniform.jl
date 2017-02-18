module ChargedParticle3dUniform

    export charged_particle_3d_iode, hamiltonian, angular_momentum

    const E₀ = 2
    const q₀ = [1., 0., 0., 0., 1., 1.]

    include("magnetic_field_uniform.jl")
    include("charged_particle_3d.jl")

end
