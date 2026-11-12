import UIKit

/// A9 · Resumen del supervisor: indicadores contra ayer, gráfico de 7 días,
/// ranking de vendedores del mes y productos con stock bajo. Todo sale de
/// fetch requests y no cuenta las ventas anuladas.
final class ResumenViewController: UIViewController {

    private let saludo = UILabel()
    private let rol = UILabel()
    private let indicadorTotal = IndicadorView(titulo: "Vendido hoy")
    private let indicadorCantidad = IndicadorView(titulo: "Ventas de hoy")
    private let grafico = GraficoBarrasView()
    private let ranking = UIStackView()
    private let stockBajo = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        saludo.font = .systemFont(ofSize: 22, weight: .bold)
        saludo.numberOfLines = 0
        rol.textColor = .secondaryLabel

        let indicadores = UIStackView(arrangedSubviews: [indicadorTotal, indicadorCantidad])
        indicadores.spacing = 12
        indicadores.distribution = .fillEqually

        grafico.heightAnchor.constraint(equalToConstant: 190).isActive = true
        ranking.axis = .vertical
        ranking.spacing = 8
        stockBajo.axis = .vertical
        stockBajo.spacing = 8

        let pila = UIStackView(arrangedSubviews: [
            saludo, rol, indicadores,
            titulo("Últimos 7 días"), grafico,
            titulo("Ranking de vendedores del mes"), ranking,
            titulo("Productos con stock bajo (5 o menos)"), stockBajo
        ])
        pila.axis = .vertical
        pila.spacing = 10
        pila.setCustomSpacing(18, after: rol)
        view.fijarEnScroll(pila, margen: 16)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cargar()
    }

    private func titulo(_ texto: String) -> UILabel {
        let etiqueta = UILabel()
        etiqueta.text = texto
        etiqueta.font = .systemFont(ofSize: 17, weight: .semibold)
        return etiqueta
    }

    private func cargar() {
        let usuario = Sesion.shared.usuario
        saludo.text = "Hola, \(usuario?.nombre ?? "")"
        rol.text = usuario?.rol

        let hoy = Fechas.inicioDelDia()
        let ayer = Fechas.sumarDias(-1, a: hoy)

        // Indicadores de hoy contra ayer.
        let ventasHoy = BaseDatos.shared.ventasValidas(desde: hoy)
        let ventasAyer = BaseDatos.shared.ventasValidas(desde: ayer, hasta: hoy)
        let totalHoy = ventasHoy.reduce(0) { $0 + $1.total }
        let totalAyer = ventasAyer.reduce(0) { $0 + $1.total }
        indicadorTotal.valor.text = Formato.soles(totalHoy)
        indicadorTotal.detalle.text = comparacion(hoy: totalHoy, ayer: totalAyer, texto: Formato.soles(totalAyer))
        indicadorCantidad.valor.text = "\(ventasHoy.count)"
        indicadorCantidad.detalle.text = comparacion(hoy: Double(ventasHoy.count), ayer: Double(ventasAyer.count),
                                                     texto: "\(ventasAyer.count)")

        // Gráfico: total vendido por día, de hace 6 días a hoy.
        let formatoDia = DateFormatter()
        formatoDia.locale = Locale(identifier: "es_PE")
        formatoDia.dateFormat = "EEE d"
        grafico.barras = (0..<7).map { indice in
            let inicio = Fechas.sumarDias(indice - 6, a: hoy)
            let fin = Fechas.sumarDias(1, a: inicio)
            let total = BaseDatos.shared.ventasValidas(desde: inicio, hasta: fin).reduce(0) { $0 + $1.total }
            return (formatoDia.string(from: inicio).capitalized, total)
        }

        // Ranking: ventas del mes agrupadas por la relación venta ▸ vendedor.
        let ventasMes = BaseDatos.shared.ventasValidas(desde: Fechas.inicioDelMes())
        let porVendedor = Dictionary(grouping: ventasMes) { $0.vendedor?.nombre ?? "Sin vendedor" }
            .map { (nombre: $0.key, total: $0.value.reduce(0) { $0 + $1.total }, cantidad: $0.value.count) }
            .sorted { $0.total > $1.total }
        ranking.arrangedSubviews.forEach { $0.removeFromSuperview() }
        if porVendedor.isEmpty {
            ranking.addArrangedSubview(fila("Aún no hay ventas este mes", "", color: .secondaryLabel))
        }
        for (posicion, vendedor) in porVendedor.enumerated() {
            ranking.addArrangedSubview(fila("\(posicion + 1). \(vendedor.nombre) · \(vendedor.cantidad) venta(s)",
                                            Formato.soles(vendedor.total)))
        }

        // Stock bajo.
        let productos = BaseDatos.shared.buscar(
            Producto.self,
            predicado: NSPredicate(format: "stock <= %d", Reglas.stockBajo),
            orden: [NSSortDescriptor(key: "stock", ascending: true)]
        )
        stockBajo.arrangedSubviews.forEach { $0.removeFromSuperview() }
        if productos.isEmpty {
            stockBajo.addArrangedSubview(fila("Ningún producto con stock bajo", "", color: .secondaryLabel))
        }
        for producto in productos {
            stockBajo.addArrangedSubview(fila(producto.nombre ?? "", "Stock \(producto.stock)", color: .systemRed))
        }
    }

    private func comparacion(hoy: Double, ayer: Double, texto: String) -> String {
        guard ayer > 0 else { return "Ayer: \(texto)" }
        let cambio = (hoy - ayer) / ayer * 100
        let flecha = cambio >= 0 ? "▲" : "▼"
        return "\(flecha) \(String(format: "%.0f", abs(cambio))) % vs ayer (\(texto))"
    }

    private func fila(_ izquierda: String, _ derecha: String, color: UIColor = .label) -> UIView {
        let a = UILabel()
        a.text = izquierda
        a.numberOfLines = 0
        a.textColor = color == .systemRed ? .label : color
        let b = UILabel()
        b.text = derecha
        b.font = .systemFont(ofSize: 15, weight: .semibold)
        b.textColor = color
        b.textAlignment = .right
        b.setContentCompressionResistancePriority(.required, for: .horizontal)
        let fila = UIStackView(arrangedSubviews: [a, b])
        fila.spacing = 8
        fila.isLayoutMarginsRelativeArrangement = true
        fila.layoutMargins = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
        fila.backgroundColor = .secondarySystemBackground
        fila.layer.cornerRadius = 10
        return fila
    }
}

