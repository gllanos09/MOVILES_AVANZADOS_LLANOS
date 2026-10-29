import Foundation

// Pruebas de consola del motor de cálculo. NO se agrega al target de Xcode:
// contiene código de nivel superior y chocaría con el App principal.
//
// Compilar y correr desde SEMANA09/ (en la Mac):
//
//   DEVELOPER_DIR=/Users/pamela/Downloads/Xcode.app/Contents/Developer \
//     swiftc -O -o /tmp/pruebas-boleta \
//     fuente/Parametros.swift fuente/Modelo.swift fuente/Boleta.swift \
//     pruebas/main.swift && /tmp/pruebas-boleta

var fallos = 0

func chequear(_ nombre: String, _ obtenido: Decimal, _ esperado: String) {
    let valorEsperado = Decimal(string: esperado)!
    let ok = obtenido == valorEsperado
    if !ok { fallos += 1 }
    let marca = ok ? "OK " : "XX "
    let etiqueta = nombre.padding(toLength: 22, withPad: " ", startingAt: 0)
    print("  \(marca) \(etiqueta) \(Formato.soles(obtenido))   (esperado \(esperado))")
}

func mostrar(_ nombre: String, _ monto: Decimal) {
    let etiqueta = nombre.padding(toLength: 22, withPad: " ", startingAt: 0)
    print("     \(etiqueta) \(Formato.soles(monto))")
}

func calcular(
    basico: String, dias: Int, hijos: Bool, sistema: SistemaPensiones,
    h25: Int = 0, h35: Int = 0, adelantos: String = "0"
) -> ResultadoBoleta {
    let datos = DatosEntrada(
        sueldoBasico: Decimal(string: basico)!,
        diasLaborados: dias,
        tieneHijos: hijos,
        sistema: sistema,
        nombreAFP: CatalogoAFP.porDefecto,
        horasExtras25: h25,
        horasExtras35: h35,
        adelantos: Decimal(string: adelantos)!
    )
    let boleta = Boleta(datos: datos)
    let errores = boleta.validar()
    if !errores.isEmpty {
        print("  !! validación falló: \(errores.joined(separator: " "))")
        fallos += 1
    }
    return boleta.calcular()
}

// MARK: - Caso 1

print("CASO 1 · 2,500.00 · 30 días · sin hijos · ONP")
var r = calcular(basico: "2500", dias: 30, hijos: false, sistema: .onp)
chequear("Sueldo computable", r.remuneraciones[0].monto, "2500.00")
chequear("Total remuneraciones", r.totalRemuneraciones, "2500.00")
chequear("ONP", r.descuentos[0].monto, "325.00")
chequear("Neto a pagar", r.netoAPagar, "2175.00")
chequear("EsSalud", r.aportacionesEmpleador[0].monto, "225.00")

// MARK: - Caso 2

print("\nCASO 2 · 1,800.00 · 27 días · con hijos · ONP")
r = calcular(basico: "1800", dias: 27, hijos: true, sistema: .onp)
chequear("Sueldo computable", r.remuneraciones[0].monto, "1620.00")
chequear("Asignación familiar", r.remuneraciones[1].monto, "123.00")
chequear("Total remuneraciones", r.totalRemuneraciones, "1743.00")
chequear("ONP", r.descuentos[0].monto, "226.59")
chequear("Neto a pagar", r.netoAPagar, "1516.41")
chequear("EsSalud", r.aportacionesEmpleador[0].monto, "156.87")

// MARK: - Caso 3

print("\nCASO 3 · 3,000.00 · 30 días · con hijos · AFP · 4h 25% · 4h 35% · adelanto 200")
r = calcular(basico: "3000", dias: 30, hijos: true, sistema: .afp,
             h25: 4, h35: 4, adelantos: "200")
