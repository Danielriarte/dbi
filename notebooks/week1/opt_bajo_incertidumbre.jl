### A Pluto.jl notebook ###
# v0.19.9

using Markdown
using InteractiveUtils

# ╔═╡ 44c5923a-38ed-4d9b-bf37-1d7d7ba9bce0
begin
	using PlutoUI
	using LinearAlgebra
	using FileIO
end

# ╔═╡ 967d854d-fd86-4f12-af95-f8b9e3bc7e37
md"""
#### Cargando paquetes.

_La primera vez que cargues este notebook puede tomar un tiempo!_
"""

# ╔═╡ 78720e31-75e4-4b7a-a340-7572fe78083a
md"""
# 1: Desiciones Bajo Incertidumbre
## 1.1: Optimización Bajo Incertidumbre
"""

# ╔═╡ f4d4e199-5fac-4793-96b0-1ed1161cea0a
md"""
Consideremos una versión general de un problema de optimización:
$\begin{equation}
\tag{1}
z^* = \max\{ g(a) : a \in A \}
\end{equation}$
En este problema, buscamos maximizar una $\textbf{funci\'on objetivo}$ $g(\cdot)$ sobre un $\textbf{conjunto de acciones posibles}$ $A$. 
Normalmente imponemos condiciones sobre la función $g(\cdot)$ y el conjunto $A$ de forma que el problema de optimización esté bien definido. 
Una vez estas condiciones se cumplen, el campo de programación matemática, por ejemplo, se enfoca principalmente en desarrollar algoritmos eficientes para la resolución de estos problemas.
"""

# ╔═╡ 6e038057-8455-4f59-81dc-e52c51fe6ec2
md"""
#### Ejemplo 1.1: Camino más corto
>El conjunto de acciones $A$ puede representar todos los caminos entre los nodos $s$ y $t$ en un grafo dirigido $G$, y la función $g(a)$ puede representar el largo del camino $a\in A$, de forma que la solución al problema es el camino más corto entre los nodos $s$ y $t$. Técnicas de modelamiento permiten representar el conjunto $A$ como un poliedro, y la función $g$ como una función lineal. Con esta representación de programacion lineal, algoritmos especializados, como Simplex, pueden utilizarse para resolver el problema.
"""

# ╔═╡ 218e593e-e7b0-414e-b556-80b3ac32398b
md"""
En otros cursos de Modelamiento y Optimización se estudian problemas donde existe una forma natural de definir variables de decisiones y, por lo tanto, de definir el conjunto $A$ (e.g. caminos en un grafo). 
Más importante aún, la función $g$ también  puede ser construida a partir de principios básicos del problema (e.g. el costo de cada camino), dada la ausencia de incertidumbre en el mapa desde decisiones a la utilidad que estas generaban.
"""

# ╔═╡ 3c5d4144-0263-4805-a6ab-0e33710ab8aa
md"""
A continuación consideraremos situaciones donde, dada una decisión a un problema de operaciones, existe incertidumbre respecto a la utilidad eventualmente generada por dicha decisión. (Desde ahora en adelante siempre consideraremos un $\textbf{espacio de probabilidades}$ $(\Omega,\mathcal{F},\mathbb{P})$). Consideremos, por ejemplo, el problema del camino más corto.\
"""

# ╔═╡ d9b22a2f-0d03-42a6-bcaa-ff90d021fd29
md"""
#### Ejemplo 1.2: Camino más corto estocástico
>En el problema del camino más corto, supongamos que primero uno decide el camino $a$ a recorrer, y que luego de recorrerlo uno incurre en el costo $c(a,\omega)$ asociado al camino $a\in A$, donde $\omega \in \Omega$ es el evento en el espacio muestral $\Omega$ realizado. El tomador de decisiones desconoce el valor de $\omega$ al momento de tomar la decisión. Además, consideremos escenarios tales que para cada par de caminos $(a,a')$ existe un par de eventos $(\omega, \omega')$ tales que: 
>
>$$c(a,\omega) > c(a',\omega) \quad \wedge \quad c(a,\omega') < c(a',\omega').$$
"""

