import Foundation

/// Reglas de negocio del caso Ventas. Las pantallas no calculan nada por su cuenta:
/// todo pasa por aquí para que los montos coincidan con los casos de prueba.
enum Reglas {
    static let tasaIGV = 0.18
    static let descuentoVIP = 0.10
    static let umbralFrecuente = 1_000.0
    static let umbralVIP = 5_000.0
    static let stockBajo = 5      // 5 o menos: rojo
    static let stockMedio = 10    // 6 a 10: ámbar; más de 10: verde

    enum Categoria: String {
        case regular = "Regular"
        case frecuente = "Frecuente"
        case vip = "VIP"

        /// Calculada con lo comprado en ventas no anuladas, no se guarda.
        init(totalComprado: Double) {
            if totalComprado >= Reglas.umbralVIP {
                self = .vip
            } else if totalComprado >= Reglas.umbralFrecuente {
                self = .frecuente
            } else {
                self = .regular
            }
        }
    }

    struct ResumenVenta {
        let subtotal: Double
        let descuento: Double
        let igv: Double
        let total: Double
    }

    /// Subtotal = precio × cantidad; descuento 10 % solo para VIP;
    /// IGV 18 % sobre (subtotal − descuento); total = subtotal − descuento + IGV.
    static func calcular(precio: Double, cantidad: Int, categoria: Categoria) -> ResumenVenta {
        let subtotal = redondear(precio * Double(cantidad))
        let descuento = categoria == .vip ? redondear(subtotal * descuentoVIP) : 0
        let igv = redondear((subtotal - descuento) * tasaIGV)
        let total = redondear(subtotal - descuento + igv)
        return ResumenVenta(subtotal: subtotal, descuento: descuento, igv: igv, total: total)
    }

    /// Redondeo a 2 decimales, medio hacia arriba. El pequeño margen evita que
    /// un valor como 52.045 guardado en binario como 52.04499… baje en lugar de subir.
    static func redondear(_ valor: Double) -> Double {
        (valor * 100 + (valor >= 0 ? 1e-7 : -1e-7)).rounded(.toNearestOrAwayFromZero) / 100
    }
}

enum Formato {
    private static let numero: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.locale = Locale(identifier: "en_US")
        f.minimumFractionDigits = 2
        f.maximumFractionDigits = 2
        return f
    }()

    private static let fechaHora: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "es_PE")
        f.dateFormat = "dd/MM/yyyy HH:mm"
        return f
    }()

    static func soles(_ monto: Double) -> String {
        "S/ " + (numero.string(from: NSNumber(value: monto)) ?? "0.00")
    }

    static func fecha(_ fecha: Date?) -> String {
        guard let fecha = fecha else { return "" }
        return fechaHora.string(from: fecha)
    }

    /// Acepta coma o punto como separador decimal.
    static func decimal(_ texto: String?) -> Double? {
        let limpio = (texto ?? "").trimmingCharacters(in: .whitespaces)
            .replacingOccurrences(of: ",", with: ".")
        return Double(limpio)
    }
}

enum Fechas {
    static var calendario: Calendar { Calendar.current }

    static func inicioDelDia(_ fecha: Date = Date()) -> Date {
        calendario.startOfDay(for: fecha)
    }

    static func inicioDelMes(_ fecha: Date = Date()) -> Date {
        calendario.dateInterval(of: .month, for: fecha)?.start ?? inicioDelDia(fecha)
    }

    static func sumarDias(_ dias: Int, a fecha: Date) -> Date {
        calendario.date(byAdding: .day, value: dias, to: fecha) ?? fecha
    }
}
