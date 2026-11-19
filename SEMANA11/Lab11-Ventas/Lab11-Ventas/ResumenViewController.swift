import UIKit

/// A9 · Resumen del supervisor: saludo, indicadores contra ayer, gráfico de 7 días,
/// ranking de vendedores del mes y productos con stock bajo. Todo sale de
/// fetch requests y no cuenta las ventas anuladas. La pantalla está en Main.storyboard;
/// las filas del ranking y del stock bajo se agregan aquí porque dependen de los datos.
final class ResumenViewController: UIViewController {

    @IBOutlet private weak var fecha: UILabel!
    @IBOutlet private weak var saludo: UILabel!
    @IBOutlet private weak var rol: Pastilla!
    @IBOutlet private weak var indicadorTotal: IndicadorView!
    @IBOutlet private weak var indicadorIGV: IndicadorView!
    @IBOutlet private weak var grafico: GraficoBarrasView!
    @IBOutlet private weak var ranking: UIStackView!
    @IBOutlet private weak var stockBajo: UIStackView!

    private static let formatoFecha: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "es_PE")
        f.dateFormat = "EEEE d 'de' MMMM"
        return f
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cargar()
    }

    private func cargar() {
        // ① Saludo con nombre y rol.
        let usuario = Sesion.shared.usuario
        let primerNombre = usuario?.nombre?.split(separator: " ").first.map(String.init) ?? ""
        let textoFecha = ResumenViewController.formatoFecha.string(from: Date())
        fecha.text = textoFecha.prefix(1).uppercased() + textoFecha.dropFirst()
        saludo.text = "Hola, \(primerNombre)"
        rol.pintar(usuario?.rol ?? "", .systemPurple)

        let hoy = Fechas.inicioDelDia()
        let ayer = Fechas.sumarDias(-1, a: hoy)

        // ② Indicadores: vendido hoy contra ayer, e IGV de las ventas del mes.
        let totalHoy = BaseDatos.shared.ventasValidas(desde: hoy).reduce(0) { $0 + $1.total }
        let totalAyer = BaseDatos.shared.ventasValidas(desde: ayer, hasta: hoy).reduce(0) { $0 + $1.total }
        indicadorTotal.valor.text = Formato.soles(totalHoy)
        indicadorTotal.detalle.text = comparacion(hoy: totalHoy, ayer: totalAyer)
        indicadorTotal.detalle.textColor = totalHoy >= totalAyer ? .systemGreen : .systemRed

        let ventasMes = BaseDatos.shared.ventasValidas(desde: Fechas.inicioDelMes())
        indicadorIGV.valor.text = Formato.soles(ventasMes.reduce(0) { $0 + $1.igv })
        indicadorIGV.detalle.text = "\(ventasMes.count) venta(s) del mes"

        // ③ Gráfico: total vendido por día, de hace 6 días a hoy (L M X J V S D).
        let letras = ["D", "L", "M", "X", "J", "V", "S"]   // en Calendar el domingo es 1
        grafico.barras = (0..<7).map { indice in
            let inicio = Fechas.sumarDias(indice - 6, a: hoy)
            let fin = Fechas.sumarDias(1, a: inicio)
            let total = BaseDatos.shared.ventasValidas(desde: inicio, hasta: fin).reduce(0) { $0 + $1.total }
            return (letras[Fechas.calendario.component(.weekday, from: inicio) - 1], total)
        }

        // ④ Ranking: ventas del mes agrupadas por la relación venta ▸ vendedor.
        let porVendedor = Dictionary(grouping: ventasMes) { $0.vendedor?.nombre ?? "Sin vendedor" }
            .map { (nombre: $0.key, total: $0.value.reduce(0) { $0 + $1.total }) }
            .sorted { $0.total > $1.total }
        ranking.arrangedSubviews.forEach { $0.removeFromSuperview() }
        if porVendedor.isEmpty {
            ranking.addArrangedSubview(texto("Aún no hay ventas este mes", color: .secondaryLabel))
        }
        let maximo = max(porVendedor.first?.total ?? 0, 1)
        for vendedor in porVendedor {
            ranking.addArrangedSubview(filaRanking(vendedor.nombre, vendedor.total, progreso: vendedor.total / maximo))
        }

        // ⑤ Productos con stock bajo.
        let productos = BaseDatos.shared.buscar(
            Producto.self,
            predicado: NSPredicate(format: "stock <= %d", Reglas.stockBajo),
            orden: [NSSortDescriptor(key: "stock", ascending: true)]
        )
        stockBajo.arrangedSubviews.forEach { $0.removeFromSuperview() }
        if productos.isEmpty {
            stockBajo.addArrangedSubview(texto("Ningún producto con stock bajo", color: .secondaryLabel))
        }
        for producto in productos {
            stockBajo.addArrangedSubview(filaStock(producto))
        }
    }

    private func comparacion(hoy: Double, ayer: Double) -> String {
        guard ayer > 0 else { return "Ayer: \(Formato.soles(ayer))" }
        let cambio = (hoy - ayer) / ayer * 100
        let flecha = cambio >= 0 ? "▲" : "▼"
        return "\(flecha) \(String(format: "%.0f", abs(cambio)))% vs ayer"
    }

    private func texto(_ cadena: String, color: UIColor = .label) -> UILabel {
        let etiqueta = UILabel()
        etiqueta.text = cadena
        etiqueta.font = .systemFont(ofSize: 14)
        etiqueta.textColor = color
        etiqueta.numberOfLines = 0
        return etiqueta
    }

    /// "Carlos Ruiz · S/ 2,940.10" y una barra proporcional al primero del ranking.
    private func filaRanking(_ nombre: String, _ total: Double, progreso: Double) -> UIView {
        let etiqueta = UILabel()
        let texto = NSMutableAttributedString(string: nombre,
                                              attributes: [.font: UIFont.systemFont(ofSize: 13, weight: .semibold)])
        texto.append(NSAttributedString(string: " · \(Formato.soles(total))",
                                        attributes: [.font: UIFont.systemFont(ofSize: 13),
                                                     .foregroundColor: UIColor.secondaryLabel]))
        etiqueta.attributedText = texto
        let barra = UIProgressView(progressViewStyle: .default)
        barra.progress = Float(progreso)
        let pila = UIStackView(arrangedSubviews: [etiqueta, barra])
        pila.axis = .vertical
        pila.spacing = 6
        return pila
    }

    /// "Teclado mecánico · 4 u." con la pastilla Reponer.
    private func filaStock(_ producto: Producto) -> UIView {
        let etiqueta = texto("\(producto.nombre ?? "") · \(producto.stock) u.")
        etiqueta.font = .systemFont(ofSize: 15, weight: .semibold)
        let reponer = Pastilla()
        reponer.font = .systemFont(ofSize: 11, weight: .bold)
        reponer.textColor = .white
        reponer.pintar("Reponer", .systemRed)
        reponer.setContentHuggingPriority(.required, for: .horizontal)
        reponer.setContentCompressionResistancePriority(.required, for: .horizontal)
        let fila = UIStackView(arrangedSubviews: [etiqueta, reponer])
        fila.spacing = 8
        fila.alignment = .center
        return fila
    }
}

