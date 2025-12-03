# L-1 MCS 471 Mon 22 Aug 2022 : polyval.jl
# Four functions are defined to evaluate a polynomial:
# (1) In one expression, with an array comprehension;
# (2) With a function declaration;
# (3) Accumulating the powers in a for loop;
# (4) Horner's method in a nested scheme.

using BenchmarkTools

polyval(c, x) = sum([c[i]*x^(i-1) for i=1:length(c)])

"""
Returns the value of the polynomial with coefficients in cff
at the argument arg, using an array comprehension.
"""
function polyfun(cff::Array, arg::Float64)
    values = [cff[i]*arg^(i-1) for i = 1:length(cff)]
    return sum(values)
end

"""
Returns the value of the polynomial with 
coeffients in cff at the argument arg.
The coefficient of the constant term is at cff[1].
The powers of the argument are accumulated.
"""
function evaluate(cff::Array, arg::Float64)
    result = cff[1] # constant coefficient
    argpow = 1.0    # accumulates power of argument
    for i = 2:length(cff)
        argpow = argpow*arg # arg^(i-1)
        result = result + cff[i]*argpow
    end
    return result
end

"""
Returns the value of the polynomial with 
coeffients in cff at the argument arg.
The coefficient of the constant term is at cff[1].
Applies the nested scheme of Horner.
"""
function Horner(cff::Array, arg::Float64)
    index = length(cff)
    result = cff[index]
    index = index - 1
    while index > 0
        result = result*arg + cff[index]
        index = index - 1
    end
    return result
end

# --- 2. Construcción del polinomio aleatorio ---
function build_polynomial(deg::Int)
    rand(deg + 1)   # coeficientes aleatorios
end

# --- 3. Evaluar el polinomio con todos los métodos ---
function eval_all(cff, x)
    val_polyval  = polyval(cff, x)
    val_polyfun  = polyfun(cff, x)
    val_evaluate = evaluate(cff, x)
    val_horner   = Horner(cff, x)

    return (
        polyval  = val_polyval,
        polyfun  = val_polyfun,
        evaluate = val_evaluate,
        horner   = val_horner,
    )
end

# --- 4. Benchmarks (sin I/O) ---
function bench_all(cff, x)
    println("\nBenchmarks (degree = $(length(cff)-1), x = $x):")

    println("polyval:")
    @btime polyval($cff, $x)

    println("polyfun:")
    @btime polyfun($cff, $x)

    println("evaluate:")
    @btime evaluate($cff, $x)

    println("Horner:")
    @btime Horner($cff, $x)
end

# --- 5. Función principal sólo con I/O + llamadas limpias ---
function main()
    # Entrada de datos
    print("Give the degree: ")
    deg = parse(Int, readline(stdin))

    print("Give the value for x: ")
    x = parse(Float64, readline(stdin))

    # Construcción del polinomio
    cff = build_polynomial(deg)
    println("\nCoefficients: $cff")

    # Evaluaciones numéricas
    vals = eval_all(cff, x)

    println("\nFunction values:")
    println("polyval(cff, x)  = $(vals.polyval)")
    println("polyfun(cff, x)  = $(vals.polyfun)")
    println("evaluate(cff, x) = $(vals.evaluate)")
    println("Horner(cff, x)   = $(vals.horner)")

    # Benchmarks (separado)
    bench_all(cff, x)
end

main()