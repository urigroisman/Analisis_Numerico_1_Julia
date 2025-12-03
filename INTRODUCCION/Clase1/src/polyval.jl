# ============================================================
# polyval.jl
#
# Evaluación numérica de polinomios en Julia mediante distintos
# algoritmos, con fines comparativos y pedagógicos.
#
# Se implementan:
#   (1) polyval(c, x)         : expresión compacta con comprensión
#   (2) polyfun(c, x)         : suma explícita usando potencias
#   (3) evaluate(c, x)        : acumulando potencias de x
#   (4) Horner(c, x)          : método de Horner (esquema anidado)
#   (5) eval_polynomials(c,x) : usando el paquete Polynomials.jl
#
# Además:
#   - eval_all(c, x)  : evalúa con todos los algoritmos
#   - bench_all(c, x) : compara tiempos con BenchmarkTools
#
# Convención de coeficientes:
#   c = [c₀, c₁, ..., cₙ] representa
#      p(x) = c₀ + c₁ x + c₂ x² + ... + cₙ xⁿ
# ============================================================

using BenchmarkTools
using Polynomials

# ------------------------------------------------------------
# 1. Evaluación compacta con comprensión de arreglos
# ------------------------------------------------------------

"""
    polyval(c, x)

Evalúa el polinomio con coeficientes `c` en el punto `x` usando
una única expresión con comprensión de arreglos:

    p(x) = sum(c[i] * x^(i-1), i = 1, 2, ..., length(c))

Convención de coeficientes:

  - c[1] = c₀  (término independiente)
  - c[2] = c₁
  - …
  - c[n+1] = cₙ

Esta implementación construye un iterable con todos los términos
y luego suma. Es un estilo “compacto” y legible, útil para
mostrar la fórmula directamente en código.
"""
polyval(c::AbstractVector{<:Real}, x::Real) =
    sum(c[i] * x^(i - 1) for i in eachindex(c))

# ------------------------------------------------------------
# 2. Evaluación explícita sumando potencias
# ------------------------------------------------------------

"""
    polyfun(cff, arg)

Evalúa el polinomio con coeficientes `cff` en el punto `arg`
usando una suma explícita con potencias `arg^(i-1)` en un bucle.

Es algebraicamente equivalente a `polyval`, pero el código es
más detallado y permite ver claramente la estructura:

    p(arg) = c₀ + c₁ arg + c₂ arg² + … + cₙ argⁿ
"""
function polyfun(cff::AbstractVector{<:Real}, arg::Real)
    T = promote_type(eltype(cff), typeof(arg))
    s = zero(T)
    for (i, ci) in enumerate(cff)
        # término ci * arg^(i-1)
        s += ci * arg^(i - 1)
    end
    return s
end

# ------------------------------------------------------------
# 3. Evaluación acumulando potencias de x
# ------------------------------------------------------------

"""
    evaluate(cff, arg)

Evalúa el polinomio con coeficientes `cff` en el punto `arg`,
acumulando las potencias de `arg` para evitar recalcular
`arg^(i-1)` en cada iteración.

Esquema conceptual:

    argpow = 1           # arg^0
    para cada coeficiente ci:
        s     += ci * argpow
        argpow *= arg    # siguiente potencia de arg

Esta versión reduce el coste de calcular potencias y es más
eficiente que recalcular `arg^(i-1)` en cada paso.
"""
function evaluate(cff::AbstractVector{<:Real}, arg::Real)
    T = promote_type(eltype(cff), typeof(arg))
    s = zero(T)
    argpow = one(arg)      # arg^0 = 1

    for ci in cff
        s += ci * argpow
        argpow *= arg      # siguiente potencia de arg
    end
    return s
end

# ------------------------------------------------------------
# 4. Método de Horner (esquema anidado)
# ------------------------------------------------------------

"""
    Horner(cff, arg)

Evalúa el polinomio con coeficientes `cff` en el punto `arg`
usando el método de Horner, que reescribe

    p(x) = c₀ + c₁ x + c₂ x² + … + cₙ xⁿ

en la forma anidada

    p(x) = c₀ + x(c₁ + x(c₂ + … + x cₙ)…).

Se implementa recorriendo los coeficientes desde el término de
mayor grado hasta el término independiente:

    s = cₙ
    s = s*x + c_{n-1}
    s = s*x + c_{n-2}
    …
    s = s*x + c₀
"""
function Horner(cff::AbstractVector{<:Real}, arg::Real)
    T = promote_type(eltype(cff), typeof(arg))
    s = zero(T)
    for ci in reverse(cff)
        s = s * arg + ci
    end
    return s
end

# ------------------------------------------------------------
# 5. Evaluación con el paquete Polynomials.jl
# ------------------------------------------------------------

