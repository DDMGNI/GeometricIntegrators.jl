
abstract AbstractCoefficients{T}

Base.isequal{T1,T2}(coeff1::AbstractCoefficients{T1}, coeff2::AbstractCoefficients{T2}) = (coeff1 == coeff2 && T1 == T2 && typeof(coeff1) == typeof(coeff2))


@define HeaderCoefficientsRK begin
    name::Symbol
    o::Int
    s::Int
end

@define HeaderCoefficientsARK begin
    @HeaderCoefficientsRK
    r::Int
end

@define CoefficientsRK begin
    a::Matrix{T}
    b::Vector{T}
    c::Vector{T}
end

@define CoefficientsARK begin
    @CoefficientsRK
    α::Matrix{T}
    β::Vector{T}
end

@define CoefficientsPRK begin
    a::Matrix{T}
    c::Vector{T}
    α::Matrix{T}
end


"Holds the coefficients of a Runge-Kutta method."
immutable CoefficientsRK{T} <: AbstractCoefficients{T}
    @HeaderCoefficientsRK
    @CoefficientsRK

    function CoefficientsRK(name,o,s,a,b,c)
        @assert T <: Real
        @assert isa(name, Symbol)
        @assert isa(o, Integer)
        @assert isa(s, Integer)
        @assert s > 0 "Number of stages must be > 0"
        @assert s==size(a,1)==size(a,2)==length(b)==length(c)
        new(name,o,s,a,b,c)
    end
end

function CoefficientsRK{T}(name::Symbol, order::Int, a::Matrix{T}, b::Vector{T}, c::Vector{T})
    CoefficientsRK{T}(name, order, length(c), a, b, c)
end

Base.hash(tab::CoefficientsRK, h::UInt) = hash(tab.o, hash(tab.s, hash(tab.a, hash(tab.b, hash(tab.c, hash(:CoefficientsRK, h))))))

Base.:(==){T1, T2}(tab1::CoefficientsRK{T1}, tab2::CoefficientsRK{T2}) = (tab1.o == tab2.o
                                                             && tab1.s == tab2.s
                                                             && tab1.a == tab2.a
                                                             && tab1.b == tab2.b
                                                             && tab1.c == tab2.c)

Base.isequal{T1, T2}(tab1::CoefficientsRK{T1}, tab2::CoefficientsRK{T2}) = (tab1 == tab2 && T1 == T2 && typeof(tab1) == typeof(tab2))

"Print Runge-Kutta coefficients."
function Base.show(io::IO, tab::CoefficientsRK)
    print(io, "Runge-Kutta Coefficients ", tab.name, " with ", tab.s, " stages and order ", tab.o)
    print(io, "  a = ", tab.a)
    print(io, "  b = ", tab.b)
    print(io, "  c = ", tab.c)
end


"Holds the coefficients of an additive Runge-Kutta method."
immutable CoefficientsARK{T} <: AbstractCoefficients{T}
    @HeaderCoefficientsARK
    @CoefficientsARK

    function CoefficientsARK(name,o,s,r,a,b,c,α,β)
        @assert T <: Real
        @assert isa(name, Symbol)
        @assert isa(o, Integer)
        @assert isa(s, Integer)
        @assert isa(r, Integer)
        @assert s > 0 "Number of stages s must be > 0"
        @assert r > 0 "Number of stages r must be > 0"
        @assert s==size(a,1)==size(a,2)==size(α,1)==length(b)==length(c)
        @assert r==size(α,2)==length(β)
        new(name,o,s,r,a,b,c,α,β)
    end
end

function CoefficientsARK{T}(name::Symbol, order::Int, a::Matrix{T}, b::Vector{T}, c::Vector{T}, α::Matrix{T}, β::Vector{T})
    CoefficientsARK{T}(name, order, length(b), length(β), a, b, c, α, β)
end

Base.hash(tab::CoefficientsARK, h::UInt) = hash(tab.o, hash(tab.s, hash(tab.r, hash(tab.a, hash(tab.b, hash(tab.c, hash(tab.α, hash(tab.β, hash(:CoefficientsARK, h)))))))))