/// Gráfico de barras dibujado a mano (sin librerías): una barra por día, hoy resaltado.
/// En Main.storyboard es una vista con esta clase dentro de la tarjeta del gráfico.
final class GraficoBarrasView: UIView {

    var barras: [(etiqueta: String, valor: Double)] = [] {
        didSet { setNeedsDisplay() }
    }

    override func draw(_ rect: CGRect) {
        guard !barras.isEmpty else { return }
        let altoEtiqueta: CGFloat = 16
        let ancho = rect.width / CGFloat(barras.count)
        let altoMaximo = rect.height - altoEtiqueta - 4
        let maximo = max(barras.map(\.valor).max() ?? 0, 1)
        let atributos: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 10), .foregroundColor: UIColor.secondaryLabel
        ]

        for (indice, barra) in barras.enumerated() {
            let x = CGFloat(indice) * ancho
            let alto = CGFloat(barra.valor / maximo) * altoMaximo
            let base = rect.height - altoEtiqueta
            let rectBarra = CGRect(x: x + ancho * 0.15, y: base - alto, width: ancho * 0.7, height: max(alto, 2))
            let esHoy = indice == barras.count - 1
            (esHoy ? UIColor.tintColor : UIColor.tintColor.withAlphaComponent(0.25)).setFill()
            UIBezierPath(roundedRect: rectBarra, cornerRadius: 3).fill()

            let etiqueta = barra.etiqueta as NSString
            let tamano = etiqueta.size(withAttributes: atributos)
            etiqueta.draw(at: CGPoint(x: x + (ancho - tamano.width) / 2, y: base + 3), withAttributes: atributos)
        }
    }
}