# ╔═╡ 8c5a5e56-943a-4984-85ad-1ed3f6187324
md"""
En el ejemplo anterior tenemos que cada camino es potencialmente subóptimo ex-post (i.e. después de observar la realización de la incertidumbre).
Nuestro objetivo como tomadores de decisiones es escoger la _mejor decisión_, sin embargo, uno solamente puede juzgar objetivamente que decisión fue mejor a posteriori, después de observar la incertidumbre. 
"""

# ╔═╡ e6c39268-b91c-4331-9fa6-e5955150df2f
md"""
Para optimizar sobre nuestras posibles decisiones, tenemos que formular un problema de la forma de (1). Sea $g(a,\omega)$ la utilidad obtenida por la acción $a\in A$ bajo el escenario $\omega\in\Omega$. Lo que necesitamos entonces es definir un mapa $M$(o $\textbf{criterio de decisión}$)  desde el conjunto de todas posibles utilidades a los reales, que represente nuestra función de utilidad. Esto es:

$\begin{equation*}
    g(a) = M(\{g(a,\omega),\,\omega\in \Omega\}).
\end{equation*}$
"""

# ╔═╡ f15e89d8-1686-4198-8dac-d2f4f89f0980
md"""
Estos son algunos criterios posibles.

*  $\hspace{0mm}$ $\textbf{Optimista (MAXIMAX)}$: el tomador de decisión anticipa la mejor realización posible contingente en la acción tomada. Esto es:
    $$g(a) = \max(\{g(a,\omega),\,\omega\in \Omega\}).$$

*  $\hspace{0mm}$ $\textbf{Pesimista (MAXIMIN)}$: el tomador de decisión anticipa la peor realización posible contingente en la acción tomada. Esto es:
    $$g(a) = \min(\{g(a,\omega),\,\omega\in \Omega\}).$$

*  $\hspace{0mm}$ $\textbf{Value at Risk (VaR):}$ Adaptado a un problema de maximización, para un $\alpha\in (0,1)$ el VaR representa el menor valor de $x$ tal que la probabilidad que los beneficios obtenidos sean menores a $x$ es mayor a $\alpha$. Esto es:
    $$g(a) = \inf\{x\in \mathbb{R}: F_{g(a,\cdot)}(x)>\alpha\},$$
    donde $F_X$ representa la función de distribución de una variable aleatoria $X$.
"""

# ╔═╡ 8176bc71-5ef7-4ce2-a521-45e0c678dbe4
md"""
Salvo el último criterio, el resto no depende de la medida de probabilidad subyacente, i.e. no dependen de que tan frecuentemente uno espera que un evento ocurra. VaR incorpora esta información y trata de maximizar la ganancia que se obtiene  (en el _peor_ caso) con probabilidad  $(1-\alpha)$. Los distintos criterios de decisión modelan distintas preferencias por el riesgo. A priori ninguno de los criterios es superior o inferior a otro (esto depende de las preferencias del tomador de decisión). Durante el resto del curso normalmente nos enfocaremos en el más popular de estos criterios:

*  $\hspace{0mm}$ $\textbf{Valor esperado:}$ el tomador de decisión evalúa las alternativas en función del valor esperado de la ganancia monetaria que generan. Esto es: $g(a) = \mathbb{E}\{g(a,\cdot)\}.$

"""

# ╔═╡ 97394983-1a5e-4423-b7cb-9117c668f9cc
md""" $$\textbf{Pregunta:}$$ ¿Es el criterio de valor esperado un buen criterio?

 $$\textbf{Respuesta:}$$ Depende, si se trata de una decisión que se tendrá que tomar persistentemente en el tiempo, y no existe descuento a las utilidades (esto esta asegurado por la Ley Fuerte de los Grandes Números), etc. La literatura ha demostrado que el criterio del valor esperado puede no representar fidedignamente la toma de decisiones de personas. Considere el siguiente ejemplo:
"""

