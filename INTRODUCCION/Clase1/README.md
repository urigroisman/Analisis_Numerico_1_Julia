# Clase 1 – Introducción a Julia

En esta primera clase de la unidad **INTRODUCCION** comenzamos a trabajar con Julia como lenguaje para análisis numérico.

El objetivo principal fue “jugar” con distintos algoritmos para evaluar polinomios y, a partir de ese ejemplo sencillo, aprender a:

- escribir funciones en Julia de forma clara y vectorizada,
- comparar varios algoritmos que resuelven el mismo problema,
- medir tiempos de ejecución usando *benchmarks* reproducibles.

En particular:

- implementamos varias formas de evaluar un polinomio (incluyendo el método de Horner),
- comparamos su costo computacional con el paquete `BenchmarkTools.jl`,
- utilizamos `Polynomials.jl` como referencia y para escribir polinomios de manera más simbólica.

---

## Estructura de esta clase

- `Project.toml`, `Manifest.toml`  
  Definen el environment de Julia utilizado en la Clase 1.

- `src/`  
  Códigos en Julia, incluyendo `polyval.jl`, donde se implementan y comparan los distintos algoritmos de evaluación de polinomios y se ejecutan los benchmarks.

- `tex/`  
  Archivos en \LaTeX{} con los ejercicios y sus soluciones (por ejemplo, la demostración inductiva del método de Horner).

- `pdf/`  
  Versiones compiladas en PDF de los ejercicios y apuntes breves asociados a la clase.

- `notebooks/`  
  Notebooks (Jupyter/Pluto) donde se reproducen los ejemplos y se exploran de forma interactiva los algoritmos y los benchmarks.

Esta clase sirve como punto de partida para:

- familiarizarse con la sintaxis básica de Julia,
- entender cómo organizar un pequeño proyecto con `Project.toml` y `src/`,
- introducir la idea de comparar algoritmos no sólo por corrección, sino también por eficiencia.