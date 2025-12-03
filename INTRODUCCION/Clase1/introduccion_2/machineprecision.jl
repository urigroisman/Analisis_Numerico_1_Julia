# L-2 MCS 471 Wed 24 Aug 2022 : machineprecision.jl
# Defines two functions to display the main properties
# of 32-bit and 64-bit floating point numbers.

"""
    function test_32bitfloat()

tests properties of 32-bit floating-point numbers.
"""
function test_32bitfloat()
    println("Testing 32-bit floats ...");
    x = Float32(1.0)
    println(x, " has type ", typeof(x))
    println(x, " is ", bitstring(x))
    y = nextfloat(x)
    println(y, " is next to ", x)
    eps32 = y - x
    println("32-bit machine precision : ", eps32)
    println(eps32, " is ", bitstring(eps32))
    println("2^(-23) is ", Float32(2.0)^(-23))
    z = x + eps32
    println(z, " is 1.0 + 32-bit machine precision")
    a = nextfloat(Float32(0.0))
    println("smallest 32-bit float : ", a)
    println(a, " is ", bitstring(a))
    b = prevfloat(Float32(Inf))
    println("largest 32-bit float : ", b)
    println(b, " is ", bitstring(b))
end

"""
    function test_64bitfloat()

tests properties of 64-bit floating-point numbers.
"""
function test_64bitfloat()
    println("Testing 64-bit floats ...");
    x = Float64(1.0)
    println(x, " has type ", typeof(x))
    println(x, " is ", bitstring(x))
    y = nextfloat(x)
    println(y, " is next to ", x)
    eps64 = y - x
    println("64-bit machine precision : ", eps64)
    println(eps64, "\n is ", bitstring(eps64))
    println("2^(-52) is ", 2.0^(-52))
    z = x + eps64
    println(z, " is 1.0 + 64-bit machine precision")
    a = nextfloat(Float64(0.0))
    println("smallest 64-bit float : ", a)
    println(a, "\n is ", bitstring(a))
    b = prevfloat(Float64(Inf))
    println("largest 64-bit float : ", b)
    println(b, "\n is ", bitstring(b))
end

"""
    function main()

runs tests on 32-bit and 64-bit floats.
"""
function main()
    test_32bitfloat()
    test_64bitfloat()
end

main()
