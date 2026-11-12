import UIKit

/// A3 · Productos. El vendedor solo consulta y busca; el supervisor crea, edita y borra.
final class ProductosViewController: UIViewController {

    private let tabla = UITableView(frame: .zero, style: .plain)
    private let chips = ChipsView()
    private let buscador = UISearchController(searchResultsController: nil)
    private var productos: [Producto] = []
    private var categorias: [String] = []

    private var esSupervisor: Bool { Sesion.shared.esSupervisor }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        if esSupervisor {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self,
                                                                action: #selector(agregarTocado))
        }

        buscador.searchResultsUpdater = self
        buscador.obscuresBackgroundDuringPresentation = false
        buscador.searchBar.placeholder = "Buscar producto"
        navigationItem.searchController = buscador
        navigationItem.hidesSearchBarWhenScrolling = false

        chips.alCambiar = { [weak self] _ in self?.cargar() }

        tabla.dataSource = self
        tabla.delegate = self
        tabla.rowHeight = 64
        tabla.register(UITableViewCell.self, forCellReuseIdentifier: "producto")

        let pila = UIStackView(arrangedSubviews: [chips, tabla])
        pila.axis = .vertical
        pila.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pila)
        NSLayoutConstraint.activate([
            pila.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pila.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pila.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pila.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        actualizarCategorias()
        cargar()
    }

    /// Los chips salen de las categorías que existen en la base.
    private func actualizarCategorias() {
        let seleccionActual = chips.seleccion > 0 && chips.seleccion <= categorias.count
            ? categorias[chips.seleccion - 1] : nil
        let todas = BaseDatos.shared.buscar(Producto.self).compactMap(\.categoria)
        categorias = Array(Set(todas)).sorted()
        let indice = seleccionActual.flatMap { categorias.firstIndex(of: $0) }.map { $0 + 1 } ?? 0
        chips.configurar(opciones: ["Todas"] + categorias, seleccion: indice)
    }

    /// Búsqueda por nombre y filtro por categoría con NSPredicate.
    private func cargar() {
        var condiciones: [NSPredicate] = []
        let texto = (buscador.searchBar.text ?? "").trimmingCharacters(in: .whitespaces)
        if !texto.isEmpty {
            condiciones.append(NSPredicate(format: "nombre CONTAINS[cd] %@", texto))
        }
        if chips.seleccion > 0 && chips.seleccion <= categorias.count {
            condiciones.append(NSPredicate(format: "categoria == %@", categorias[chips.seleccion - 1]))
        }
        productos = BaseDatos.shared.buscar(
            Producto.self,
            predicado: NSCompoundPredicate(andPredicateWithSubpredicates: condiciones),
            orden: [NSSortDescriptor(key: "nombre", ascending: true)]
        )
        tabla.reloadData()
    }

    @objc private func agregarTocado() {
        mostrarFormulario(para: nil)
    }

    private func mostrarFormulario(para producto: Producto?) {
        pedirDatos(
            titulo: producto == nil ? "Nuevo producto" : "Editar producto",
            campos: [
                ("Nombre", producto?.nombre, .default),
                ("Categoría", producto?.categoria, .default),
                ("Precio (S/)", producto.map { String(format: "%.2f", $0.precio) }, .decimalPad),
                ("Stock", producto.map { String($0.stock) }, .numberPad)
            ]
        ) { [weak self] valores in
            guard let self = self else { return }
            guard !valores[0].isEmpty, !valores[1].isEmpty else {
                self.mostrarAlerta("Datos incompletos", "El nombre y la categoría son obligatorios.")
                return
            }
            guard let precio = Formato.decimal(valores[2]), precio > 0 else {
                self.mostrarAlerta("Precio no válido", "Escribe un precio mayor que cero, por ejemplo 35.00")
                return
            }
            guard let stock = Int64(valores[3]), stock >= 0 else {
                self.mostrarAlerta("Stock no válido", "El stock debe ser un número entero de 0 a más.")
                return
            }
            let objetivo = producto ?? Producto(context: BaseDatos.shared.contexto)
            objetivo.nombre = valores[0]
            objetivo.categoria = valores[1]
            objetivo.precio = Reglas.redondear(precio)
            objetivo.stock = stock
            BaseDatos.shared.guardar()
            self.actualizarCategorias()
            self.cargar()
        }
    }

    private func colorDeStock(_ stock: Int64) -> UIColor {
        if stock <= Reglas.stockBajo { return .systemRed }
        if stock <= Reglas.stockMedio { return .systemOrange }
        return .systemGreen
    }
}

extension ProductosViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        productos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "producto", for: indexPath)
        let producto = productos[indexPath.row]

        var contenido = UIListContentConfiguration.subtitleCell()
        contenido.text = producto.nombre
        contenido.secondaryText = "\(producto.categoria ?? "") · \(Formato.soles(producto.precio))"
        contenido.secondaryTextProperties.color = .secondaryLabel
        celda.contentConfiguration = contenido

        // Stock en color: verde más de 10, ámbar de 6 a 10, rojo 5 o menos.
        let etiqueta = UILabel()
        etiqueta.text = "Stock \(producto.stock)"
        etiqueta.font = .systemFont(ofSize: 13, weight: .semibold)
        etiqueta.textColor = .white
        etiqueta.textAlignment = .center
        etiqueta.backgroundColor = colorDeStock(producto.stock)
        etiqueta.layer.cornerRadius = 11
        etiqueta.clipsToBounds = true
        etiqueta.frame = CGRect(x: 0, y: 0, width: 84, height: 24)
        celda.accessoryView = etiqueta
        celda.selectionStyle = esSupervisor ? .default : .none
        return celda
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard esSupervisor else { return }
        mostrarFormulario(para: productos[indexPath.row])
    }

    /// Deslizar para borrar: solo supervisor, y bloqueado si el producto tiene ventas (Deny).
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard esSupervisor else { return nil }
        let producto = productos[indexPath.row]
        let borrar = UIContextualAction(style: .destructive, title: "Borrar") { [weak self] _, _, terminar in
            guard let self = self else { return }
            let nombre = producto.nombre ?? ""
            if BaseDatos.shared.borrar(producto) {
                self.actualizarCategorias()
                self.cargar()
                terminar(true)
            } else {
                self.mostrarAlerta("No se puede borrar",
                                   "\"\(nombre)\" tiene ventas registradas. La regla Deny impide borrarlo.")
                terminar(false)
            }
        }
        return UISwipeActionsConfiguration(actions: [borrar])
    }
}

extension ProductosViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        cargar()
    }
}
