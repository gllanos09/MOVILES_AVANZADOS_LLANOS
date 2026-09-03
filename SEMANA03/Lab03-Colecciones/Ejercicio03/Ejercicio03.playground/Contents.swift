// Desarrollado por: [TU NOMBRE]
import Foundation

// ===== EJEMPLO RESUELTO =====
var alumnosIOS: Set<String> = []

print("===== ALUMNOS iOS =====")
for i in 1...3 {
    print("Alumno \(i):")
    let nombre = readLine() ?? ""
    alumnosIOS.insert(nombre)
}

var alumnosAndroid: Set<String> = []

print("\n===== ALUMNOS ANDROID =====")
for i in 1...3 {
    print("Alumno \(i):")
    let nombre = readLine() ?? ""
    alumnosAndroid.insert(nombre)
}

let enAmbos    = alumnosIOS.intersection(alumnosAndroid)
let todos      = alumnosIOS.union(alumnosAndroid)
let soloIOS    = alumnosIOS.subtracting(alumnosAndroid)
let soloAndroid = alumnosAndroid.subtracting(alumnosIOS)

print("\n===== RESULTADOS =====")
print("En ambos: \(enAmbos)")
print("Solo iOS: \(soloIOS)")
print("Solo Android: \(soloAndroid)")
print("Total únicos: \(todos.count)")

// ===== TODO 8: Eliminar duplicados =====
var numerosArr: [Int] = []
for i in 1...8 {
    print("Número \(i):")
    let n = Int(readLine() ?? "") ?? 0
    numerosArr.append(n)
}
print("Con duplicados: \(numerosArr)")
let sinDuplicados = Array(Set(numerosArr)).sorted()
print("Sin duplicados: \(sinDuplicados)")

// ===== TODO 9: Comparar asistencia =====
var lunes: Set<String> = []
var martes: Set<String> = []

print("\n===== ASISTENCIA LUNES =====")
for i in 1...4 {
    print("Nombre \(i):")
    lunes.insert(readLine() ?? "")
}

print("\n===== ASISTENCIA MARTES =====")
for i in 1...4 {
    print("Nombre \(i):")
    martes.insert(readLine() ?? "")
}

print("Ambos días: \(lunes.intersection(martes))")
print("Solo lunes: \(lunes.subtracting(martes))")
print("Solo martes: \(martes.subtracting(lunes))")

// ===== PREDICT =====
let a: Set = [1, 2, 3, 4, 5]
let b: Set = [4, 5, 6, 7, 8]
print(a.intersection(b))       // PREDICT 5: 4,5
print(a.union(b).count)        // PREDICT 6: 8
print(a.subtracting(b))        // PREDICT 7: 1, 2, 3

var repetidos: Set = ["A", "B", "A", "C", "B"]
print(repetidos.count)         // PREDICT 8: 3
