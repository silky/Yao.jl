module CacheServers

using Compat.SparseArrays

using ..LuxurySparse
import ..LuxurySparse: I

using ..Registers
using ..Blocks
import ..Blocks: print_subblocks, print_block

# import package configs
import ..Yao: DefaultType

include("Core.jl")
include("CacheElement.jl")
include("DefaultServer.jl")

# TODO: use cache pool to enable distributed cache
# struct CachePool
# end

const GLOBAL_CACHE_POOL = Dict{DataType, DefaultServer}()

@inline function global_cache(::Type{T}) where T
    if T in keys(GLOBAL_CACHE_POOL)
        return GLOBAL_CACHE_POOL[T]
    else
        server = DefaultServer(T)
        GLOBAL_CACHE_POOL[T] = server
        return server
    end
end

#############
# Interface
#############
export iscacheable

# This will cause signal when signal is not actually unsigned
iscacheable(block::MatrixBlock, signal::Int=1) = iscacheable(block, UInt(signal))
iscacheable(block::MatrixBlock, signal::UInt) = iscacheable(block, cache_type(block), signal)
iscacheable(block::MatrixBlock, ::Type{CT}, signal::UInt) where CT = iscacheable(global_cache(CT), block, signal)

include("CacheFlag.jl")
include("HashRules.jl")
include("CacheRules.jl")
include("UpdateRules.jl")
include("EmptyRules.jl")


end