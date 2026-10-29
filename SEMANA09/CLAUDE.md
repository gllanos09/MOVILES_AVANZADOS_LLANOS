# SEMANA09 — Boleta de pago (SwiftUI + Excel)

Mini proyecto del curso Móviles Avanzados. App SwiftUI de una sola pantalla que
calcula una boleta de pago peruana, más un libro de Excel que explica y valida
cada fórmula. Equipo de 2 personas, dos notas separadas: una expone el Excel,
la otra expone la app.

## Restricciones del entorno (no negociables)

- **Xcode 14.2** en una Mac con macOS 12.7.6 Monterey (Intel). Es el techo que
  acepta ese sistema; Xcode 14.3 ya exige Ventura.
- **SDK iOS 16.2 / Swift 5.7.** Prohibido `@Observable`, el macro `#Preview`,
  `ContentUnavailableView`, expresiones `if`/`switch` de Swift 5.9 y cualquier
  API de iOS 17+. Los previews se escriben con `PreviewProvider`.
- Xcode está en `/Users/pamela/Downloads/Xcode.app`, no en `/Applications`.
  `xcode-select` apunta a las Command Line Tools, así que para compilar por
  terminal hay que prefijar
  `DEVELOPER_DIR=/Users/pamela/Downloads/Xcode.app/Contents/Developer`.
- Simulador para las capturas: **iPhone SE (3.ª generación)**. Es la pantalla
  más pequeña disponible, así que evidencia por qué el `ScrollView` es necesario.

## Controles autorizados por el lab

Solo estos: `Text`, `VStack`, `HStack`, `@State`, `TextField`, `Picker`,
`Button` y `ScrollView`. El `ScrollView` es el único control nuevo que el
enunciado permite. No agregar `Form`, `List`, `NavigationView`, `Section`,
`Stepper`, `Toggle` ni nada fuera de esa lista.

## Arquitectura

| Archivo | Responsabilidad | Importa |
|---|---|---|
| `Parametros.swift` | RMV, tasas ONP/EsSalud/AFP, recargos, con fuente y fecha | Foundation |
| `Modelo.swift` | `DatosEntrada`, `Concepto`, `ResultadoBoleta` (structs) | Foundation |
| `Boleta.swift` | `class Boleta` con `validar()` y `calcular()` | Foundation |
| `ContentView.swift` | Pantalla única: formulario, botón, boleta | SwiftUI |

**Regla dura: `ContentView` no hace ninguna operación aritmética.** Lee los
campos, llama a `Boleta.calcular()` y pinta el resultado. Si la vista calcula,
el Excel y la app se desincronizan y falla el control cruzado al centavo que
exige el lab.

Los tres primeros archivos solo importan `Foundation`, así que se pueden
compilar y probar con `swift` en terminal sin abrir Xcode.

## Reglas de cálculo y orden exacto

1. `valorHora = básico / 30 / 8` — **intermedio, no se redondea**
2. `sueldoComputable = redondear(básico / 30 × díasLaborados)`
3. `asigFamiliar = tieneHijos ? 123.00 : 0` — 10% de la RMV, **no se prorratea por días**
4. `he25 = redondear(valorHora × 1.25 × horas25)`
5. `he35 = redondear(valorHora × 1.35 × horas35)`
6. `totalRemuneraciones` = suma de los 4 anteriores, ya redondeados
7. Pensión **excluyente**: ONP → `redondear(total × 0.13)`; AFP → tres
   redondeos separados sobre `total` (fondo 10%, comisión 1.60%, seguro 1.35%)
8. `totalDescuentos = pensión(es) + adelantos`
9. `neto = totalRemuneraciones − totalDescuentos`
10. `esSalud = redondear(total × 0.09)` — lo paga el empleador, **nunca se resta del neto**

### Convenciones de redondeo (causa #1 de descuadres)

- Se redondea **solo** los conceptos que se muestran. Los intermedios
  (`valorHora`, `básico/30`) van con toda su precisión.
- Redondeo **half-up**: 0.005 sube. Es lo que hace `ROUND()` de Excel.
- En Swift se usa `Decimal`, no `Double`, para que el redondeo sea exacto.
- El valor hora sale del **sueldo básico**, no del sueldo computable.

## Parámetros

| Parámetro | Valor | Fuente |
|---|---|---|
| RMV | S/ 1,230.00 | D.S. de la RMV, vigente desde 01/10/2026 |
| Asignación familiar | 10% RMV = S/ 123.00 | Ley 25129 |
| ONP | 13% | D.L. 19990 |
| EsSalud | 9% | Ley 26790 |
| Horas extras | 25% las primeras, 35% las siguientes | Normas de jornada y sobretiempo |
| AFP Ejemplo | fondo 10.00%, comisión 1.60%, seguro 1.35% | Valores de prueba del lab |

Los parámetros **no se escriben dentro de las fórmulas**: viven en
`Parametros.swift` y en la hoja `Parametros` del Excel.

