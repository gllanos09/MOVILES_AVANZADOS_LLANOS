import SwiftUI
import UIKit

/// Pantalla única: formulario arriba y, al pulsar Calcular, la boleta debajo.
///
/// Esta vista no hace ninguna operación aritmética. Convierte el texto de los
/// campos a números, le pide el cálculo a `Boleta` y pinta lo que recibe.
struct ContentView: View {

    // Nivel 1
    @State private var sueldoBasico = ""
    @State private var diasLaborados = "30"
    @State private var tieneHijos = false
    @State private var sistema: SistemaPensiones = .onp

    // Nivel 2
    @State private var nombreAFP = CatalogoAFP.porDefecto
    @State private var horasExtras25 = ""
    @State private var horasExtras35 = ""
    @State private var adelantos = ""

    // Salida
    @State private var resultado: ResultadoBoleta?
    @State private var errores: [String] = []

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                encabezado
                formulario
                botonCalcular

                if !errores.isEmpty {
                    mensajesDeError
                }

                if let boleta = resultado {
                    bloquesDeBoleta(boleta)
                }
            }
            .padding(20)
        }
    }

    // MARK: - Encabezado

    private var encabezado: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Boleta de ejemplo")
                .font(.title2)
                .bold()
            Text("Datos ficticios con fines académicos")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }

    // MARK: - Formulario

    private var formulario: some View {
        VStack(alignment: .leading, spacing: 14) {

            CampoTexto(titulo: "Sueldo básico (S/)",
                       texto: $sueldoBasico,
                       teclado: .decimalPad)

            CampoTexto(titulo: "Días laborados (1 a 30)",
                       texto: $diasLaborados,
                       teclado: .numberPad)

            VStack(alignment: .leading, spacing: 6) {
                Text("¿Tiene hijos?")
                    .font(.subheadline)
                Picker("¿Tiene hijos?", selection: $tieneHijos) {
                    Text("No").tag(false)
                    Text("Sí").tag(true)
                }
                .pickerStyle(.segmented)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("Sistema de pensiones")
                    .font(.subheadline)
                Picker("Sistema de pensiones", selection: $sistema) {
                    ForEach(SistemaPensiones.allCases, id: \.self) { opcion in
                        Text(opcion.rawValue).tag(opcion)
                    }
                }
                .pickerStyle(.segmented)
            }

            // Solo aparece si eligió AFP, como pide el enunciado.
            if sistema == .afp {
                VStack(alignment: .leading, spacing: 6) {
                    Text("AFP")
                        .font(.subheadline)
                    Picker("AFP", selection: $nombreAFP) {
                        ForEach(CatalogoAFP.nombres, id: \.self) { nombre in
                            Text(nombre).tag(nombre)
                        }
                    }
                    .pickerStyle(.menu)
                }
            }

            CampoTexto(titulo: "Horas extras al 25%",
                       texto: $horasExtras25,
                       teclado: .numberPad)

            CampoTexto(titulo: "Horas extras al 35%",
                       texto: $horasExtras35,
                       teclado: .numberPad)

            CampoTexto(titulo: "Adelantos (S/)",
                       texto: $adelantos,
                       teclado: .decimalPad)
        }
    }

    private var botonCalcular: some View {
        Button(action: calcular) {
            Text("Calcular")
                .bold()
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.accentColor)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }

    private var mensajesDeError: some View {
        VStack(alignment: .leading, spacing: 6) {
            ForEach(errores, id: \.self) { mensaje in
                Text(mensaje)
                    .font(.footnote)
                    .foregroundColor(.red)
            }
        }
    }

    // MARK: - Boleta

    /// Las tres columnas del formato real. En el celular van una debajo de otra.
    private func bloquesDeBoleta(_ boleta: ResultadoBoleta) -> some View {
        VStack(alignment: .leading, spacing: 18) {

            bloque(titulo: "REMUNERACIONES",
                   conceptos: boleta.remuneraciones,
                   totalNombre: "Total remuneraciones",
                   totalMonto: boleta.totalRemuneraciones)

            bloque(titulo: "RETENCIONES / DESCUENTOS",
                   conceptos: boleta.descuentos,
                   totalNombre: "Total descuentos",
                   totalMonto: boleta.totalDescuentos)

            bloque(titulo: "APORTACIONES DEL EMPLEADOR",
                   conceptos: boleta.aportacionesEmpleador,
                   totalNombre: nil,
                   totalMonto: nil)

            Text("NETO A PAGAR:  S/ \(Formato.soles(boleta.netoAPagar))")
                .font(.title3)
                .bold()
                .padding(.top, 4)
        }
    }

    private func bloque(
        titulo: String,
        conceptos: [Concepto],
        totalNombre: String?,
        totalMonto: Decimal?
    ) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(titulo)
                .font(.caption)
                .bold()
                .foregroundColor(.secondary)

            // Los conceptos que no aplican se muestran en 0.00, como en la
            // boleta real: no se ocultan.
            ForEach(conceptos) { concepto in
                FilaConcepto(nombre: concepto.nombre,
                             monto: concepto.monto,
                             destacada: false)
            }

            if let nombre = totalNombre, let monto = totalMonto {
                FilaConcepto(nombre: nombre, monto: monto, destacada: true)
            }
        }
    }

    // MARK: - Acción

    /// Convierte el texto a números y, si todo es válido, pide el cálculo.
    /// Si algo está mal, muestra los mensajes y no calcula.
    private func calcular() {
        var problemas: [String] = []

        let basico = Formato.decimal(desde: sueldoBasico)
        if basico == nil {
            problemas.append("Escribe el sueldo básico como número, por ejemplo 2500.00")
        }

        let dias = Int(diasLaborados.trimmingCharacters(in: .whitespaces))
        if dias == nil {
            problemas.append("Los días laborados deben ser un número entero.")
        }

        let horas25 = Formato.enteroOCero(desde: horasExtras25)
        if horas25 == nil {
            problemas.append("Las horas extras al 25% deben ser un número entero.")
        }

        let horas35 = Formato.enteroOCero(desde: horasExtras35)
        if horas35 == nil {
            problemas.append("Las horas extras al 35% deben ser un número entero.")
        }

        let montoAdelantos = Formato.decimalOCero(desde: adelantos)
        if montoAdelantos == nil {
            problemas.append("Escribe los adelantos como número, por ejemplo 200.00")
        }

        guard let basico = basico,
              let dias = dias,
              let horas25 = horas25,
              let horas35 = horas35,
              let montoAdelantos = montoAdelantos else {
            errores = problemas
            resultado = nil
            return
        }

        let datos = DatosEntrada(
            sueldoBasico: basico,
            diasLaborados: dias,
            tieneHijos: tieneHijos,
            sistema: sistema,
            nombreAFP: nombreAFP,
            horasExtras25: horas25,
            horasExtras35: horas35,
            adelantos: montoAdelantos
        )

        let boleta = Boleta(datos: datos)
        let encontrados = boleta.validar()

        if !encontrados.isEmpty {
            errores = encontrados
            resultado = nil
            return
        }

        errores = []
        resultado = boleta.calcular()
    }
}

// MARK: - Piezas reutilizables

/// Un rótulo con su TextField. Solo agrupa controles de la lista autorizada.
private struct CampoTexto: View {
    let titulo: String
    @Binding var texto: String
    let teclado: UIKeyboardType

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(titulo)
                .font(.subheadline)
            TextField("0", text: $texto)
                .keyboardType(teclado)
                .padding(10)
                .background(Color.secondary.opacity(0.12))
                .cornerRadius(8)
        }
    }
}

/// Una línea de la boleta: concepto a la izquierda, monto a la derecha.
private struct FilaConcepto: View {
    let nombre: String
    let monto: Decimal
    let destacada: Bool

    var body: some View {
        // El monto se empuja a la derecha con un frame, sin usar Spacer, para
        // no salir de los controles que el enunciado autoriza.
        HStack {
            Text(nombre)
                .fontWeight(destacada ? .bold : .regular)
            Text(Formato.soles(monto))
                .fontWeight(destacada ? .bold : .regular)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .font(.subheadline)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