"""
    eval_polynomials(cff, arg)

Evalúa el polinomio definido por los coeficientes `cff` en el
punto `arg` utilizando el tipo `Polynomial` del paquete
`Polynomials.jl`.

La convención de coeficientes es la misma que en las otras
funciones:

    cff = [c₀, c₁, …, cₙ]

representa

    p(x) = c₀ + c₁ x + … + cₙ xⁿ
"""
function eval_polynomials(cff::AbstractVector{<:Real}, arg::Real)
    p = Polynomial(cff)
    return p(arg)
end

# ------------------------------------------------------------
# 6. Evaluación con todos los métodos
# ------------------------------------------------------------

"""
    eval_all(cff, arg) -> NamedTuple

Evalúa el polinomio definido por `cff` en el punto `arg` con
todos los algoritmos implementados y devuelve un `NamedTuple`
con los resultados, lo que facilita la comparación numérica.

Campos del resultado:

  - :polyval
  - :polyfun
  - :evaluate
  - :Horner
  - :polynomials
"""
function eval_all(cff::AbstractVector{<:Real}, arg::Real)
    return (
        polyval     = polyval(cff, arg),
        polyfun     = polyfun(cff, arg),
        evaluate    = evaluate(cff, arg),
        Horner      = Horner(cff, arg),
        polynomials = eval_polynomials(cff, arg),
    )
end

# ------------------------------------------------------------
# 7. Benchmarks con BenchmarkTools
# ------------------------------------------------------------

"""
    bench_all(cff, arg)

Mide y compara los tiempos de ejecución de los distintos
algoritmos de evaluación de polinomios para los coeficientes
`cff` y el punto `arg`, usando `@btime` de BenchmarkTools.

Nota sobre el uso de `$` dentro de `@btime`:

- En `@btime polyval($cff, $arg)` las variables `cff` y `arg`
  se interpolan en la expresión del benchmark.
- Esto evita medir el coste de capturar cierres o acceder al
  entorno global, y da una medida más limpia del coste de la
  función en sí.
"""
function bench_all(cff::AbstractVector{<:Real}, arg::Real)
    println("\n----------------------------------------------")
    println(" Benchmarks (@btime) para la evaluación numérica")
    println(" longitud(cff) = $(length(cff)),  x = $arg")
    println("----------------------------------------------\n")

    println("polyval(cff, x)        :")
    @btime polyval($cff, $arg)

    println("\npolyfun(cff, x)        :")
    @btime polyfun($cff, $arg)

    println("\nevaluate(cff, x)       :")
    @btime evaluate($cff, $arg)

    println("\nHorner(cff, x)         :")
    @btime Horner($cff, $arg)

    println("\nPolynomials.jl (eval_polynomials):")
    @btime eval_polynomials($cff, $arg)
end

# ------------------------------------------------------------
# 8. Programa principal (modo script interactivo)
# ------------------------------------------------------------

"""
    main()

Programa interactivo sencillo que:

  1. Pide el grado del polinomio.
  2. Genera coeficientes aleatorios en el intervalo [0, 1).
  3. Pide un valor de `x`.
  4. Evalúa el polinomio con todos los algoritmos.
  5. Muestra el polinomio construido con `Polynomials.jl`.
  6. Ejecuta benchmarks con `BenchmarkTools` para comparar
     tiempos de ejecución.
"""
function main()
    println("==============================================")
    println(" Evaluación numérica de polinomios en Julia")
    println("==============================================\n")

    print("Ingrese el grado del polinomio (entero ≥ 0): ")
    deg = parse(Int, readline())
    if deg < 0
        error("El grado debe ser un entero no negativo.")
    end

    # Coeficientes generados al azar en [0, 1)
    cff = rand(deg + 1)
    println("\nCoeficientes generados (término independiente primero):")
    println(cff)

    print("\nIngrese el valor de x donde desea evaluar el polinomio: ")
    x = parse(Float64, readline())
    println("\nValor seleccionado: x = $x\n")

    # Representación simbólica con Polynomials.jl
    p = Polynomial(cff)
    println("Polinomio correspondiente (usando Polynomials.jl):")
    println("p(x) = $p\n")

    # Evaluaciones numéricas
    vals = eval_all(cff, x)

    println("Valores de p(x) obtenidos con cada algoritmo:")
    println("  polyval(cff, x)           = $(vals.polyval)")
    println("  polyfun(cff, x)           = $(vals.polyfun)")
    println("  evaluate(cff, x)          = $(vals.evaluate)")
    println("  Horner(cff, x)            = $(vals.Horner)")
    println("  eval_polynomials(cff, x)  = $(vals.polynomials)")

    # Benchmarks (sección separada al final)
    bench_all(cff, x)
end

# Ejecutar main() solo si este archivo se invoca como script
if abspath(PROGRAM_FILE) == @__FILE__
    main()
end