# ╔═╡ fcde01cc-c9a5-44c5-87d3-6fef1a66743f
md"""
#### Ejemplo 1.3: La Paradoja de St. Petersburgo
>Considere la siguiente apuesta: por el precio de $x$ usted lanzará una moneda hasta obtener el primer _sello_, y recibirá un pago de $2^n$, donde $n$ es el número de _caras_ observadas antes de obtener el primer sello. ¿Cuánto está dispuesto a pagar por participar en dicha apuesta?
>
>Calculamos el valor esperado de la ganancia $G$ obtenida:
>
>$$\mathbb{E}\{G\} = \sum_{n=0}^{\infty} 2^n \cdot \mathbb{P}(\# \mbox{ caras }=n) -x= \sum_{n=0}^{\infty} 2^n \cdot \frac{1}{2^{n+1}}-x  = \infty.$$
"""

# ╔═╡ dd4c36b6-7e79-49cd-9b16-1b3495f91ae2
md"""
La teoría de utilidad esperada surge como una posible solución a la paradoja. La teoría plantea que las personas no perciben el dinero directamente como utilidad, sino que cuentan con una función de utilidad $U$ y, por lo tanto, maximizan la utilidad esperada obtenida en un problema bajo incertidumbre.
*  $\textbf{Utilidad Esperada:}$ el tomador de decisión evalúa las alternativas en función del valor esperado de la utilidad generada. Esto es:
    $$g(a) := \mathbb{E}\{U(g(a,\cdot))\}.$$

Dependiendo de la forma de la función de utilidad se obtienen distintas preferencias frente al riesgo. En general, se espera que  las funciones de utilidad sean no-decrecientes.
*  $\textbf{Comportamiento neutral al riesgo:}$ Función de utilidad lineal en el pago. Decisiones equivalentes a utilizar el criterio de valor esperado.

*  $\textbf{Comportamiento averso al riesgo:}$ Función de utilidad cóncava. Los tomadores de decisiones prefieren recibir el valor esperado del pago de la apuesta a participar en la apuesta.

*  $\textbf{Comportamiento amante del riesgo:}$ Función de utilidad convexa. Los tomadores de decisiones prefieren participar en la apuesta a recibir el valor esperado del pago de la apuesta.

Existe consenso que la teoría de Utilidad Esperada no representa una solución descriptiva de cómo las personas toman decisiones. Tomemos por ejemplo el resultado del siguiente experimento de campo:
"""

# ╔═╡ 621a5f11-9af2-47ba-aeab-6d59e4141e67
md""" 
#### Ejemplo 1.4: Prospect Theory
>Considere los siguientes problemas de decisión.
>
>$$\textbf{P1}: \text{Recibir 4K con probabilidad 0.8 (A) vs. Recibir 3K con seguridad (B).}$$ 
>$$\textbf{P2}: \text{Recibir 4K con probabilidad 0.2 (C) vs. Recibir 3K con probabilidad 0.25 (D).}$$ 
>Un experimento de campo documenta que un 80$\%$ de los participantes escogen $B$ en el problema $\textbf{P1}$, y un $65\%$ prefieren $C$ en el problema $\textbf{P2}$. Sin embargo, seteando (sin pérdida de generalidad) $U(0)=0$, preferir $B$ por sobre $A$ implica que:
>
>$$U(3K)/U(4K) > 4/5$$
>
>mientras que preferir $C$ sobre $D$ implica que:
>
>$$U(3K)/U(4K) < 4/5$$.
"""

# ╔═╡ 24194d65-7fbd-4e70-9141-7682d508dcfd
md"""
La teoría de utilidad prospecta surge como una posible solución.

*  $$\textbf{Utilidad (prospecta) esperada:}$$ el tomador de decisión evalúa las alternativas en función del valor esperado de la utilidad generada. Esto es: $$f(a) = \mathbb{E}\{\widetilde{U}(g(a,\cdot)-R)\}.$$ Existen restricciones sobre la posible forma de la utilidad $\tilde{U}$, y la forma de presentar el problema de decisión influencia el punto de referencia $R$.

Entonces, se formulará el problema de toma de decisión bajo incertidumbre como un problema de optimización:

$\begin{equation}
	\tag{2}
    z^* = \max\{ g(a) : a\in A\}
\end{equation}$

Donde $g(a) = M(g(a,\omega))$ representa el uso de algún criterio de desempeño que permite resumir el conjunto de posibles utilidades $\{g(a,\omega): \omega \in \Omega\}$ que resultan de aplicar una decisión $a\in A$ cuando la incertidumbre se realiza en el evento $\omega\in \Omega$.

Respecto al conjunto de acciones posibles $A$, haremos la distinción entre decisiones estáticas y decisiones dinámicas.
"""

