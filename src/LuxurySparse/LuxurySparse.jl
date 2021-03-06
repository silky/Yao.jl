module LuxurySparse

using Compat
using Compat.LinearAlgebra
using Compat.SparseArrays
using Compat.Random

import Compat: copyto!
import Compat.LinearAlgebra: ishermitian
import Compat.SparseArrays: SparseMatrixCSC, nnz, nonzeros, sparse, dropzeros!
import Base: getindex, size, similar, copy, show

export PermMatrix, pmrand, IMatrix, I

dropzeros!(A::Diagonal) = A

include("IMatrix.jl")
include("PermMatrix.jl")

include("conversions.jl")
include("promotions.jl")
include("arraymath.jl")
include("linalg.jl")
include("kronecker.jl")

end
