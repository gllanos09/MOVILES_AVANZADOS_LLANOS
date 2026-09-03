// Desarrollado por: Gabriel Llanos
import Foundation

var notas: [Double] = []

for i in 1...3 {
    print("Ingrese la nota \(i):")
    let entrada = readLine() ?? ""
    let nota = Double(entrada) ?? 0
    notas.append(nota)
}

print("\nNotas ingresadas: \(notas)")
print("Total de notas: \(notas.count)")

var suma = 0.0
for nota in notas {
    suma += nota
}
let promedio = suma / Double(notas.count)

print("Suma: \(suma)")
print("Promedio: \(promedio)")
print("Nota más alta: \(notas.max()!)")
print("Nota más baja: \(notas.min()!)")
print("Notas ordenadas: \(notas.sorted())")

// ===== TODO 1: Registro de 5 alumnos =====
var alumnos: [String] = []
for i in 1...5 {
    print("Nombre del alumno \(i):")
    let nombre = readLine() ?? ""
    alumnos.append(nombre)
}
print("Alumnos: \(alumnos)")

// ===== TODO 2: Buscar un alumno =====
print("Buscar alumno:")
let buscar = readLine() ?? ""
if alumnos.contains(buscar) {
    print("\(buscar) está en la lista")
} else {
    print("\(buscar) NO está en la lista")
}

// ===== TODO 3: Notas con clasificación =====
var notasClase: [Double] = []
for i in 1...5 {
    print("Nota del alumno \(i):")
    let n = Double(readLine() ?? "") ?? 0
    notasClase.append(n)
}

var aprobados = 0
var desaprobados = 0
var sumaNotas = 0.0
for nota in notasClase {
    sumaNotas += nota
    if nota >= 13 {
        aprobados += 1
    } else {
        desaprobados += 1
    }
}

print("Promedio: \(sumaNotas / Double(notasClase.count))")
print("Aprobados: \(aprobados), Desaprobados: \(desaprobados)")


// ===== FIX =====
var frutas = ["Manzana", "Plátano", "Naranja"]
frutas.append("Uva")           // FIX 1: el array no contiene números

var colores = ["Rojo", "Azul", "Verde"]  // FIX 2: no existe el color amarillo
colores.append("Amarillo")

let numeros = [10, 20, 30, 40, 50]
print(numeros[4])              // FIX 3: no existe 5


// ===== PREDICT =====
var lista = [1, 2, 3, 4, 5]
lista.remove(at: 0)
lista.append(6)
print(lista)         // PREDICT 1: __
print(lista.count)   // PREDICT 2: __

var nombres = ["Ana", "Carlos", "Beto"]
print(nombres.sorted()) // PREDICT 3: __
print(nombres)          // PREDICT 4: __
