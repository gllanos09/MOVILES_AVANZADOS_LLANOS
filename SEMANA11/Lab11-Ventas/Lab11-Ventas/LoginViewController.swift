import UIKit

/// A1 · Inicio de sesión. La pantalla está en Main.storyboard (Storyboard ID "Login", escena inicial);
/// el botón "Crear cuenta" abre A2 con un segue Show.
final class LoginViewController: UIViewController {

    @IBOutlet private weak var pila: UIStackView!
    @IBOutlet private weak var cabecera: UIStackView!
    @IBOutlet private weak var usuarioCampo: UITextField!
    @IBOutlet private weak var claveCampo: UITextField!
    @IBOutlet private weak var errorFila: UIStackView!     // ícono ⚠︎ + mensaje
    @IBOutlet private weak var errorEtiqueta: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        pila.setCustomSpacing(36, after: cabecera)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    @IBAction private func ingresarTocado() {
        let usuario = (usuarioCampo.text ?? "").trimmingCharacters(in: .whitespaces)
        let clave = claveCampo.text ?? ""

        let encontrado = BaseDatos.shared.buscar(
            Usuario.self,
            predicado: NSPredicate(format: "usuario ==[c] %@ AND clave == %@", usuario, clave)
        ).first

        guard let usuarioValido = encontrado else {
            // Mensaje genérico: no se dice si falló el usuario o la clave.
            errorEtiqueta.text = "Usuario o clave incorrectos"
            errorFila.isHidden = false
            return
        }
        errorFila.isHidden = true
        Sesion.shared.usuario = usuarioValido
        sceneDelegate?.mostrarApp()
    }
}
