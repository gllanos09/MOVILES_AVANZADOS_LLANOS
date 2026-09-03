// Desarrollado por: Gabriel Llanos
import Foundation

// ===== EJEMPLO RESUELTO: Sistema de notas =====
var notasPa: [String: Double] = [:]
var notasPb: [String: Double] = [:]

print("¿Cuántos alumnos?")
let cantidad = Int(readLine() ?? "") ?? 0

for i in 1...cantidad {
    print("\nAlumno \(i) - Nombre:")
    let nombre = readLine() ?? ""
    print("Nota Pa:")
    let pa = Double(readLine() ?? "") ?? 0
    print("Nota Pb:")
    let pb = Double(readLine() ?? "") ?? 0
    notasPa[nombre] = pa
    notasPb[nombre] = pb
}

print("\n===== REPORTE =====")
var totalAprobados = 0
var sumaGeneral = 0.0

for (alumno, pa) in notasPa {
    if let pb = notasPb[alumno] {
        let notaFinal = 0.30 * pa + 0.70 * pb
        let estado = notaFinal >= 13.0 ? "Aprobado" : "Desaprobado"
        print("\(alumno): Pa=\(pa) Pb=\(pb) Final=\(notaFinal) → \(estado)")
        sumaGeneral += notaFinal
        if notaFinal >= 13.0 { totalAprobados += 1 }
    }
}

print("Promedio general: \(sumaGeneral / Double(notasPa.count))")
print("Aprobados: \(totalAprobados) de \(notasPa.count)")

// ===== TODO 10: Inventario de productos =====
var precios: [String: Double] = [:]
var stocks: [String: Int] = [:]

print("\n¿Cuántos productos?")
let n = Int(readLine() ?? "") ?? 0

for i in 1...n {
    print("Producto \(i) - Nombre:")
    let nombre = readLine() ?? ""
    print("Precio:")
    let precio = Double(readLine() ?? "") ?? 0
    print("Stock:")
    let stock = Int(readLine() ?? "") ?? 0
    precios[nombre] = precio
    stocks[nombre] = stock
}

// Calcular valor total (precio × stock)
var valorTotal = 0.0
for (nombre, precio) in precios {
    let stock = stocks[nombre] ?? 0
    valorTotal += precio * Double(stock)
}
print("\nValor total del inventario: S/. \(String(format: "%.2f", valorTotal))")

// Mostrar productos con stock < 5
print("\n===== STOCK BAJO (< 5) =====")
for (nombre, stock) in stocks {
    if stock < 5 {
        print("\(nombre): \(stock) unidades")
    }
}
