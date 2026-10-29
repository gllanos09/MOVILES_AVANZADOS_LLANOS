import Foundation

/// Parámetros legales del cálculo. Ningún porcentaje se escribe dentro de una
/// fórmula: todos viven aquí, igual que en la hoja "Parametros" del Excel.
///
/// Fuentes y fecha de consulta: 29/10/2026
/// - RMV S/ 1,230.00      D.S. de la RMV, vigente desde el 01/10/2026
/// - Asignación familiar  Ley 25129 (10% de la RMV)
/// - ONP 13%              D.L. 19990
/// - EsSalud 9%           Ley 26790
/// - Horas extras         25% las primeras horas, 35% las siguientes
enum Parametros {
    static let rmv = Decimal(string: "1230.00")!
    static let tasaAsignacionFamiliar = Decimal(string: "0.10")!
    static let tasaONP = Decimal(string: "0.13")!
    static let tasaEsSalud = Decimal(string: "0.09")!
    static let recargoHoras25 = Decimal(string: "1.25")!
    static let recargoHoras35 = Decimal(string: "1.35")!

    /// Días del mes y horas de jornada usados como divisores legales.
    static let diasDelMes = Decimal(30)
    static let horasJornada = Decimal(8)

    /// S/ 123.00 con la RMV vigente. No se prorratea por días laborados.
    static var asignacionFamiliar: Decimal {
        Boleta.redondear(rmv * tasaAsignacionFamiliar)
    }
}

/// Las tres tasas que una AFP descuenta sobre el total de remuneraciones.
struct TasasAFP {
    let fondo: Decimal
    let comision: Decimal
    let seguro: Decimal
}

/// Diccionario de AFP. Para agregar una AFP real, consulta las tasas vigentes
/// publicadas por la SBS y añade una entrada aquí: el Picker de la pantalla se
/// alimenta de `nombres`, así que no hay que tocar la vista.
enum CatalogoAFP {
    static let tasas: [String: TasasAFP] = [
        "AFP Ejemplo": TasasAFP(
            fondo: Decimal(string: "0.1000")!,
            comision: Decimal(string: "0.0160")!,
            seguro: Decimal(string: "0.0135")!
        )
    ]

    /// Orden estable para el Picker (un diccionario no garantiza orden).
    static let nombres = tasas.keys.sorted()

    static let porDefecto = "AFP Ejemplo"
}
