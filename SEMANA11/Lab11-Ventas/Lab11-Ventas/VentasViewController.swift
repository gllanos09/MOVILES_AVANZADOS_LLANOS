import UIKit

/// A6 · Mis ventas (vendedor: solo las suyas, sin anular).
/// A7 · Ventas del equipo (supervisor: todas, chips por vendedor y deslizar para Anular).
/// A8 · La anulación se pide con una alerta que exige motivo.
/// En Main.storyboard hay dos escenas con esta clase: "Mis ventas" (indicadores) y
/// "Ventas" (chips por vendedor). La segunda tiene el atributo Es Equipo = On.
final class VentasViewController: UIViewController {

    enum Modo { case propias, equipo }

    /// Se marca en el Attributes inspector del storyboard (User Defined Runtime Attribute).
    @IBInspectable var esEquipo: Bool = false

    private var modo: Modo { esEquipo ? .equipo : .propias }

    @IBOutlet private weak var tabla: UITableView!
    @IBOutlet private weak var periodo: UISegmentedControl!
    // Solo existen en una de las dos escenas: chips en Ventas, indicadores en Mis ventas.
    @IBOutlet private weak var chips: ChipsView?
    @IBOutlet private weak var indicadorHoy: IndicadorView?
    @IBOutlet private weak var indicadorMes: IndicadorView?
    @IBOutlet private weak var buscador: UISearchBar!

    private var ventas: [Venta] = []
    private var vendedores: [Usuario] = []

    private var seleccionDeChip: Int { chips?.seleccion ?? 0 }

    override func viewDidLoad() {
        super.viewDidLoad()

        ponerBotonDeCuenta()   // iniciales del usuario arriba a la derecha (CR / LP en la maqueta)
        chips?.alCambiar = { [weak self] _ in self?.cargar() }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if modo == .equipo { actualizarVendedores() }
        cargar()
    }

    /// Chips: "Todos" más cada usuario con rol Vendedor o con ventas registradas.
    private func actualizarVendedores() {
        let anterior = seleccionDeChip > 0 && seleccionDeChip <= vendedores.count ? vendedores[seleccionDeChip - 1] : nil
        vendedores = BaseDatos.shared.buscar(
            Usuario.self,
            predicado: NSPredicate(format: "rol == %@ OR ventas.@count > 0", Rol.vendedor.rawValue),
            orden: [NSSortDescriptor(key: "nombre", ascending: true)]
        )
        let indice = anterior.flatMap { vendedores.firstIndex(of: $0) }.map { $0 + 1 } ?? 0
        chips?.configurar(opciones: ["Todos"] + vendedores.map { $0.nombre ?? "" }, seleccion: indice)
    }

    /// Value Changed del segmented Todas / Hoy / Mes.
    @IBAction private func filtroCambio() {
        cargar()
    }

    /// Filtros con NSPredicate: vendedor (relación), periodo (fechas) y cliente (relación).
    private func cargar() {
        var condiciones: [NSPredicate] = []

        switch modo {
        case .propias:
            if let usuario = Sesion.shared.usuario {
                condiciones.append(NSPredicate(format: "vendedor == %@", usuario))
            }
        case .equipo:
            if seleccionDeChip > 0 && seleccionDeChip <= vendedores.count {
                condiciones.append(NSPredicate(format: "vendedor == %@", vendedores[seleccionDeChip - 1]))
            }
        }

        switch periodo.selectedSegmentIndex {
        case 1: condiciones.append(NSPredicate(format: "fecha >= %@", Fechas.inicioDelDia() as NSDate))
        case 2: condiciones.append(NSPredicate(format: "fecha >= %@", Fechas.inicioDelMes() as NSDate))
        default: break
        }

        let texto = (buscador.text ?? "").trimmingCharacters(in: .whitespaces)
        if !texto.isEmpty {
            condiciones.append(NSPredicate(format: "cliente.nombre CONTAINS[cd] %@", texto))
        }

        ventas = BaseDatos.shared.buscar(
            Venta.self,
            predicado: NSCompoundPredicate(andPredicateWithSubpredicates: condiciones),
            orden: [NSSortDescriptor(key: "fecha", ascending: false)]
        )
        tabla.reloadData()
        if modo == .propias { actualizarIndicadores() }
    }

    /// Indicadores propios de hoy y del mes, sin contar las ventas anuladas.
    private func actualizarIndicadores() {
        guard let usuario = Sesion.shared.usuario else { return }
        let hoy = BaseDatos.shared.ventasValidas(desde: Fechas.inicioDelDia(), vendedor: usuario)
        let mes = BaseDatos.shared.ventasValidas(desde: Fechas.inicioDelMes(), vendedor: usuario)
        indicadorHoy?.valor.text = Formato.soles(hoy.reduce(0) { $0 + $1.total })
        indicadorHoy?.detalle.text = "\(hoy.count) venta(s)"
        indicadorMes?.valor.text = Formato.soles(mes.reduce(0) { $0 + $1.total })
        indicadorMes?.detalle.text = "\(mes.count) venta(s)"
    }

    // MARK: - A8 · Anular con motivo

