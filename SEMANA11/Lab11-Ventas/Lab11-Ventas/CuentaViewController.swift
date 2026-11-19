import UIKit

/// Cuenta: nombre, usuario, rol y el botón Cerrar sesión. La pantalla está en Main.storyboard.
final class CuentaViewController: UIViewController {

    @IBOutlet private weak var pila: UIStackView!
    @IBOutlet private weak var avatar: UIStackView!
    @IBOutlet private weak var iniciales: Iniciales!
    @IBOutlet private weak var ultimaFila: UIView!
    @IBOutlet private weak var nombreValor: UILabel!
    @IBOutlet private weak var usuarioValor: UILabel!
    @IBOutlet private weak var rolValor: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        pila.setCustomSpacing(24, after: avatar)
        pila.setCustomSpacing(32, after: ultimaFila)

        let usuario = Sesion.shared.usuario
        iniciales.mostrar(nombre: usuario?.nombre)
        nombreValor.text = usuario?.nombre ?? "-"
        usuarioValor.text = usuario?.usuario ?? "-"
        rolValor.text = usuario?.rol ?? "-"
    }

    @IBAction private func cerrarSesion() {
        Sesion.shared.cerrar()
        sceneDelegate?.mostrarLogin()
    }
}
