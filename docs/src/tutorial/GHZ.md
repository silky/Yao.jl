# Prepare Greenberger–Horne–Zeilinger state with Quantum Circuit

First, you have to use this package in Julia.

```@example GHZ
using Yao
```

Then let's define the oracle, it is a function of the number of qubits.
The whole oracle looks like this:


```@example GHZ
n = 4
circuit = chain(
    kron(n, 1=>X),
    kron(n, i=>H for i in 2:n),
    control(n, [2, ], X, 1),
    control(n, [4, ], X, 3),
    control(n, [3, ], X, 1),
    control(n, [4, ], X, 3),
    roll(n, H)
);
```

Let me explain what happens here. Firstly, we have a `X` gate which is applied to the first
qubit. We need decide how we calculate this numerically, `Yao` offers serveral different approach
to this. The simplest (but not the most efficient) one is to use kronecker product which will
product `X` with `I` on other lines to gather an operator in the whole space and then apply it
to the register. The first argument `n` means the number of qubits.


```@example GHZ
kron(n, 1=>X)
```

Similar with `kron`, we then need to apply some controled gates.

```@example GHZ
control(n, [2, ], X, 1)
```

This means there is a `X` gate on the first qubit that is controled by the second qubit. In fact,
you can also create a controled gate with multiple control qubits, like

```@example GHZ
control(n, [2, 3], X, 1)
```

In the end, we need to apply `H` gate to all lines, of course, you can do it by `kron`,
but we offer something more efficient called `roll`, this applies a single gate each time
on each qubit without calculating a new large operator, which will be extremely efficient
for calculating small gates that tiles on almost every lines.

The whole circuit is a chained structure of the above blocks. And we actually store a quantum
circuit in a tree structure.

```@example GHZ
circuit
```

After we have an circuit, we can construct a quantum register, and
input it into the oracle. You will then receive this register after
processing it.

```@example GHZ
r = circuit(register(bit"0000"))
r
```

Let's check the output:

```@example GHZ
statevec(r)
```

We have a GHZ state here, try to measure the first qubit

```@example GHZ
r |> measure(1)
statevec(r)
```

GHZ state will collapse to ``|0000\rangle`` or ``|1111\rangle`` due to entanglement!
