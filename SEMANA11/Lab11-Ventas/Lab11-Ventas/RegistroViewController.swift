import UIKit

/// A2 · Crear cuenta. Al registrarse, la persona entra directo a la app.
/// La pantalla está en Main.storyboard (se llega con un segue desde el login).
final class RegistroViewController: UIViewController {

    @IBOutlet private weak var pila: UIStackView!
    @IBOutlet private weak var nombreCampo: UITextField!
    @IBOutlet private weak var usuarioCampo: UITextField!
    @IBOutlet private weak var avisoUsuario: UILabel!
    @IBOutlet private weak var claveCampo: UITextField!
    @IBOutlet private weak var confirmarCampo: UITextField!
    @IBOutlet private weak var rolTitulo: UILabel!
    @IBOutlet private weak var rolSelector: UISegmentedControl!
    @IBOutlet private weak var errorEtiqueta: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Las claves se escriben a mano: sin sugerencias de contraseña del sistema.
        claveCampo.textContentType = .oneTimeCode
        confirmarCampo.textContentType = .oneTimeCode

        pila.setCustomSpacing(6, after: rolTitulo)
        pila.setCustomSpacing(20, after: rolSelector)
    }

    /// Aviso en vivo: "✓ Disponible" o "Ya existe" (sin distinguir mayúsculas).
    /// Conectado al evento Editing Changed del campo Usuario.
    @IBAction private func usuarioCambio() {
        let usuario = (usuarioCampo.text ?? "").trimmingCharacters(in: .whitespaces)
        guard !usuario.isEmpty else {
            avisoUsuario.isHidden = true
            return
        }
        let repetido = BaseDatos.shared.usuarioExiste(usuario)
        avisoUsuario.text = repetido ? "Ya existe" : "✓ Disponible"
        avisoUsuario.textColor = repetido ? .systemRed : .systemGreen
        avisoUsuario.isHidden = false
    }

    @IBAction private func registrarTocado() {
        let nombre = (nombreCampo.text ?? "").trimmingCharacters(in: .whitespaces)
        let usuario = (usuarioCampo.text ?? "").trimmingCharacters(in: .whitespaces)
        let clave = claveCampo.text ?? ""
        let confirmacion = confirmarCampo.text ?? ""

        var errores: [String] = []
        if nombre.isEmpty { errores.append("Escribe tu nombre completo.") }
        if usuario.isEmpty {
            errores.append("Escribe un usuario.")
        } else if BaseDatos.shared.usuarioExiste(usuario) {
            errores.append("El usuario ya existe. Elige otro.")
        }
        if clave.count < 6 { errores.append("La clave debe tener al menos 6 caracteres.") }
        if clave != confirmacion { errores.append("La clave y su confirmación no coinciden.") }

        guard errores.isEmpty else {
            errorEtiqueta.text = errores.joined(separator: "\n")
            errorEtiqueta.isHidden = false
            return
        }

        let nuevo = Usuario(context: BaseDatos.shared.contexto)
        nuevo.nombre = nombre
        nuevo.usuario = usuario
        nuevo.clave = clave
        nuevo.rol = Rol.allCases[rolSelector.selectedSegmentIndex].rawValue
        BaseDatos.shared.guardar()

        Sesion.shared.usuario = nuevo
        sceneDelegate?.mostrarApp()
    }
}
