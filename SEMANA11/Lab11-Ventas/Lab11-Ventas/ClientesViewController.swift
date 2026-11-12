import UIKit

/// A4 · Clientes. Ambos roles crean, editan y consultan; solo el supervisor borra.
final class ClientesViewController: UITableViewController {

    private let buscador = UISearchController(searchResultsController: nil)
    private var clientes: [Cliente] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self,
                                                            action: #selector(agregarTocado))
        buscador.searchResultsUpdater = self
        buscador.obscuresBackgroundDuringPresentation = false
        buscador.searchBar.placeholder = "Buscar por nombre o documento"
        navigationItem.searchController = buscador
        navigationItem.hidesSearchBarWhenScrolling = false

        tableView.register(ClienteCelda.self, forCellReuseIdentifier: ClienteCelda.id)
        tableView.rowHeight = 72
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cargar()
    }

    private func cargar() {
        let texto = (buscador.searchBar.text ?? "").trimmingCharacters(in: .whitespaces)
        let predicado = texto.isEmpty ? nil
            : NSPredicate(format: "nombre CONTAINS[cd] %@ OR documento CONTAINS %@", texto, texto)
        clientes = BaseDatos.shared.buscar(Cliente.self, predicado: predicado,
                                           orden: [NSSortDescriptor(key: "nombre", ascending: true)])
        tableView.reloadData()
    }

    @objc private func agregarTocado() {
        mostrarFormulario(para: nil)
    }

    private func mostrarFormulario(para cliente: Cliente?) {
        pedirDatos(
            titulo: cliente == nil ? "Nuevo cliente" : "Editar cliente",
            campos: [
                ("Nombre o razón social", cliente?.nombre, .default),
                ("Documento (DNI o RUC)", cliente?.documento, .numberPad)
            ]
        ) { [weak self] valores in
            guard let self = self else { return }
            guard !valores[0].isEmpty, !valores[1].isEmpty else {
                self.mostrarAlerta("Datos incompletos", "El nombre y el documento son obligatorios.")
                return
            }
            let objetivo = cliente ?? Cliente(context: BaseDatos.shared.contexto)
            objetivo.nombre = valores[0]
            objetivo.documento = valores[1]
            BaseDatos.shared.guardar()
            self.cargar()
        }
    }

    // MARK: - Tabla

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        clientes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: ClienteCelda.id, for: indexPath) as! ClienteCelda
        celda.configurar(con: clientes[indexPath.row])
        return celda
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        mostrarFormulario(para: clientes[indexPath.row])
    }

    override func tableView(_ tableView: UITableView,
                            trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard Sesion.shared.esSupervisor else { return nil }
        let cliente = clientes[indexPath.row]
        let borrar = UIContextualAction(style: .destructive, title: "Borrar") { [weak self] _, _, terminar in
            guard let self = self else { return }
            let nombre = cliente.nombre ?? ""
            if BaseDatos.shared.borrar(cliente) {
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

extension ClientesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        cargar()
    }
}

/// Fila con iniciales, nombre, documento, total comprado y categoría.
final class ClienteCelda: UITableViewCell {
    static let id = "cliente"

    private let iniciales = UILabel()
    private let nombre = UILabel()
    private let documento = UILabel()
    private let total = UILabel()
    private let categoria = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        iniciales.font = .systemFont(ofSize: 16, weight: .bold)
        iniciales.textAlignment = .center
        iniciales.textColor = .white
        iniciales.backgroundColor = .tintColor
        iniciales.layer.cornerRadius = 22
        iniciales.clipsToBounds = true
        iniciales.widthAnchor.constraint(equalToConstant: 44).isActive = true
        iniciales.heightAnchor.constraint(equalToConstant: 44).isActive = true

        nombre.font = .systemFont(ofSize: 16, weight: .semibold)
        documento.font = .preferredFont(forTextStyle: .caption1)
        documento.textColor = .secondaryLabel
        total.font = .systemFont(ofSize: 15, weight: .semibold)
        total.textAlignment = .right
        categoria.font = .systemFont(ofSize: 12, weight: .bold)
        categoria.textAlignment = .right

        let izquierda = UIStackView(arrangedSubviews: [nombre, documento])
        izquierda.axis = .vertical
        izquierda.spacing = 2
        let derecha = UIStackView(arrangedSubviews: [total, categoria])
        derecha.axis = .vertical
        derecha.spacing = 2
        derecha.alignment = .trailing
        derecha.setContentCompressionResistancePriority(.required, for: .horizontal)

        let fila = UIStackView(arrangedSubviews: [iniciales, izquierda, derecha])
        fila.spacing = 12
        fila.alignment = .center
        fila.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(fila)
        NSLayoutConstraint.activate([
            fila.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            fila.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            fila.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) no se usa") }

    /// Total y categoría calculados con las ventas no anuladas.
    func configurar(con cliente: Cliente) {
        iniciales.text = cliente.iniciales
        nombre.text = cliente.nombre
        documento.text = cliente.documento
        total.text = Formato.soles(cliente.totalComprado)
        let cat = cliente.categoria
        categoria.text = cat.rawValue.uppercased()
        switch cat {
        case .vip: categoria.textColor = .systemPurple
        case .frecuente: categoria.textColor = .systemBlue
        case .regular: categoria.textColor = .secondaryLabel
        }
    }
}
