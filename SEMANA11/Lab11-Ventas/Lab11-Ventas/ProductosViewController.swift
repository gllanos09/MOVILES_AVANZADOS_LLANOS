import UIKit

/// A3 · Productos. El vendedor solo consulta y busca; el supervisor crea, edita y borra.
/// La pantalla (búsqueda, chips, tabla con la celda "producto" y el botón +) está en Main.storyboard.
final class ProductosViewController: UIViewController {

    @IBOutlet private weak var tabla: UITableView!
    @IBOutlet private weak var chips: ChipsView!
    @IBOutlet private weak var buscador: UISearchBar!
    private var productos: [Producto] = []
    private var categorias: [String] = []

    private var esSupervisor: Bool { Sesion.shared.esSupervisor }

    override func viewDidLoad() {
        super.viewDidLoad()

        // El botón + del storyboard es solo para el supervisor.
        if !esSupervisor {
            navigationItem.rightBarButtonItem = nil
        }

        chips.alCambiar = { [weak self] _ in self?.cargar() }
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
        chips.configurar(opciones: ["Todos"] + categorias, seleccion: indice)
    }

    /// Búsqueda por nombre y filtro por categoría con NSPredicate.
    private func cargar() {
        var condiciones: [NSPredicate] = []
        let texto = (buscador.text ?? "").trimmingCharacters(in: .whitespaces)
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

    @IBAction private func agregarTocado() {
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
        let celda = tableView.dequeueReusableCell(withIdentifier: ProductoCelda.id, for: indexPath) as! ProductoCelda
        let producto = productos[indexPath.row]
        celda.configurar(con: producto, colorStock: colorDeStock(producto.stock))
        celda.selectionStyle = esSupervisor ? .default : .none
        return celda
    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        esSupervisor
            ? "Vista del supervisor. El vendedor solo consulta: sin \"+\" y sin borrar."
            : "Vista del vendedor: solo consulta y búsqueda."
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

extension ProductosViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        cargar()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

/// A3 ④ · Fila con iniciales, nombre, categoría, precio y stock en color.
/// Es la celda prototipo "producto" de Main.storyboard.
final class ProductoCelda: UITableViewCell {
    static let id = "producto"

    @IBOutlet private weak var iniciales: Iniciales!
    @IBOutlet private weak var nombre: UILabel!
    @IBOutlet private weak var categoria: UILabel!
    @IBOutlet private weak var precio: UILabel!
    @IBOutlet private weak var stock: Pastilla!

    /// Stock en color: verde más de 10, ámbar de 6 a 10, rojo 5 o menos.
    func configurar(con producto: Producto, colorStock: UIColor) {
        iniciales.mostrar(nombre: producto.nombre)
        nombre.text = producto.nombre
        categoria.text = producto.categoria
        precio.text = Formato.soles(producto.precio)
        stock.pintar("\(producto.stock) u.", colorStock)
    }
}