/// Gráfico de barras dibujado a mano (sin librerías): una barra por día.
final class GraficoBarrasView: UIView {

    var barras: [(etiqueta: String, valor: Double)] = [] {
        didSet { setNeedsDisplay() }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 12
        contentMode = .redraw
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) no se usa") }

    override func draw(_ rect: CGRect) {
        guard !barras.isEmpty else { return }
        let margen: CGFloat = 12
        let altoEtiqueta: CGFloat = 18
        let altoValor: CGFloat = 16
        let ancho = (rect.width - margen * 2) / CGFloat(barras.count)
        let altoMaximo = rect.height - margen * 2 - altoEtiqueta - altoValor
        let maximo = max(barras.map(\.valor).max() ?? 0, 1)

        let atributosEtiqueta: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 10), .foregroundColor: UIColor.secondaryLabel
        ]
        let atributosValor: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 9, weight: .semibold), .foregroundColor: UIColor.label
        ]

        for (indice, barra) in barras.enumerated() {
            let x = margen + CGFloat(indice) * ancho
            let alto = CGFloat(barra.valor / maximo) * altoMaximo
            let base = rect.height - margen - altoEtiqueta
            let rectBarra = CGRect(x: x + ancho * 0.2, y: base - alto, width: ancho * 0.6, height: max(alto, 1))
            let esHoy = indice == barras.count - 1
            (esHoy ? UIColor.tintColor : UIColor.tintColor.withAlphaComponent(0.45)).setFill()
            UIBezierPath(roundedRect: rectBarra, cornerRadius: 4).fill()

            let etiqueta = barra.etiqueta as NSString
            let tamano = etiqueta.size(withAttributes: atributosEtiqueta)
            etiqueta.draw(at: CGPoint(x: x + (ancho - tamano.width) / 2, y: base + 3), withAttributes: atributosEtiqueta)

            if barra.valor > 0 {
                let valor = (barra.valor >= 1000 ? String(format: "%.1fk", barra.valor / 1000)
                                                 : String(format: "%.0f", barra.valor)) as NSString
                let tamanoValor = valor.size(withAttributes: atributosValor)
                valor.draw(at: CGPoint(x: x + (ancho - tamanoValor.width) / 2, y: rectBarra.minY - tamanoValor.height - 1),
                           withAttributes: atributosValor)
            }
        }
    }
}
