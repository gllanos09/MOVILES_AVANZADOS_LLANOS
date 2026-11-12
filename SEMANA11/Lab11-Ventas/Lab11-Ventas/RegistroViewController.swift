import UIKit

/// A2 · Crear cuenta. Al registrarse, la persona entra directo a la app.
final class RegistroViewController: UIViewController {

    private let nombreCampo = UITextField.campo("Nombre completo")
    private let usuarioCampo = UITextField.campo("Usuario")
    private let avisoUsuario = UILabel()
    private let claveCampo = UITextField.campo("Clave (mínimo 6 caracteres)", seguro: true)
    private let confirmarCampo = UITextField.campo("Confirmar clave", seguro: true)
    private let rolSelector = UISegmentedControl(items: Rol.allCases.map(\.rawValue))
    private let errorEtiqueta = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Crear cuenta"
        view.backgroundColor = .systemBackground

        nombreCampo.autocapitalizationType = .words
        // Las claves se escriben a mano: sin sugerencias de contraseña del sistema.
        claveCampo.textContentType = .oneTimeCode
        confirmarCampo.textContentType = .oneTimeCode

        avisoUsuario.font = .preferredFont(forTextStyle: .caption1)
        avisoUsuario.textColor = .systemRed
        avisoUsuario.isHidden = true
        usuarioCampo.addTarget(self, action: #selector(usuarioCambio), for: .editingChanged)

        rolSelector.selectedSegmentIndex = 0
        let rolTitulo = UILabel()
        rolTitulo.text = "Rol"
        rolTitulo.font = .preferredFont(forTextStyle: .subheadline)

        errorEtiqueta.textColor = .systemRed
        errorEtiqueta.font = .preferredFont(forTextStyle: .footnote)
        errorEtiqueta.numberOfLines = 0
        errorEtiqueta.isHidden = true

        let registrar = UIButton.principal("Registrarme")
        registrar.addTarget(self, action: #selector(registrarTocado), for: .touchUpInside)

        let pila = UIStackView(arrangedSubviews: [nombreCampo, usuarioCampo, avisoUsuario,
                                                  claveCampo, confirmarCampo, rolTitulo, rolSelector,
                                                  errorEtiqueta, registrar])
        pila.axis = .vertical
        pila.spacing = 12
        pila.setCustomSpacing(4, after: usuarioCampo)
        pila.setCustomSpacing(6, after: rolTitulo)
        pila.setCustomSpacing(20, after: rolSelector)
        view.fijarEnScroll(pila)
    }

    /// Aviso en vivo si el usuario ya existe (sin distinguir mayúsculas).
    @objc private func usuarioCambio() {
        let usuario = (usuarioCampo.text ?? "").trimmingCharacters(in: .whitespaces)
        let repetido = !usuario.isEmpty && BaseDatos.shared.usuarioExiste(usuario)
        avisoUsuario.text = "El usuario \"\(usuario)\" ya existe"
        avisoUsuario.isHidden = !repetido
    }

    @objc private func registrarTocado() {
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