    private func pedirAnulacion(de venta: Venta) {
        // A8 ① · Resumen de la venta y aviso de que el stock se devolverá.
        let mensaje = """
        \(venta.cliente?.nombre ?? "") · \(venta.producto?.nombre ?? "") × \(venta.cantidad) · \(Formato.soles(venta.total))
        Vendedor: \(venta.vendedor?.nombre ?? "")
        El stock se devolverá (+\(venta.cantidad)).
        """
        let alerta = UIAlertController(title: "Anular venta", message: mensaje, preferredStyle: .alert)
        let anular = UIAlertAction(title: "Anular", style: .destructive) { [weak self, weak alerta] _ in
            let motivo = (alerta?.textFields?.first?.text ?? "").trimmingCharacters(in: .whitespaces)
            self?.anular(venta, motivo: motivo)
        }
        // Deshabilitado mientras el motivo esté vacío.
        anular.isEnabled = false
        alerta.addTextField { campo in
            campo.placeholder = "Motivo (obligatorio)"   // A8 ②
            campo.autocapitalizationType = .sentences
            campo.addAction(UIAction { _ in
                anular.isEnabled = !(campo.text ?? "").trimmingCharacters(in: .whitespaces).isEmpty
            }, for: .editingChanged)
        }
        alerta.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alerta.addAction(anular)
        present(alerta, animated: true)
    }

    private func anular(_ venta: Venta, motivo: String) {
        guard Sesion.shared.esSupervisor, !venta.anulada, !motivo.isEmpty else { return }
        venta.anulada = true
        venta.motivoAnulacion = motivo
        venta.producto?.stock += venta.cantidad   // devuelve el stock
        BaseDatos.shared.guardar()
        cargar()
    }
}

extension VentasViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ventas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: VentaCelda.id, for: indexPath) as! VentaCelda
        celda.configurar(con: ventas[indexPath.row], mostrarVendedor: modo == .equipo)
        return celda
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        ventas.isEmpty ? "Sin ventas para este filtro" : "\(ventas.count) venta(s)"
    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        modo == .equipo
            ? "El nombre del vendedor se lee de la relación venta ▸ vendedor. Desliza una venta para anularla."
            : "Solo aparecen las ventas de este vendedor."
    }

    /// Solo el supervisor, en Ventas del equipo, y solo si la venta no está anulada.
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let venta = ventas[indexPath.row]
        guard modo == .equipo, Sesion.shared.esSupervisor, !venta.anulada else { return nil }
        let anular = UIContextualAction(style: .destructive, title: "Anular") { [weak self] _, _, terminar in
            self?.pedirAnulacion(de: venta)
            terminar(true)
        }
        anular.image = UIImage(systemName: "xmark.circle")
        return UISwipeActionsConfiguration(actions: [anular])
    }
}

extension VentasViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        cargar()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

/// Fila de una venta. Las anuladas salen tachadas y con la etiqueta ANULADA.
/// Es la celda prototipo "venta" de las dos escenas de ventas en Main.storyboard.
final class VentaCelda: UITableViewCell {
    static let id = "venta"

    @IBOutlet private weak var icono: Iniciales!
    @IBOutlet private weak var titulo: UILabel!
    @IBOutlet private weak var detalle: UILabel!
    @IBOutlet private weak var total: UILabel!
    @IBOutlet private weak var etiqueta: Pastilla!

    private static let diaMes: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "dd/MM"
        return f
    }()

    /// A6: ícono ✓ / ✕ y "fecha · producto × cantidad".
    /// A7: iniciales del cliente y "vendedor · producto × cantidad" (relación venta ▸ vendedor).
    func configurar(con venta: Venta, mostrarVendedor: Bool) {
        let producto = "\(venta.producto?.nombre ?? "") × \(venta.cantidad)"
        var lineas: [String]
        if mostrarVendedor {
            let vendedor = venta.vendedor?.nombre?.split(separator: " ").first.map(String.init) ?? "-"
            lineas = ["\(vendedor) · \(producto)"]
            icono.mostrar(nombre: venta.cliente?.nombre)
        } else {
            let fecha = venta.fecha.map { VentaCelda.diaMes.string(from: $0) } ?? ""
            lineas = ["\(fecha) · \(producto)"]
            icono.mostrar(venta.anulada ? "✕" : "✓", color: venta.anulada ? .systemRed : .systemGreen)
        }
        if venta.anulada, let motivo = venta.motivoAnulacion {
            lineas.append("Motivo: \(motivo)")
        }

        // A6 ⑤ · Venta anulada: tachada y con la etiqueta, sin botón.
        let tachado: [NSAttributedString.Key: Any] = venta.anulada
            ? [.strikethroughStyle: NSUnderlineStyle.single.rawValue, .foregroundColor: UIColor.secondaryLabel]
            : [.foregroundColor: UIColor.label]
        titulo.attributedText = NSAttributedString(
            string: venta.cliente?.nombre ?? "Sin cliente",
            attributes: tachado.merging([.font: UIFont.systemFont(ofSize: 15, weight: .semibold)]) { $1 })
        total.attributedText = NSAttributedString(
            string: Formato.soles(venta.total),
            attributes: tachado.merging([.font: UIFont.systemFont(ofSize: 15, weight: .bold)]) { $1 })
        detalle.text = lineas.joined(separator: "\n")
        etiqueta.isHidden = !venta.anulada
    }
}
