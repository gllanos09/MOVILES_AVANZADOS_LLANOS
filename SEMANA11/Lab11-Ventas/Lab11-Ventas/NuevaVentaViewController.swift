import UIKit

/// A5 · Registrar venta. El vendedor sale de la sesión; el resumen se calcula con Reglas.
final class NuevaVentaViewController: UIViewController {

    private let vendedorEtiqueta = UILabel()
    private let clienteBoton = UIButton(type: .system)
    private let clienteDetalle = UILabel()
    private let productoBoton = UIButton(type: .system)
    private let productoDetalle = UILabel()
    private let cantidadCampo = UITextField()
    private let cantidadStepper = UIStepper()

    private let subtotalValor = UILabel()
    private let descuentoTitulo = UILabel()
    private let descuentoValor = UILabel()
    private let igvValor = UILabel()
    private let totalValor = UILabel()

    private var clienteElegido: Cliente?
    private var productoElegido: Producto?

    private var cantidad: Int {
        Int(cantidadCampo.text ?? "") ?? 0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        vendedorEtiqueta.font = .systemFont(ofSize: 16, weight: .semibold)
        let vendedorFila = tarjeta(titulo: "Vendedor (sesión)", contenido: [vendedorEtiqueta])

        configurarSelector(clienteBoton, texto: "Elegir cliente")
        clienteDetalle.font = .preferredFont(forTextStyle: .caption1)
        clienteDetalle.textColor = .secondaryLabel
        let clienteFila = tarjeta(titulo: "Cliente", contenido: [clienteBoton, clienteDetalle])

        configurarSelector(productoBoton, texto: "Elegir producto")
        productoDetalle.font = .preferredFont(forTextStyle: .caption1)
        productoDetalle.textColor = .secondaryLabel
        productoDetalle.numberOfLines = 0
        let productoFila = tarjeta(titulo: "Producto", contenido: [productoBoton, productoDetalle])

        cantidadCampo.text = "1"
        cantidadCampo.keyboardType = .numberPad
        cantidadCampo.font = .systemFont(ofSize: 22, weight: .bold)
        cantidadCampo.borderStyle = .roundedRect
        cantidadCampo.textAlignment = .center
        cantidadCampo.widthAnchor.constraint(equalToConstant: 80).isActive = true
        cantidadCampo.addTarget(self, action: #selector(cantidadEscrita), for: .editingChanged)
        cantidadStepper.minimumValue = 1
        cantidadStepper.maximumValue = 999
        cantidadStepper.value = 1
        cantidadStepper.addTarget(self, action: #selector(stepperCambio), for: .valueChanged)
        let cantidadFila = UIStackView(arrangedSubviews: [cantidadCampo, UIView(), cantidadStepper])
        cantidadFila.alignment = .center
        let cantidadTarjeta = tarjeta(titulo: "Cantidad", contenido: [cantidadFila])

        totalValor.font = .systemFont(ofSize: 20, weight: .bold)
        descuentoTitulo.text = "Descuento"
        let resumen = tarjeta(titulo: "Resumen", contenido: [
            filaMonto("Subtotal", subtotalValor),
            filaMonto(descuentoTitulo, descuentoValor),
            filaMonto("IGV (18 %)", igvValor),
            filaMonto("Total", totalValor, destacado: true)
        ])

        let registrar = UIButton.principal("Registrar venta")
        registrar.addTarget(self, action: #selector(registrarTocado), for: .touchUpInside)

        let pila = UIStackView(arrangedSubviews: [vendedorFila, clienteFila, productoFila,
                                                  cantidadTarjeta, resumen, registrar])
        pila.axis = .vertical
        pila.spacing = 12
        view.fijarEnScroll(pila, margen: 16)

        // Cierra el teclado numérico al tocar fuera.
        let toque = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        toque.cancelsTouchesInView = false
        view.addGestureRecognizer(toque)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vendedorEtiqueta.text = Sesion.shared.usuario?.nombre
        armarMenus()
        actualizarResumen()
    }

    // MARK: - Selectores

    private func configurarSelector(_ boton: UIButton, texto: String) {
        boton.setTitle(texto, for: .normal)
        boton.contentHorizontalAlignment = .leading
        boton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        boton.showsMenuAsPrimaryAction = true
    }

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

    @objc private func stepperCambio() {
        cantidadCampo.text = String(Int(cantidadStepper.value))
        actualizarResumen()
    }

    @objc private func cantidadEscrita() {
        cantidadStepper.value = Double(max(cantidad, 1))
        actualizarResumen()
    }

    // MARK: - Resumen

    private func actualizarResumen() {
        if let cliente = clienteElegido {
            clienteBoton.setTitle(cliente.nombre, for: .normal)
            clienteDetalle.text = "\(cliente.documento ?? "") · \(cliente.categoria.rawValue) · comprado \(Formato.soles(cliente.totalComprado))"
        } else {
            clienteBoton.setTitle("Elegir cliente", for: .normal)
            clienteDetalle.text = "Toca para elegir"
        }

        if let producto = productoElegido {
            productoBoton.setTitle(producto.nombre, for: .normal)
            productoDetalle.text = "\(Formato.soles(producto.precio)) c/u · Stock disponible: \(producto.stock)"
            productoDetalle.textColor = Int64(cantidad) > producto.stock ? .systemRed : .secondaryLabel
        } else {
            productoBoton.setTitle("Elegir producto", for: .normal)
            productoDetalle.text = "Toca para elegir"
            productoDetalle.textColor = .secondaryLabel
        }

        let categoria = clienteElegido?.categoria ?? .regular
        descuentoTitulo.text = categoria == .vip ? "Descuento VIP (10 %)" : "Descuento"
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

    @objc private func registrarTocado() {
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

    // MARK: - Piezas de la pantalla

    private func tarjeta(titulo: String, contenido: [UIView]) -> UIView {
        let etiqueta = UILabel()
        etiqueta.text = titulo.uppercased()
        etiqueta.font = .systemFont(ofSize: 12, weight: .semibold)
        etiqueta.textColor = .secondaryLabel
        let pila = UIStackView(arrangedSubviews: [etiqueta] + contenido)
        pila.axis = .vertical
        pila.spacing = 6
        pila.isLayoutMarginsRelativeArrangement = true
        pila.layoutMargins = UIEdgeInsets(top: 12, left: 14, bottom: 12, right: 14)
        pila.backgroundColor = .secondarySystemBackground
        pila.layer.cornerRadius = 12
        return pila
    }

    private func filaMonto(_ titulo: String, _ valor: UILabel, destacado: Bool = false) -> UIView {
        let etiqueta = UILabel()
        etiqueta.text = titulo
        return filaMonto(etiqueta, valor, destacado: destacado)
    }

    private func filaMonto(_ etiqueta: UILabel, _ valor: UILabel, destacado: Bool = false) -> UIView {
        if destacado { etiqueta.font = .systemFont(ofSize: 20, weight: .bold) }
        valor.textAlignment = .right
        return UIStackView(arrangedSubviews: [etiqueta, valor])
    }
}
