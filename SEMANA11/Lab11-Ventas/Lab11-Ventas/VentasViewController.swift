import UIKit

/// A6 · Mis ventas (vendedor: solo las suyas, sin anular).
/// A7 · Ventas del equipo (supervisor: todas, chips por vendedor y deslizar para Anular).
/// A8 · La anulación se pide con una alerta que exige motivo.
final class VentasViewController: UIViewController {

    enum Modo { case propias, equipo }

    private let modo: Modo
    private let tabla = UITableView(frame: .zero, style: .insetGrouped)
    private let periodo = UISegmentedControl(items: ["Todas", "Hoy", "Mes"])
    private let buscador = UISearchController(searchResultsController: nil)
    private let chips = ChipsView()
    private let indicadorHoy = IndicadorView(titulo: "Hoy")
    private let indicadorMes = IndicadorView(titulo: "Este mes")

    private var ventas: [Venta] = []
    private var vendedores: [Usuario] = []

    init(modo: Modo) {
        self.modo = modo
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) no se usa") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground

        buscador.searchResultsUpdater = self
        buscador.obscuresBackgroundDuringPresentation = false
        buscador.searchBar.placeholder = "Buscar por cliente"
        navigationItem.searchController = buscador
        navigationItem.hidesSearchBarWhenScrolling = false

        periodo.selectedSegmentIndex = 0
        periodo.addTarget(self, action: #selector(filtroCambio), for: .valueChanged)
        chips.alCambiar = { [weak self] _ in self?.cargar() }

        tabla.dataSource = self
        tabla.delegate = self
        tabla.register(VentaCelda.self, forCellReuseIdentifier: VentaCelda.id)
        tabla.backgroundColor = .clear

        var cabecera: [UIView] = []
        if modo == .propias {
            indicadorHoy.backgroundColor = .secondarySystemGroupedBackground
            indicadorMes.backgroundColor = .secondarySystemGroupedBackground
            let indicadores = UIStackView(arrangedSubviews: [indicadorHoy, indicadorMes])
            indicadores.spacing = 12
            indicadores.distribution = .fillEqually
            cabecera.append(conMargen(indicadores))
        } else {
            cabecera.append(chips)
        }
        cabecera.append(conMargen(periodo))

        let pila = UIStackView(arrangedSubviews: cabecera + [tabla])
        pila.axis = .vertical
        pila.spacing = 8
        pila.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pila)
        NSLayoutConstraint.activate([
            pila.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            pila.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pila.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pila.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if modo == .equipo { actualizarVendedores() }
        cargar()
    }

    private func conMargen(_ vista: UIView) -> UIView {
        let contenedor = UIView()
        vista.translatesAutoresizingMaskIntoConstraints = false
        contenedor.addSubview(vista)
        NSLayoutConstraint.activate([
            vista.topAnchor.constraint(equalTo: contenedor.topAnchor),
            vista.bottomAnchor.constraint(equalTo: contenedor.bottomAnchor),
            vista.leadingAnchor.constraint(equalTo: contenedor.leadingAnchor, constant: 16),
            vista.trailingAnchor.constraint(equalTo: contenedor.trailingAnchor, constant: -16)
        ])
        return contenedor
    }

    /// Chips: "Todos" más cada usuario con rol Vendedor o con ventas registradas.
    private func actualizarVendedores() {
        let anterior = chips.seleccion > 0 && chips.seleccion <= vendedores.count ? vendedores[chips.seleccion - 1] : nil
        vendedores = BaseDatos.shared.buscar(
            Usuario.self,
            predicado: NSPredicate(format: "rol == %@ OR ventas.@count > 0", Rol.vendedor.rawValue),
            orden: [NSSortDescriptor(key: "nombre", ascending: true)]
        )
        let indice = anterior.flatMap { vendedores.firstIndex(of: $0) }.map { $0 + 1 } ?? 0
        chips.configurar(opciones: ["Todos"] + vendedores.map { $0.nombre ?? "" }, seleccion: indice)
    }

    @objc private func filtroCambio() {
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
            if chips.seleccion > 0 && chips.seleccion <= vendedores.count {
                condiciones.append(NSPredicate(format: "vendedor == %@", vendedores[chips.seleccion - 1]))
            }
        }

        switch periodo.selectedSegmentIndex {
        case 1: condiciones.append(NSPredicate(format: "fecha >= %@", Fechas.inicioDelDia() as NSDate))
        case 2: condiciones.append(NSPredicate(format: "fecha >= %@", Fechas.inicioDelMes() as NSDate))
        default: break
        }

        let texto = (buscador.searchBar.text ?? "").trimmingCharacters(in: .whitespaces)
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
        indicadorHoy.valor.text = Formato.soles(hoy.reduce(0) { $0 + $1.total })
        indicadorHoy.detalle.text = "\(hoy.count) venta(s)"
        indicadorMes.valor.text = Formato.soles(mes.reduce(0) { $0 + $1.total })
        indicadorMes.detalle.text = "\(mes.count) venta(s)"
    }

