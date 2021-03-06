export AbstractBlock

"""
    AbstractBlock

abstract type that all block will subtype from. `N` is the number of
qubits.
"""
abstract type AbstractBlock end

# This is something will be fixed in 1.x
# see https://github.com/JuliaLang/julia/issues/14919
# We will define a call for each concrete type
# (block::T)(reg::AbstractRegister) where {T <: AbstractBlock} = apply!(reg, block)

import Base: copy
# only shallow copy by default
# overload this when block contains parameters
copy(x::AbstractBlock) = x

"""
    apply!(reg, block, [signal])

apply a `block` to a register `reg` with or without a cache signal.
"""
function apply! end

dispatch!(block::AbstractBlock, params...) = dispatch!((θ, x)->x, block, params...)

"""
    print_block(io, block)

define the style to print this block
"""
function print_block(io::IO, block)

@static if VERSION < v"0.7-"
    print(io, summary(block))
else
    summary(io, block)
end

end