chequear("Valor hora", Boleta.redondear(r.valorHora), "12.50")
chequear("Horas extras 25%", r.remuneraciones[2].monto, "62.50")
chequear("Horas extras 35%", r.remuneraciones[3].monto, "67.50")
chequear("Total remuneraciones", r.totalRemuneraciones, "3253.00")
chequear("AFP fondo", r.descuentos[1].monto, "325.30")
chequear("AFP comisión", r.descuentos[2].monto, "52.05")
chequear("AFP seguro", r.descuentos[3].monto, "43.92")
chequear("Total descuentos", r.totalDescuentos, "621.27")
chequear("Neto a pagar", r.netoAPagar, "2631.73")
chequear("EsSalud", r.aportacionesEmpleador[0].monto, "292.77")

// MARK: - Caso 4 (evaluación: el enunciado no trae la respuesta)

print("\nCASO 4 · 4,200.00 · 24 días · con hijos · AFP · 2h 25% · 2h 35% · adelanto 100")
let c4 = calcular(basico: "4200", dias: 24, hijos: true, sistema: .afp,
                  h25: 2, h35: 2, adelantos: "100")
mostrar("Valor hora", Boleta.redondear(c4.valorHora))
for concepto in c4.remuneraciones { mostrar(concepto.nombre, concepto.monto) }
mostrar("TOTAL REMUNERACIONES", c4.totalRemuneraciones)
for concepto in c4.descuentos { mostrar(concepto.nombre, concepto.monto) }
mostrar("TOTAL DESCUENTOS", c4.totalDescuentos)
mostrar("NETO A PAGAR", c4.netoAPagar)
mostrar("EsSalud (empleador)", c4.aportacionesEmpleador[0].monto)

// MARK: - Validaciones

print("\nVALIDACIONES (deben rechazar)")
func esperarError(_ descripcion: String, _ datos: DatosEntrada) {
    let errores = Boleta(datos: datos).validar()
    let ok = !errores.isEmpty
    if !ok { fallos += 1 }
    print("  \(ok ? "OK " : "XX ") \(descripcion) -> \(errores.first ?? "no rechazó")")
}

let base = DatosEntrada(
    sueldoBasico: 2500, diasLaborados: 30, tieneHijos: false, sistema: .onp,
    nombreAFP: CatalogoAFP.porDefecto, horasExtras25: 0, horasExtras35: 0, adelantos: 0
)
var malo = base; malo.sueldoBasico = 0
esperarError("sueldo en cero", malo)
malo = base; malo.diasLaborados = 0
esperarError("cero días", malo)
malo = base; malo.diasLaborados = 31
esperarError("31 días", malo)
malo = base; malo.horasExtras25 = -1
esperarError("horas negativas", malo)
malo = base; malo.adelantos = -50
esperarError("adelanto negativo", malo)

// MARK: - Preguntas de análisis

print("\nPREGUNTAS DE ANÁLISIS")
let caso3AFP = calcular(basico: "3000", dias: 30, hijos: true, sistema: .afp,
                        h25: 4, h35: 4, adelantos: "200")
let caso3ONP = calcular(basico: "3000", dias: 30, hijos: true, sistema: .onp,
                        h25: 4, h35: 4, adelantos: "200")
print("  1. Neto ONP \(Formato.soles(caso3ONP.netoAPagar))"
      + " vs neto AFP \(Formato.soles(caso3AFP.netoAPagar))")

let costoEmpresa = caso3AFP.totalRemuneraciones + caso3AFP.aportacionesEmpleador[0].monto
print("  2. Costo empresa \(Formato.soles(costoEmpresa))")

let caso2a27 = calcular(basico: "1800", dias: 27, hijos: true, sistema: .onp)
let caso2a30 = calcular(basico: "1800", dias: 30, hijos: true, sistema: .onp)
print("  3. Neto 27 días \(Formato.soles(caso2a27.netoAPagar))"
      + " vs 30 días \(Formato.soles(caso2a30.netoAPagar))")

let horasExtras = caso3AFP.remuneraciones[2].monto + caso3AFP.remuneraciones[3].monto
print("  4. Horas extras \(Formato.soles(horasExtras))"
      + " de \(Formato.soles(caso3AFP.totalRemuneraciones))")

// MARK: - Resultado

print("\n" + String(repeating: "-", count: 52))
if fallos == 0 {
    print("TODAS LAS PRUEBAS PASARON")
} else {
    print("FALLARON \(fallos) PRUEBAS")
    exit(1)
}