    // MARK: - A8 · Anular con motivo

    private func pedirAnulacion(de venta: Venta) {
        let mensaje = """
        Cliente: \(venta.cliente?.nombre ?? "")
        Producto: \(venta.producto?.nombre ?? "") × \(venta.cantidad)
        Vendedor: \(venta.vendedor?.nombre ?? "")
        Total: \(Formato.soles(venta.total))

        Se devolverán \(venta.cantidad) unidad(es) al stock.
        """
        let alerta = UIAlertController(title: "Anular venta", message: mensaje, preferredStyle: .alert)
        let anular = UIAlertAction(title: "Anular", style: .destructive) { [weak self, weak alerta] _ in
            let motivo = (alerta?.textFields?.first?.text ?? "").trimmingCharacters(in: .whitespaces)
            self?.anular(venta, motivo: motivo)
        }
        // Deshabilitado mientras el motivo esté vacío.
        anular.isEnabled = false
        alerta.addTextField { campo in
            campo.placeholder = "Motivo (obligatorio)"
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
            ? "El nombre del vendedor sale de la relación venta ▸ vendedor. Desliza una venta para anularla."
            : nil
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

extension VentasViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        cargar()
    }
}

/// Fila de una venta. Las anuladas salen tachadas y con la etiqueta ANULADA.
final class VentaCelda: UITableViewCell {
    static let id = "venta"

    private let titulo = UILabel()
    private let detalle = UILabel()
    private let total = UILabel()
    private let etiqueta = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        detalle.font = .preferredFont(forTextStyle: .caption1)
        detalle.textColor = .secondaryLabel
        detalle.numberOfLines = 0
        total.font = .systemFont(ofSize: 16, weight: .bold)
        total.textAlignment = .right
        total.setContentCompressionResistancePriority(.required, for: .horizontal)
        etiqueta.text = " ANULADA "
        etiqueta.font = .systemFont(ofSize: 11, weight: .bold)
        etiqueta.textColor = .white
        etiqueta.backgroundColor = .systemRed
        etiqueta.layer.cornerRadius = 4
        etiqueta.clipsToBounds = true

        let izquierda = UIStackView(arrangedSubviews: [titulo, detalle])
        izquierda.axis = .vertical
        izquierda.spacing = 3
        let derecha = UIStackView(arrangedSubviews: [total, etiqueta])
        derecha.axis = .vertical
        derecha.alignment = .trailing
        derecha.spacing = 4
        let fila = UIStackView(arrangedSubviews: [izquierda, derecha])
        fila.spacing = 10
        fila.alignment = .center
        fila.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(fila)
        NSLayoutConstraint.activate([
            fila.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            fila.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            fila.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            fila.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) no se usa") }

    func configurar(con venta: Venta, mostrarVendedor: Bool) {
        let textoTitulo = "\(venta.cliente?.nombre ?? "Sin cliente")"
        var lineas = ["\(venta.producto?.nombre ?? "") × \(venta.cantidad) · \(Formato.fecha(venta.fecha))"]
        if mostrarVendedor {
            lineas.append("Vendedor: \(venta.vendedor?.nombre ?? "-")")
        }
        if venta.descuento > 0 {
            lineas.append("Descuento VIP \(Formato.soles(venta.descuento))")
        }
        if venta.anulada, let motivo = venta.motivoAnulacion {
            lineas.append("Motivo: \(motivo)")
        }

        let tachado: [NSAttributedString.Key: Any] = venta.anulada
            ? [.strikethroughStyle: NSUnderlineStyle.single.rawValue, .foregroundColor: UIColor.secondaryLabel]
            : [.foregroundColor: UIColor.label]
        titulo.attributedText = NSAttributedString(
            string: textoTitulo,
            attributes: tachado.merging([.font: UIFont.systemFont(ofSize: 16, weight: .semibold)]) { $1 })
        total.attributedText = NSAttributedString(
            string: Formato.soles(venta.total),
            attributes: tachado.merging([.font: UIFont.systemFont(ofSize: 16, weight: .bold)]) { $1 })
        detalle.text = lineas.joined(separator: "\n")
        etiqueta.isHidden = !venta.anulada
    }
}