Base.:(==){T1, T2}(tab1::CoefficientsARK{T1}, tab2::CoefficientsARK{T2}) = (tab1.o == tab2.o
                                                             && tab1.s == tab2.s
                                                             && tab1.r == tab2.r
                                                             && tab1.a == tab2.a
                                                             && tab1.b == tab2.b
                                                             && tab1.c == tab2.c
                                                             && tab1.α == tab2.α
                                                             && tab1.β == tab2.β)

"Print additive Runge-Kutta coefficients."
function Base.show(io::IO, tab::CoefficientsARK)
    print(io, "Additive Runge-Kutta Coefficients ", tab.name, "with ", tab.s, " internal stages, ", tab.r, " projective stages and order ", tab.o)
    print(io, "  a = ", tab.a)
    print(io, "  b = ", tab.b)
    print(io, "  c = ", tab.c)
    print(io, "  α = ", tab.α)
    print(io, "  β = ", tab.β)
end


"Holds the coefficients of a projective Runge-Kutta method."
immutable CoefficientsPRK{T} <: AbstractCoefficients{T}
    @HeaderCoefficientsARK
    @CoefficientsPRK

    function CoefficientsPRK(name,o,s,r,a,c,α)
        @assert T <: Real
        @assert isa(name, Symbol)
        @assert isa(o, Integer)
        @assert isa(s, Integer)
        @assert isa(r, Integer)
        @assert s > 0 "Number of stages s must be > 0"
        @assert r > 0 "Number of stages r must be > 0"
        @assert r==size(a,1)==size(α,1)==size(α,2)==length(c)
        @assert s==size(a,2)
        new(name,o,s,r,a,c,α)
    end
end

function CoefficientsPRK{T}(name::Symbol, order::Int, a::Matrix{T}, c::Vector{T}, α::Matrix{T})
    CoefficientsPRK{T}(name, order, size(a,2), length(c), a, c, α)
end

Base.hash(tab::CoefficientsPRK, h::UInt) = hash(tab.o, hash(tab.s, hash(tab.r, hash(tab.a, hash(tab.c, hash(tab.α, hash(:CoefficientsPRK, h)))))))

Base.:(==){T1, T2}(tab1::CoefficientsPRK{T1}, tab2::CoefficientsPRK{T2}) = (tab1.o == tab2.o
                                                             && tab1.s == tab2.s
                                                             && tab1.r == tab2.r
                                                             && tab1.a == tab2.a
                                                             && tab1.c == tab2.c
                                                             && tab1.α == tab2.α)

"Print projective Runge-Kutta coefficients."
function Base.show(io::IO, tab::CoefficientsPRK)
    print(io, "Projective Runge-Kutta Coefficients ", tab.name, "with ", tab.s, " internal stages, ", tab.r, " projective stages and order ", tab.o)
    print(io, "  a = ", tab.a)
    print(io, "  c = ", tab.c)
    print(io, "  α = ", tab.α)
end


"Holds the multiplier Runge-Kutta coefficients."
immutable CoefficientsMRK{T}
    name::Symbol
    r::Int
    b::Vector{T}
    c::Vector{T}

    function CoefficientsMRK(name,r,b,c)
        @assert T <: Real
        @assert isa(name, Symbol)
        @assert isa(r, Integer)
        @assert r > 0 "Number of stages r must be > 0"
        @assert r==length(b)==length(c)
        new(name,r,b,c)
    end
end

function CoefficientsMRK{T}(name::Symbol, b::Vector{T}, c::Vector{T})
    CoefficientsMRK{T}(name, length(c), b, c)
end

Base.hash(tab::CoefficientsMRK, h::UInt) = hash(tab.r, hash(tab.b, hash(tab.c, hash(:CoefficientsMRK, h))))

Base.:(==){T1, T2}(tab1::CoefficientsMRK{T1}, tab2::CoefficientsMRK{T2}) = (
                                                                tab1.r == tab2.r
                                                             && tab1.b == tab2.b
                                                             && tab1.c == tab2.c)

"Print multiplier Runge-Kutta coefficients."
function Base.show(io::IO, tab::CoefficientsMRK)
    print(io, "Multiplier Runge-Kutta coefficients ", tab.name, "with ", tab.r, " projective stages")
    print(io, "  b = ", tab.b)
    print(io, "  c = ", tab.c)
end