## Casos de prueba — valores verificados

Los casos 1, 2 y 3 traen respuesta oficial en el enunciado y los tres cuadran.
El caso 4 lo evalúa el docente; el valor de abajo es el que produce este motor.

| | Caso 1 | Caso 2 | Caso 3 | Caso 4 |
|---|---|---|---|---|
| Sueldo básico | 2,500.00 | 1,800.00 | 3,000.00 | 4,200.00 |
| Días laborados | 30 | 27 | 30 | 24 |
| Hijos / Sistema | No / ONP | Sí / ONP | Sí / AFP | Sí / AFP |
| Horas 25% / 35% | 0 / 0 | 0 / 0 | 4 / 4 | 2 / 2 |
| Adelantos | 0.00 | 0.00 | 200.00 | 100.00 |
| Sueldo computable | 2,500.00 | 1,620.00 | 3,000.00 | 3,360.00 |
| Asignación familiar | 0.00 | 123.00 | 123.00 | 123.00 |
| Horas extras 25% | 0.00 | 0.00 | 62.50 | 43.75 |
| Horas extras 35% | 0.00 | 0.00 | 67.50 | 47.25 |
| **Total remuneraciones** | **2,500.00** | **1,743.00** | **3,253.00** | **3,574.00** |
| ONP | 325.00 | 226.59 | 0.00 | 0.00 |
| AFP fondo | 0.00 | 0.00 | 325.30 | 357.40 |
| AFP comisión | 0.00 | 0.00 | 52.05 | 57.18 |
| AFP seguro | 0.00 | 0.00 | 43.92 | 48.25 |
| **Total descuentos** | **325.00** | **226.59** | **621.27** | **562.83** |
| **Neto a pagar** | **2,175.00** | **1,516.41** | **2,631.73** | **3,011.17** |
| EsSalud (empleador) | 225.00 | 156.87 | 292.77 | 321.66 |

Valor hora: caso 3 = 12.50, caso 4 = 17.50.

## Respuestas de análisis (ya calculadas)

1. **ONP vs AFP, caso 3**: neto ONP 2,630.11 vs neto AFP 2,631.73. Gana AFP por
   S/ 1.62, porque la tasa AFP suma 12.95% contra 13% de la ONP. Comparar
   porcentajes no basta: el 10% del fondo AFP va a la cuenta individual del
   trabajador (es ahorro suyo), mientras comisión y seguro son costo puro; la
   ONP es un fondo común que exige 20 años de aportes para dar pensión.
2. **Costo empresa, caso 3**: 3,253.00 + 292.77 = S/ 3,545.77. Al trabajador le
   llega 74.22% de ese costo como neto. Si se considera que el adelanto de 200
   ya lo recibió, la cifra sube a 79.86%.
3. **Días laborados, caso 2**: con 30 días el neto sería 1,673.01 contra
   1,516.41. La diferencia bruta es 180.00 y la neta 156.60, exactamente el 87%
   — porque la ONP se queda con el 13% de ese incremento.
4. **Horas extras, caso 3**: 130.00 de 3,253.00 = 4.00% del total.
5. **Con datos reales**: cada alumno toma un sueldo de una oferta laboral
   publicada, guarda enlace y fecha de consulta, y compara el porcentaje que
   llega al trabajador.

## Estructura de archivos

```
SEMANA09/
  Laboratorio09                      <- placeholder preexistente, NO TOCAR
  CLAUDE.md                          <- este archivo
  README.md                          <- con capturas del simulador
  Boleta_Pago.xlsx                   <- 4 hojas: Parametros, Boleta, Casos, Explicacion
  Lab09-BoletaPago/
    Lab09-BoletaPago.xcodeproj
    Lab09-BoletaPago/
      Lab09_BoletaPagoApp.swift
      ContentView.swift
      Parametros.swift
      Modelo.swift
      Boleta.swift
      Assets.xcassets
```

La convención `SEMANA0X/LabX-Nombre/` sale de `SEMANA03/Lab03-Colecciones/`,
que ya existe en este repo.

## Reglas de trabajo

- **Commits solo a nombre del usuario** (`gllanos09`). No agregar líneas de
  atribución a Claude de ningún tipo.
- Un commit por hito, como pide el lab: `params:`, `modelo:`, `calculo:`,
  `caso N verificado`, `ui:`, `excel:`, `docs:`.
- Rama `main`, push directo.
- La app debe decir **"Boleta de ejemplo"** en pantalla. Nada de DNI o RUC
  reales; trabajador y empresa son ficticios.
- No se calcula retención de renta de 5.ª categoría (es nivel 3, opcional).

## Reparto entre los 2 integrantes

- **Persona A** — Excel: las 4 hojas, tabla de fuentes, las 5 respuestas de análisis.
- **Persona B** — App: los 4 archivos Swift, capturas, README.
- **Ambos** — el control cruzado: app y Excel deben coincidir al centavo en los 4 casos.
