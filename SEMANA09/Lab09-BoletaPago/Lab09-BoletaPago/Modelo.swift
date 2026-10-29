import Foundation

/// Sistema de pensiones al que está afiliado el trabajador. Son excluyentes:
/// si aporta a la ONP no aporta a una AFP, y viceversa.
enum SistemaPensiones: String, CaseIterable {
    case onp = "ONP"
    case afp = "AFP"
}

/// Lo que el usuario escribe en el formulario, ya convertido a números.
struct DatosEntrada {
    var sueldoBasico: Decimal
    var diasLaborados: Int
    var tieneHijos: Bool
    var sistema: SistemaPensiones
    var nombreAFP: String
    var horasExtras25: Int
    var horasExtras35: Int
    var adelantos: Decimal
}

/// Una línea de la boleta: su nombre y su monto en soles.
struct Concepto: Identifiable {
    let id = UUID()
    let nombre: String
    let monto: Decimal
}

/// La boleta calculada, lista para pintarse. Los tres arrays corresponden a las
/// tres columnas del formato del D.S. 001-98-TR.
struct ResultadoBoleta {
    let remuneraciones: [Concepto]
    let descuentos: [Concepto]
    let aportacionesEmpleador: [Concepto]
    let totalRemuneraciones: Decimal
    let totalDescuentos: Decimal
    let netoAPagar: Decimal

    /// Valor hora sin redondear, solo informativo para la hoja de Excel.
    let valorHora: Decimal
}

/// Conversión entre el texto de los TextField y los números del modelo, y
/// formato de salida en soles. Vive aquí y no en la vista para que las pruebas
/// de consola puedan usar el mismo formato que la pantalla.
enum Formato {
    /// Acepta coma o punto como separador decimal, porque en Perú se escribe
    /// "2,500.50" pero también "2500,50". Devuelve nil si no es un número.
    static func decimal(desde texto: String) -> Decimal? {
        let limpio = texto
            .trimmingCharacters(in: .whitespaces)
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: ",", with: ".")
        guard !limpio.isEmpty else { return nil }
        return Decimal(string: limpio)
    }

    /// Igual que `decimal(desde:)` pero tratando el texto vacío como cero, para
    /// los campos opcionales (horas extras y adelantos).
    static func decimalOCero(desde texto: String) -> Decimal? {
        if texto.trimmingCharacters(in: .whitespaces).isEmpty { return 0 }
        return decimal(desde: texto)
    }

    static func enteroOCero(desde texto: String) -> Int? {
        if texto.trimmingCharacters(in: .whitespaces).isEmpty { return 0 }
        return Int(texto.trimmingCharacters(in: .whitespaces))
    }

    private static let formateador: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.groupingSeparator = ","
        f.decimalSeparator = "."
        f.minimumFractionDigits = 2
        f.maximumFractionDigits = 2
        return f
    }()

    /// "3253.00" -> "3,253.00". Los conceptos que no aplican salen como "0.00",
    /// igual que en la boleta real.
    static func soles(_ monto: Decimal) -> String {
        formateador.string(from: monto as NSDecimalNumber) ?? "0.00"
    }
}