# ╔═╡ dc0e8d10-4cbf-4029-9ef1-59054ad0a33d
md"""
### 1.1.1 Decisiones Estática
Son aquellas que se adoptan antes de observar cualquier información respecto a la incertidumbre $\omega$ y no se adaptan a cualquier información que se pueda observar. En términos prácticos, $a\in A$ es no-aleatorio. 
Normalmente este tipo de decisiones se consideran cuando los problemas de decisión carecen de naturaleza intertemporal. 
En situaciones con múltiples períodos, estas decisiones reciben el nombre de _open loop_.
"""

# ╔═╡ a53d85b4-7a21-4097-b486-fa12649f5184
md"""
#### Ejemplo 1.5: Newsvendor Problem
>Suponga usted debe comprar periódicos para vender mañana en su kiosco. Supondremos que puede comprar un número continuo de ejemplares $a\geq 0$, que el costo de cada ejemplar es $c$ y la demanda por periódicos es una variable aleatoria $D\geq 0$ a.s. (con función de densidad $f(\cdot)$), cuya realización es desconocida al momento de decidir el valor de $a$. Supondremos que el precio al que usted vende de cada ejemplar es $p$.
>
>Podemos ver que en esta situación: 
>
>$$g(a,\omega) = p \cdot \min\{a,D(\omega)\} - c\cdot a.$$
>Utilizando el criterio de valor esperado resolvemos el problema:
>
>$$z = \max\{ p\cdot \mathbb{E}\{\min\{D,a\}\} - c\cdot a \,:\, a\geq 0 \}$$
>
>Para resolver el problema, escribimos la esperanza como una integral y derivamos las condiciones de primer orden. Esto es, $a^*$ la cantidad óptima, que corresponde a la solución de:
>
>$$\frac{d}{da}\left(p \int_0^a y f(y) dy + p (1-F(a))a - c\cdot a \right) = 0$$
>
>es decir
>
>$$a^* = F^{-1}(1-c/p)$$
"""

# ╔═╡ 6c4ca980-58d0-4742-8efb-ac8aaab45e3c
md"""
### 1.1.2 Decisiones Dinámicas
Muchas veces modelaremos la toma de decisión en múltiples períodos. En este tipo de situaciones, las decisiones en un período se adaptan a la información recopilada en períodos anteriores.  Dicha información normalmente es aleatoria, por lo que las decisiones mismas resultan ser variables aleatorias.

Consideremos un problema de decisión intertemporal, donde $n$ indexa los períodos, de forma que $n=1$ denota el primer período y $n=N$ el último (para problemas de horizonte finito). A medida que avanzan los períodos, la información es revelada: pensemos en que dicha información toma la forma de un conjunto  $I_n$, tal que sabemos que $\omega \in I_n$.
"""

# ╔═╡ 3609a782-66cc-4d70-8e07-d23a362341a0
md"""
#### Ejemplo 1.6: Inventario multi-período:
>Supongamos que ahora el vendedor del Newsvendor problem vende revistas. Las revistas son relevantes por $N$ días: el vendedor decide cada día cuantas revistas comprar, considerando que las revistas que no vende en un día pueden almacenarse en el kiosko, incurriendo en un costo de almacenaje $h$ por ejemplar. 
>
>La demanda diaria forma una secuencia de variables aleatorias $\{D_1, ... ,D_N\}$ distribuidas (en conjunto) de acuerdo a $F$. Los ejemplares que no se venden al final del horizonte se pierden. En esta situación, cuando al final del día $n$ observamos que la demanda $D_n$ realizada es $d_n$, tenemos que:
>$$I_n  = \{\omega\in \Omega: D_n(\omega)=d_n\}$$
"""

