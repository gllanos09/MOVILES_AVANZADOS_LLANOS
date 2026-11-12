import Foundation

enum Rol: String, CaseIterable {
    case vendedor = "Vendedor"
    case supervisor = "Supervisor"
}

/// Recuerda al usuario conectado mientras la app está abierta.
/// Un único objeto compartido (static let), como pide el laboratorio.
final class Sesion {
    static let shared = Sesion()
    private init() {}

    var usuario: Usuario?

    var esSupervisor: Bool {
        usuario?.rol == Rol.supervisor.rawValue
    }

    func cerrar() {
        usuario = nil
    }
}
