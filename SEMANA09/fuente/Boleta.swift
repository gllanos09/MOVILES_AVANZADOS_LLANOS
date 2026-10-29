import Foundation

/// Calcula la boleta de pago a partir de los datos del mes.
///
/// Esta clase es el único lugar donde se hace aritmética. La pantalla la llama
/// y pinta el resultado; no multiplica ni divide nada. Así la app y la hoja de
/// Excel pueden coincidir al centavo.
final class Boleta {
    private let datos: DatosEntrada

    init(datos: DatosEntrada) {
        self.datos = datos
    }

    // MARK: - Redondeo

    /// Redondeo a 2 decimales con medio hacia arriba (0.005 sube), que es lo
    /// mismo que hace ROUND() en Excel. Se usa `Decimal` y no `Double` para que
    /// el resultado sea exacto y no dependa de la representación binaria.
    static func redondear(_ valor: Decimal) -> Decimal {
        var origen = valor
        var resultado = Decimal()
        NSDecimalRound(&resultado, &origen, 2, .plain)
        return resultado
    }

    // MARK: - Validación

    /// Devuelve la lista de problemas encontrados. Si está vacía, se puede
    /// calcular. La pantalla muestra estos mensajes y no calcula nada.
    func validar() -> [String] {
        var errores: [String] = []

        if datos.sueldoBasico <= 0 {
            errores.append("El sueldo básico debe ser mayor que cero.")
        }
        if datos.diasLaborados < 1 || datos.diasLaborados > 30 {
            errores.append("Los días laborados deben estar entre 1 y 30.")
        }
        if datos.horasExtras25 < 0 || datos.horasExtras35 < 0 {
            errores.append("Las horas extras no pueden ser negativas.")
        }
        if datos.adelantos < 0 {
            errores.append("Los adelantos no pueden ser negativos.")
        }
        if datos.sistema == .afp && CatalogoAFP.tasas[datos.nombreAFP] == nil {
            errores.append("Selecciona una AFP válida.")
        }

        return errores
    }

    // MARK: - Cálculo

    /// Aplica las reglas en el orden exacto del enunciado. Cada concepto se
    /// redondea a 2 decimales y luego se suman; los intermedios (el valor hora
    /// y el sueldo diario) van con toda su precisión.
    func calcular() -> ResultadoBoleta {

        // 1. Intermedios: NO se redondean.
        let valorHora = datos.sueldoBasico / Parametros.diasDelMes / Parametros.horasJornada

        // 2. Sueldo computable: solo los días efectivamente laborados.
        let sueldoComputable = Boleta.redondear(
            datos.sueldoBasico / Parametros.diasDelMes * Decimal(datos.diasLaborados)
        )

        // 3. Asignación familiar: monto fijo, no se prorratea por días.
        let asignacionFamiliar = datos.tieneHijos ? Parametros.asignacionFamiliar : 0

        // 4 y 5. Horas extras, con el valor hora del sueldo básico (no del computable).
        let horasExtras25 = Boleta.redondear(
            valorHora * Parametros.recargoHoras25 * Decimal(datos.horasExtras25)
        )
        let horasExtras35 = Boleta.redondear(
            valorHora * Parametros.recargoHoras35 * Decimal(datos.horasExtras35)
        )

        // 6. Total de remuneraciones: suma de conceptos ya redondeados.
        let totalRemuneraciones =
            sueldoComputable + asignacionFamiliar + horasExtras25 + horasExtras35

        // 7. Pensión. ONP y AFP son excluyentes: la que no aplica queda en 0.00
        //    y se muestra igual, como en la boleta real.
        var descuentoONP: Decimal = 0
        var afpFondo: Decimal = 0
        var afpComision: Decimal = 0
        var afpSeguro: Decimal = 0

        switch datos.sistema {
        case .onp:
            descuentoONP = Boleta.redondear(totalRemuneraciones * Parametros.tasaONP)
        case .afp:
            if let tasas = CatalogoAFP.tasas[datos.nombreAFP] {
                afpFondo = Boleta.redondear(totalRemuneraciones * tasas.fondo)
                afpComision = Boleta.redondear(totalRemuneraciones * tasas.comision)
                afpSeguro = Boleta.redondear(totalRemuneraciones * tasas.seguro)
            }
        }

        // 8. Total de descuentos: pensión más los adelantos tal cual.
        let adelantos = Boleta.redondear(datos.adelantos)
        let totalDescuentos = descuentoONP + afpFondo + afpComision + afpSeguro + adelantos

        // 9. Neto a pagar.
        let netoAPagar = totalRemuneraciones - totalDescuentos

        // 10. EsSalud: lo paga el empleador, nunca se descuenta al trabajador.
        let esSalud = Boleta.redondear(totalRemuneraciones * Parametros.tasaEsSalud)

        return ResultadoBoleta(
            remuneraciones: [
                Concepto(nombre: "Sueldo computable", monto: sueldoComputable),
                Concepto(nombre: "Asignación familiar", monto: asignacionFamiliar),
                Concepto(nombre: "Horas extras 25%", monto: horasExtras25),
                Concepto(nombre: "Horas extras 35%", monto: horasExtras35)
            ],
            descuentos: [
                Concepto(nombre: "ONP", monto: descuentoONP),
                Concepto(nombre: "AFP fondo", monto: afpFondo),
                Concepto(nombre: "AFP comisión", monto: afpComision),
                Concepto(nombre: "AFP seguro", monto: afpSeguro),
                Concepto(nombre: "Adelantos", monto: adelantos)
            ],
            aportacionesEmpleador: [
                Concepto(nombre: "EsSalud (9%)", monto: esSalud)
            ],
            totalRemuneraciones: totalRemuneraciones,
            totalDescuentos: totalDescuentos,
            netoAPagar: netoAPagar,
            valorHora: valorHora
        )
    }
}