# ╔═╡ 09452d19-ebfc-47f0-b3ec-22c55e9cdc57
md"""
En estas situaciones, para definir el conjunto $A$ tenemos que considerar qué acción se tomará en cada período y ante cualquier posible escenario de información que se pueda enfrentar. En este sentido, tenemos que una acción es un vector aleatorio
$$a(\omega) = (a_1(\omega), ... , a_N(\omega))$$ donde $a_n$ denota la acción a tomarse en el período $n$. La naturaleza intertemporal del problema de decisión junto a esta definición implican que debemos imponer un mínimo de restricciones de consistencia a las acciones que se pueden considerar. 

En particular, queremos evitar escoger una solución $a$ que toma decisiones distintas en el período $n$  bajo eventos $\omega_1$ y $\omega_2$ que comparten historias idénticas hasta el período $n-1$ (es decir, decisiones que hacen trampa y puden ver hacia el futuro).
"""

# ╔═╡ ea4d8069-24dc-4f05-943d-c351afd824d2
md"""
>La definición de un espacio de probabilidades $(\Omega,\mathcal{F},\mathbb{P})$ considera una $\sigma$-álgebra $\mathcal{F}$ que representa esencialmente la familia de todos los subconjuntos de eventos a los cuales nos podrá interesar asignar probabilidades. En este contexto,
>
>$$\mathcal{F}_n = \sigma(I_s, s<n)\subseteq \mathcal{F}$$
>
>Representa un $\sigma$-álgebra tal que cada conjunto de eventos contenido en ella también es un elemento de $\mathcal{F}$ y tal que dos eventos $(\omega_1,\omega_2)$ que comparten historias similares hasta el período $n-1$ siempre están juntos en cualquier subconjunto perteneciente a $\mathcal{F}_n$. 
>
>Aquí, $\sigma(A)$ denota el $\sigma$-álgebra generado por la clase de subconjuntos $A$; esto es, la mínima $\sigma$-álgebra contenida en $\mathcal{F}$ que contiene a todos los subconjuntos en $A$.
>
>El conjunto $\mathbb{F}=\{\mathcal{F}_n, n\leq 1\}$ se conoce como una $\textit{filtración}$, y el espacio $(\Omega,\mathcal{F},\mathbb{F},\mathbb{P})$ se conoce como el espacio de probabilidad $\textit{filtrado}$.
"""

# ╔═╡ 1f36c5be-0d40-4091-a7f0-2f5f4e0e9fa3
md"""
Podemos pensar en $\mathcal{F}_n$ como la historia del proceso de toma de decisión hasta el comienzo del período $n$.

En este contexto, consideraremos $A$ como el espacio de todos vectores de decisiones factibles $a$ (de acuerdo a la lógica subyacente al problema de decisión) tal que $a_n$ es una variable aleatoria en el espacio de probabilidad $(\Omega,\mathcal{F}_n,\mathbb{P})$. 

En términos más prácticos, $a_n$ no puede tomar valores distintos para eventos que comparten historias hasta el período $n$.

Una variable aleatoria $a$ que cumple con la condición de arriba se dice que es adaptada a la filtración en cuestión. Entonces, consideraremos solamente como parte del conjunto $A$ aquellos vectores aleatorios adaptados a la filtración. Dado que estos vectores entregan un valor para la decisión para cualquier posibles información disponible en cada período, nos referiremos a $A$ como el conjunto de $\textit{políticas}$ de decisión factibles.
"""

