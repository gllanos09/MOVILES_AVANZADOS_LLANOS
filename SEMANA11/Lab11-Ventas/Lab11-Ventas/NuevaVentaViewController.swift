import UIKit

/// A5 · Registrar venta. El vendedor sale de la sesión; el resumen se calcula con Reglas.
/// Las tarjetas (vendedor de la sesión, cliente, producto, cantidad y resumen) están en Main.storyboard.
final class NuevaVentaViewController: UIViewController {

    @IBOutlet private weak var vendedorIniciales: Iniciales!
    @IBOutlet private weak var vendedorEtiqueta: UILabel!
    @IBOutlet private weak var clienteBoton: UIButton!
    @IBOutlet private weak var productoBoton: UIButton!
    @IBOutlet private weak var productoDetalle: UILabel!   // "(stock 40)" junto a la cantidad
    @IBOutlet private weak var cantidadCampo: UITextField!
    @IBOutlet private weak var cantidadStepper: UIStepper!

    @IBOutlet private weak var subtotalValor: UILabel!
    @IBOutlet private weak var descuentoTitulo: UILabel!
    @IBOutlet private weak var descuentoValor: UILabel!
    @IBOutlet private weak var igvValor: UILabel!
    @IBOutlet private weak var totalValor: UILabel!

    private var clienteElegido: Cliente?
    private var productoElegido: Producto?

    private var cantidad: Int {
        Int(cantidadCampo.text ?? "") ?? 0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Los botones Cliente y Producto abren su menú con un solo toque.
        clienteBoton.showsMenuAsPrimaryAction = true
        productoBoton.showsMenuAsPrimaryAction = true

        // Cierra el teclado numérico al tocar fuera.
        let toque = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        toque.cancelsTouchesInView = false
        view.addGestureRecognizer(toque)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let vendedor = Sesion.shared.usuario
        vendedorIniciales.mostrar(nombre: vendedor?.nombre)
        vendedorEtiqueta.text = "\(vendedor?.nombre ?? "") · \(vendedor?.rol ?? "")"
        armarMenus()
        actualizarResumen()
    }

    // MARK: - Selectores

    /// Menús con los clientes y productos actuales (pueden cambiar en otras pestañas).
    private func armarMenus() {
        let clientes = BaseDatos.shared.buscar(Cliente.self, orden: [NSSortDescriptor(key: "nombre", ascending: true)])
        clienteBoton.menu = UIMenu(children: clientes.map { cliente in
            UIAction(title: cliente.nombre ?? "", subtitle: cliente.categoria.rawValue,
                     state: cliente == clienteElegido ? .on : .off) { [weak self] _ in
                self?.clienteElegido = cliente
                self?.armarMenus()
                self?.actualizarResumen()
            }
        })

        let productos = BaseDatos.shared.buscar(Producto.self, orden: [NSSortDescriptor(key: "nombre", ascending: true)])
        productoBoton.menu = UIMenu(children: productos.map { producto in
            UIAction(title: producto.nombre ?? "",
                     subtitle: "\(Formato.soles(producto.precio)) · stock \(producto.stock)",
                     state: producto == productoElegido ? .on : .off) { [weak self] _ in
                self?.productoElegido = producto
                self?.armarMenus()
                self?.actualizarResumen()
            }
        })

        // Si el elegido fue borrado en otra pestaña, se limpia.
        if let cliente = clienteElegido, cliente.isDeleted || cliente.managedObjectContext == nil { clienteElegido = nil }
        if let producto = productoElegido, producto.isDeleted || producto.managedObjectContext == nil { productoElegido = nil }
    }

    // MARK: - Cantidad

    /// Value Changed del stepper.
    @IBAction private func stepperCambio() {
        cantidadCampo.text = String(Int(cantidadStepper.value))
        actualizarResumen()
    }

    /// Editing Changed del campo cantidad.
    @IBAction private func cantidadEscrita() {
        cantidadStepper.value = Double(max(cantidad, 1))
        actualizarResumen()
    }

    // MARK: - Resumen

    private func actualizarResumen() {
        if let cliente = clienteElegido {
            clienteBoton.setTitle("\(cliente.nombre ?? "") ›", for: .normal)
        } else {
            clienteBoton.setTitle("Elegir ›", for: .normal)
        }

        if let producto = productoElegido {
            productoBoton.setTitle("\(producto.nombre ?? "") ›", for: .normal)
            productoDetalle.text = "(stock \(producto.stock))"
            productoDetalle.textColor = Int64(cantidad) > producto.stock ? .systemRed : .secondaryLabel
        } else {
            productoBoton.setTitle("Elegir ›", for: .normal)
            productoDetalle.text = ""
            productoDetalle.textColor = .secondaryLabel
        }

        let categoria = clienteElegido?.categoria ?? .regular
        descuentoTitulo.text = categoria == .vip ? "Descuento VIP 10%" : "Descuento"
        guard let producto = productoElegido, cantidad > 0 else {
            [subtotalValor, descuentoValor, igvValor, totalValor].forEach { $0.text = Formato.soles(0) }
            return
        }
        let resumen = Reglas.calcular(precio: producto.precio, cantidad: cantidad, categoria: categoria)
        subtotalValor.text = Formato.soles(resumen.subtotal)
        descuentoValor.text = "− " + Formato.soles(resumen.descuento)
        igvValor.text = Formato.soles(resumen.igv)
        totalValor.text = Formato.soles(resumen.total)
    }

    // MARK: - Registrar

    @IBAction private func registrarTocado() {
        view.endEditing(true)
        guard let vendedor = Sesion.shared.usuario else { return }
        guard let cliente = clienteElegido else {
            mostrarAlerta("Falta el cliente", "Elige a quién se le vende.")
            return
        }
        guard let producto = productoElegido else {
            mostrarAlerta("Falta el producto", "Elige qué producto se vende.")
            return
        }
        guard cantidad > 0 else {
            mostrarAlerta("Cantidad no válida", "La cantidad debe ser al menos 1.")
            return
        }
        // Regla de stock: si la cantidad supera el stock, no se registra.
        guard Int64(cantidad) <= producto.stock else {
            mostrarAlerta("Stock insuficiente",
                          "Pediste \(cantidad) y solo hay \(producto.stock) unidades de \(producto.nombre ?? ""). La venta no se registró.")
            return
        }

        let resumen = Reglas.calcular(precio: producto.precio, cantidad: cantidad, categoria: cliente.categoria)
        let venta = Venta(context: BaseDatos.shared.contexto)
        venta.fecha = Date()
        venta.cantidad = Int64(cantidad)
        venta.precioUnitario = producto.precio
        venta.descuento = resumen.descuento
        venta.igv = resumen.igv
        venta.total = resumen.total
        venta.anulada = false
        venta.vendedor = vendedor
        venta.cliente = cliente
        venta.producto = producto
        producto.stock -= Int64(cantidad)
        BaseDatos.shared.guardar()

        let stockFinal = producto.stock
        mostrarAlerta("Venta registrada",
                      "Total \(Formato.soles(resumen.total)). Stock de \(producto.nombre ?? ""): \(stockFinal).") { [weak self] in
            self?.cantidadCampo.text = "1"
            self?.cantidadStepper.value = 1
            self?.armarMenus()
            self?.actualizarResumen()
        }
    }
}
