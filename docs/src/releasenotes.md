
# Release Notes

## 0.7.0

* Extract TestProblems into GeometricProblems.jl
* Use SimpleSolvers instead of Solvers submodule


## 0.6.2

* Bugfix release


## 0.6.1

* Bugfix release


## 0.6.0

### Breaking Changes

* Revise tableaus: align constructor names with RungeKutta.jl

### New Features

* Add new Runge-Kutta tableaus
* Generalise Lobatto and Radau tableaus to arbitrary number of stages
* Extend documentation on integrators and tableaus


## 0.5.1

* Update documentation
* Fix HDF5 v0.14 deprecations


## 0.5.0

* Moved repository to JuliaGNI
* Moved CI from Travis to GitHub

### Breaking Changes

* Functions for initial guesses are now called v̄ and f̄ and can be prescribed separately from v and f in PDAE, HDAE, etc.
* Rename SPARK tableau constructors and unify distinct constructors for Lobatto tableaus with different number of stages

### New Features

* Implement SPARK integrator for index-two DAEs
* Implement infrastructure for storing internal variables and solver output to atomic solutions
* Store internal variables of SPARK and VPRK integrators in atomic solution
* Add various five-stage Lobatto tableaus
* Add and clean up SPARK tableaus and add docstrings
* Add functions for checking symplecticity conditions of SPARK tableaus
* Add Aqua.jl tests

### Fixes

* Fix initial guess warnings in tests by prescribing proper functions for v̄ and f̄ in example problems
* Fix update_multiplier() method for SPARK integrators


## 0.4.1

### New Features

* Atomic solutions can now store a NamedTuple of internal variables of the integrator, including nonlinear solver output
* Output of internal variables has been added to VPRK integrators
* Add Gauss-Legendre tableaus for implicit partitioned Runge-Kutta methods

### Fixes

* Revision of integrator type hierarchy


## 0.4.0

### New Integrators

* Runge-Kutta integrators for implicit ODEs (`FIRKimplicit` and `SRKimplicit`)
* Variational Partitioned Runge-Kutta integrator with projection based on internal stages

### Fixes

* Computation of initial guess in *all* implicit integrators