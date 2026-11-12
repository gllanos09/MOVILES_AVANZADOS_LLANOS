import CoreData

/// Pila de Core Data y consultas que usan varias pantallas.
final class BaseDatos {
    static let shared = BaseDatos()

    let contenedor: NSPersistentContainer

    var contexto: NSManagedObjectContext { contenedor.viewContext }

    private init() {
        contenedor = NSPersistentContainer(name: "Ventas")
        contenedor.loadPersistentStores { _, error in
            if let error = error {
                fatalError("No se pudo abrir la base de datos: \(error)")
            }
        }
    }

    func guardar() {
        guard contexto.hasChanges else { return }
        do {
            try contexto.save()
        } catch {
            contexto.rollback()
            print("Error al guardar: \(error)")
        }
    }

    /// Borra un objeto. Si alguna relación con regla Deny tiene ventas, Core Data
    /// rechaza el guardado: se deshace el cambio y se devuelve false.
    func borrar(_ objeto: NSManagedObject) -> Bool {
        contexto.delete(objeto)
        do {
            try contexto.save()
            return true
        } catch {
            contexto.rollback()
            return false
        }
    }

    // MARK: - Consultas

    func buscar<T: NSManagedObject>(_ tipo: T.Type,
                                    predicado: NSPredicate? = nil,
                                    orden: [NSSortDescriptor] = []) -> [T] {
        let request = NSFetchRequest<T>(entityName: String(describing: tipo))
        request.predicate = predicado
        request.sortDescriptors = orden
        return (try? contexto.fetch(request)) ?? []
    }

    func usuarioExiste(_ usuario: String) -> Bool {
        let request = NSFetchRequest<Usuario>(entityName: "Usuario")
        request.predicate = NSPredicate(format: "usuario ==[c] %@", usuario)
        return ((try? contexto.count(for: request)) ?? 0) > 0
    }

    /// Ventas no anuladas desde una fecha (y antes de otra, si se indica).
    func ventasValidas(desde inicio: Date, hasta fin: Date? = nil, vendedor: Usuario? = nil) -> [Venta] {
        var condiciones = [
            NSPredicate(format: "anulada == NO"),
            NSPredicate(format: "fecha >= %@", inicio as NSDate)
        ]
        if let fin = fin {
            condiciones.append(NSPredicate(format: "fecha < %@", fin as NSDate))
        }
        if let vendedor = vendedor {
            condiciones.append(NSPredicate(format: "vendedor == %@", vendedor))
        }
        return buscar(Venta.self, predicado: NSCompoundPredicate(andPredicateWithSubpredicates: condiciones))
    }

    // MARK: - Datos de ejemplo

    /// Solo la primera vez (si no hay productos). Deja un vendedor de prueba,
    /// productos para los casos de prueba (Laptop S/ 200 con stock 40, Mouse S/ 35)
    /// y ventas de los últimos días para que el resumen y la categoría VIP tengan datos.
    func cargarDatosIniciales() {
        guard buscar(Producto.self).isEmpty else { return }

        let vendedor = Usuario(context: contexto)
        vendedor.nombre = "Juan Pérez"
        vendedor.usuario = "jperez"
        vendedor.clave = "123456"
        vendedor.rol = Rol.vendedor.rawValue

        func producto(_ nombre: String, _ categoria: String, _ precio: Double, _ stock: Int64) -> Producto {
            let p = Producto(context: contexto)
            p.nombre = nombre
            p.categoria = categoria
            p.precio = precio
            p.stock = stock
            return p
        }
        _ = producto("Laptop", "Cómputo", 200, 40)
        let monitor = producto("Monitor", "Cómputo", 650, 4)
        _ = producto("Mouse", "Accesorios", 35, 60)
        let teclado = producto("Teclado", "Accesorios", 80, 8)
        let audifonos = producto("Audífonos", "Audio", 120, 15)
        let parlante = producto("Parlante", "Audio", 150, 3)

        func cliente(_ nombre: String, _ documento: String) -> Cliente {
            let c = Cliente(context: contexto)
            c.nombre = nombre
            c.documento = documento
            return c
        }
        let andina = cliente("Comercial Andina SAC", "20123456789")
        let torres = cliente("María Torres", "45678912")
        _ = cliente("Pedro Quispe", "41234567")

        // Historial: Comercial Andina llega a VIP; María Torres queda Regular.
        let historial: [(dias: Int, cliente: Cliente, producto: Producto, cantidad: Int)] = [
            (6, andina, monitor, 2),
            (5, torres, teclado, 2),
            (4, andina, monitor, 2),
            (3, andina, audifonos, 5),
            (2, andina, monitor, 2),
            (1, torres, parlante, 1)
        ]
        let hoy = Fechas.inicioDelDia()
        for registro in historial {
            let venta = Venta(context: contexto)
            let categoria = registro.cliente.categoria
            let resumen = Reglas.calcular(precio: registro.producto.precio,
                                          cantidad: registro.cantidad,
                                          categoria: categoria)
            venta.fecha = Fechas.sumarDias(-registro.dias, a: hoy).addingTimeInterval(11 * 3600)
            venta.cantidad = Int64(registro.cantidad)
            venta.precioUnitario = registro.producto.precio
            venta.descuento = resumen.descuento
            venta.igv = resumen.igv
            venta.total = resumen.total
            venta.vendedor = vendedor
            venta.producto = registro.producto
            venta.cliente = registro.cliente
        }
        guardar()
    }
}

// MARK: - Extensiones de las entidades

extension Cliente {
    var ventasNoAnuladas: [Venta] {
        ((ventas as? Set<Venta>) ?? []).filter { !$0.anulada }
    }

    var totalComprado: Double {
        ventasNoAnuladas.reduce(0) { $0 + $1.total }
    }

    var categoria: Reglas.Categoria {
        Reglas.Categoria(totalComprado: totalComprado)
    }

    var iniciales: String {
        let partes = (nombre ?? "").split(separator: " ").prefix(2)
        return partes.compactMap { $0.first.map(String.init) }.joined().uppercased()
    }

    var tieneVentas: Bool { (ventas?.count ?? 0) > 0 }
}

extension Producto {
    var tieneVentas: Bool { (ventas?.count ?? 0) > 0 }
}

extension Venta {
    var subtotal: Double {
        Reglas.redondear(precioUnitario * Double(cantidad))
    }
}