# ╔═╡ cc8cbb69-f94e-43f8-9cf5-e1c4754c4b4c
md"""
#### Ejemplo 1.7: Inventario multi-período - continuación
>En el caso del Newsvendor multiperíodo, $a_n$ representa el número de ejemplares a comprar al comienzo del período $n$. En este caso, las políticas de decisión deben decidir el valor de $a_n$ solamente en función de la historia del proceso. Normalmente tratremos de resumir dicha historia en un número reducido de indicadores. 
>
>Por ejemplo, suponiendo que $D_1, ... ,D_n$ forma una secuencia de variables aleatorias independientes, la informacion histórica relevante para la toma de decisiones al comienzo de un período es simplemente el inventario de revistas disponibles al comienzo del período. En este caso, podremos escribir una política >como un conjunto de funciones
>$$\mu(\cdot) = (\mu_1(\cdot), \ldots \mu_N(\cdot))$$
>Donde $\mu_n(x)$ representa cuántos ejemplares ordenar cuando el inventario disponible al comienzo del período $n$ es $x$.
>Parte del curso se enfoca en utilizar indicadores eficientes en nuestro modelamiento.
"""

# ╔═╡ 2f329466-df07-4a60-86f9-c27aad4761a5
md"""
Para madurar estas ideas, en particular el concepto de política de decisión, a continuación revisaremos el caso quizás más sencillo de modelo de toma de decisiones secuenciales.
"""

# ╔═╡ 2e0e9e5b-f433-4629-a127-7acb5dfedf7c
md"""
# Appendix
"""

# ╔═╡ e2ddbf2b-ce4f-4407-8240-6251b120416f
TableOfContents()

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
FileIO = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
FileIO = "~1.15.0"
PlutoUI = "~0.7.39"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.3"
manifest_format = "2.0"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[deps.FileIO]]
deps = ["Pkg", "Requires", "UUIDs"]
git-tree-sha1 = "94f5101b96d2d968ace56f7f2db19d0a5f592e28"
uuid = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
version = "1.15.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "0044b23da09b5608b4ecacb4e5e6c6332f833a7e"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.3.2"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "8d1f54886b9037091edf146b517989fc4a09efec"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.39"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.Tricks]]
git-tree-sha1 = "6bac775f2d42a611cdfcd1fb217ee719630c4175"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.6"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╟─967d854d-fd86-4f12-af95-f8b9e3bc7e37
# ╠═44c5923a-38ed-4d9b-bf37-1d7d7ba9bce0
# ╟─78720e31-75e4-4b7a-a340-7572fe78083a
# ╟─f4d4e199-5fac-4793-96b0-1ed1161cea0a
# ╟─6e038057-8455-4f59-81dc-e52c51fe6ec2
# ╟─218e593e-e7b0-414e-b556-80b3ac32398b
# ╟─3c5d4144-0263-4805-a6ab-0e33710ab8aa
# ╟─d9b22a2f-0d03-42a6-bcaa-ff90d021fd29
# ╟─8c5a5e56-943a-4984-85ad-1ed3f6187324
# ╟─e6c39268-b91c-4331-9fa6-e5955150df2f
# ╟─f15e89d8-1686-4198-8dac-d2f4f89f0980
# ╟─8176bc71-5ef7-4ce2-a521-45e0c678dbe4
# ╟─97394983-1a5e-4423-b7cb-9117c668f9cc
# ╟─fcde01cc-c9a5-44c5-87d3-6fef1a66743f
# ╟─dd4c36b6-7e79-49cd-9b16-1b3495f91ae2
# ╟─621a5f11-9af2-47ba-aeab-6d59e4141e67
# ╟─24194d65-7fbd-4e70-9141-7682d508dcfd
# ╟─dc0e8d10-4cbf-4029-9ef1-59054ad0a33d
# ╠═a53d85b4-7a21-4097-b486-fa12649f5184
# ╟─6c4ca980-58d0-4742-8efb-ac8aaab45e3c
# ╟─3609a782-66cc-4d70-8e07-d23a362341a0
# ╟─09452d19-ebfc-47f0-b3ec-22c55e9cdc57
# ╟─ea4d8069-24dc-4f05-943d-c351afd824d2
# ╟─1f36c5be-0d40-4091-a7f0-2f5f4e0e9fa3
# ╟─cc8cbb69-f94e-43f8-9cf5-e1c4754c4b4c
# ╟─2f329466-df07-4a60-86f9-c27aad4761a5
# ╟─2e0e9e5b-f433-4629-a127-7acb5dfedf7c
# ╠═e2ddbf2b-ce4f-4407-8240-6251b120416f
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
