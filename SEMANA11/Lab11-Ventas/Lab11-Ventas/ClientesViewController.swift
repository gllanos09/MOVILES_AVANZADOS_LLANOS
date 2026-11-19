import UIKit

/// A4 · Clientes. Ambos roles crean, editan y consultan; solo el supervisor borra.
/// La tabla, la búsqueda, la celda "cliente" y el botón + están en Main.storyboard.
final class ClientesViewController: UITableViewController {

    @IBOutlet private weak var buscador: UISearchBar!
    private var clientes: [Cliente] = []

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cargar()
    }

    private func cargar() {
        let texto = (buscador.text ?? "").trimmingCharacters(in: .whitespaces)
        let predicado = texto.isEmpty ? nil
            : NSPredicate(format: "nombre CONTAINS[cd] %@ OR documento CONTAINS %@", texto, texto)
        clientes = BaseDatos.shared.buscar(Cliente.self, predicado: predicado,
                                           orden: [NSSortDescriptor(key: "nombre", ascending: true)])
        tableView.reloadData()
    }

    @IBAction private func agregarTocado() {
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

    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        "Categoría y \"comprado\" se calculan con las ventas no anuladas; no se guardan."
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

extension ClientesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        cargar()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

/// A4 ② · Fila con iniciales, nombre, documento, total comprado y categoría.
/// Es la celda prototipo "cliente" de Main.storyboard.
final class ClienteCelda: UITableViewCell {
    static let id = "cliente"

    @IBOutlet private weak var iniciales: Iniciales!
    @IBOutlet private weak var nombre: UILabel!
    @IBOutlet private weak var documento: UILabel!
    @IBOutlet private weak var total: UILabel!
    @IBOutlet private weak var categoria: Pastilla!

    /// A4 ③ · Total y categoría calculados con las ventas no anuladas.
    func configurar(con cliente: Cliente) {
        iniciales.mostrar(nombre: cliente.nombre)
        nombre.text = cliente.nombre
        let doc = cliente.documento ?? ""
        documento.text = doc.count == 11 ? "RUC \(doc)" : doc.count == 8 ? "DNI \(doc)" : doc
        total.text = Formato.soles(cliente.totalComprado)
        let cat = cliente.categoria
        switch cat {
        case .vip: categoria.pintar(cat.rawValue, .systemPurple)
        case .frecuente: categoria.pintar(cat.rawValue, .systemBlue)
        case .regular: categoria.pintar(cat.rawValue, .systemGray)
        }
    }
}
