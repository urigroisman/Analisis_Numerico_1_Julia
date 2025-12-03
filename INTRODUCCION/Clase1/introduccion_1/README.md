# Introducción – Evaluación de polinomios en Julia

Este directorio forma parte del curso **Análisis Numérico 1 con Julia** y contiene el script `polyval.jl`, cuyo objetivo es ilustrar distintas estrategias numéricas para evaluar polinomios y comparar su desempeño (tiempo de cómputo).

El foco principal es didáctico:

- mostrar diferentes algoritmos de evaluación,
- verificar que todos producen el mismo resultado numérico (dentro de los errores de redondeo),
- comparar eficiencia usando *benchmarks* reproducibles.

---

## Contenido principal

### `polyval.jl`

Implementa varios métodos para evaluar un polinomio

    p(x) = c₀ + c₁ x + c₂ x² + ⋯ + cₙ xⁿ

a partir del vector de coeficientes

    c = [c0, c1, c2, ..., cn]

Convención: `c[1] = c₀` es el término independiente.

Funciones definidas:

- **`polyval(c, x)`**  
  Evaluación compacta usando comprensión de arreglos.

- **`polyfun(c, x)`**  
  Suma explícita, calculando las potencias `x^(i-1)` en un bucle.

- **`evaluate(c, x)`**  
  Acumula las potencias de `x` para evitar recalcular `x^(i-1)` en cada iteración.

- **`Horner(c, x)`**  
  Implementación del método de Horner (esquema anidado).

- **`eval_polynomials(c, x)`**  
  Evaluación usando el tipo `Polynomial` del paquete `Polynomials.jl`.

- **`eval_all(c, x)`**  
  Evalúa el polinomio con todos los métodos anteriores y devuelve un `NamedTuple` con los resultados.

- **`bench_all(c, x)`**  
  Compara el tiempo de ejecución de cada método usando `BenchmarkTools.@btime`.

- **`main()`**  
  Programa interactivo que:
  1. pide el grado del polinomio;
  2. genera coeficientes aleatorios en `[0, 1)`;
  3. pide un valor de `x`;
  4. evalúa con todos los métodos;
  5. ejecuta los *benchmarks*.

Al final del archivo se incluye el patrón:

    if abspath(PROGRAM_FILE) == @__FILE__
        main()
    end

que hace que `main()` se ejecute automáticamente **solo** cuando `polyval.jl` se corre como script (por ejemplo desde la terminal).

---

## Requisitos

- Julia **1.11.x** (o versión compatible).

- Paquetes de Julia:

    BenchmarkTools
    Polynomials
    Plots    (opcional, para futuras extensiones gráficas)

---

## Configuración del proyecto Julia

Se recomienda trabajar con un **environment local** en esta carpeta.

1. Abrir una terminal en el directorio `introduccion_1`  
   (se puede arrastrar la carpeta desde Finder a la terminal para completar la ruta):

        cd /ruta/a/.../introduccion_1

2. Iniciar Julia:

        julia

3. Activar (o crear) el proyecto local:

        julia> ]
        (@v1.11) pkg> activate .

4. Agregar las dependencias:

        (introduccion_1) pkg> add BenchmarkTools Polynomials Plots

5. Verificar el estado del environment:

        (introduccion_1) pkg> status

Con esto se genera un `Project.toml` en este directorio con las dependencias necesarias.

Para volver al environment global de Julia 1.11:

    pkg> activate @v1.11

---

## Cómo ejecutar `polyval.jl`

### 1. Desde la terminal (como script)

En la carpeta del proyecto:

    julia --project=. polyval.jl

- Se activa el environment local (`--project=.`).
- Se ejecuta `polyval.jl` como script.
- El bloque `if abspath(PROGRAM_FILE) == @__FILE__` dispara `main()` automáticamente.

El programa pedirá:

1. el grado del polinomio,
2. los datos necesarios,
3. y mostrará los resultados y los *benchmarks*.

---

### 2. Desde el REPL de Julia

En la carpeta `introduccion_1`:

    julia --project=.

Y luego dentro de Julia:

    julia> include("polyval.jl")   # define todas las funciones
    julia> main()                  # ejecuta el programa interactivo

También se pueden probar las funciones de forma manual:

    julia> c = [1.0, -3.0, 2.0]    # p(x) = 1 - 3x + 2x^2
    julia> x = 0.5

    julia> polyval(c, x)
    julia> Horner(c, x)
    julia> eval_all(c, x)
    julia> bench_all(c, x)

---

### 3. Desde VS Code

1. Abrir la carpeta `introduccion_1` como carpeta de proyecto en VS Code.
2. Asegurarse de que el REPL de Julia se inicie con `--project=@.`  
   (la extensión de Julia suele detectarlo automáticamente si hay `Project.toml`).
3. En el REPL de VS Code:

        julia> include("polyval.jl")
        julia> main()

También se puede ejecutar código **línea o bloque a bloque** usando los atajos
(`Shift+Enter`, `Ctrl+Enter`, etc., según configuración), para ir explorando las funciones.

---

## Ideas para extensión didáctica

- Fijar un polinomio con raíces conocidas y estudiar la **sensibilidad** numérica al evaluar cerca de raíces múltiples.
- Comparar la pérdida de precisión usando `Float32` vs `Float64`.
- Utilizar `Plots.jl` para graficar:
  - el polinomio,
  - el error relativo entre distintos métodos de evaluación,
  - el tiempo de cálculo en función del grado del polinomio.
- Relacionar la elección del algoritmo con:
  - complejidad computacional,
  - estabilidad numérica,
  - y las transparencias de la unidad de **aritmética de punto flotante**.

---

## Créditos

Material desarrollado en el marco del curso:

**“Análisis Numérico 1 – Julia como lenguaje de programación”**  
Instituto Newton – Curso en desarrollo.