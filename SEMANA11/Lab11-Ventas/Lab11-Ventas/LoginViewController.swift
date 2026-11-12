import UIKit

/// A1 · Inicio de sesión.
final class LoginViewController: UIViewController {

    private let usuarioCampo = UITextField.campo("Usuario")
    private let claveCampo = UITextField.campo("Clave", seguro: true)
    private let errorEtiqueta = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let logo = UIImageView(image: UIImage(systemName: "cart.fill"))
        logo.tintColor = .white
        logo.contentMode = .scaleAspectFit
        let fondoLogo = UIView()
        fondoLogo.backgroundColor = .tintColor
        fondoLogo.layer.cornerRadius = 22
        logo.translatesAutoresizingMaskIntoConstraints = false
        fondoLogo.addSubview(logo)
        NSLayoutConstraint.activate([
            fondoLogo.widthAnchor.constraint(equalToConstant: 88),
            fondoLogo.heightAnchor.constraint(equalToConstant: 88),
            logo.centerXAnchor.constraint(equalTo: fondoLogo.centerXAnchor),
            logo.centerYAnchor.constraint(equalTo: fondoLogo.centerYAnchor),
            logo.widthAnchor.constraint(equalToConstant: 48),
            logo.heightAnchor.constraint(equalToConstant: 48)
        ])

        let nombreApp = UILabel()
        nombreApp.text = "Ventas"
        nombreApp.font = .systemFont(ofSize: 32, weight: .bold)
        let subtitulo = UILabel()
        subtitulo.text = "Ingresa con tu usuario y clave"
        subtitulo.textColor = .secondaryLabel

        let cabecera = UIStackView(arrangedSubviews: [fondoLogo, nombreApp, subtitulo])
        cabecera.axis = .vertical
        cabecera.alignment = .center
        cabecera.spacing = 8

        errorEtiqueta.textColor = .systemRed
        errorEtiqueta.font = .preferredFont(forTextStyle: .footnote)
        errorEtiqueta.textAlignment = .center
        errorEtiqueta.isHidden = true

        let ingresar = UIButton.principal("Ingresar")
        ingresar.addTarget(self, action: #selector(ingresarTocado), for: .touchUpInside)

        let crearCuenta = UIButton(type: .system)
        crearCuenta.setTitle("¿No tienes cuenta? Crear cuenta", for: .normal)
        crearCuenta.addTarget(self, action: #selector(crearCuentaTocado), for: .touchUpInside)

        let espacioSuperior = UIView()
        espacioSuperior.heightAnchor.constraint(equalToConstant: 40).isActive = true

        let pila = UIStackView(arrangedSubviews: [espacioSuperior, cabecera, usuarioCampo, claveCampo,
                                                  errorEtiqueta, ingresar, crearCuenta])
        pila.axis = .vertical
        pila.spacing = 14
        pila.setCustomSpacing(36, after: cabecera)
        view.fijarEnScroll(pila, margen: 28)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    @objc private func ingresarTocado() {
        let usuario = (usuarioCampo.text ?? "").trimmingCharacters(in: .whitespaces)
        let clave = claveCampo.text ?? ""

        let encontrado = BaseDatos.shared.buscar(
            Usuario.self,
            predicado: NSPredicate(format: "usuario ==[c] %@ AND clave == %@", usuario, clave)
        ).first

        guard let usuarioValido = encontrado else {
            // Mensaje genérico: no se dice si falló el usuario o la clave.
            errorEtiqueta.text = "Usuario o clave incorrectos"
            errorEtiqueta.isHidden = false
            return
        }
        errorEtiqueta.isHidden = true
        Sesion.shared.usuario = usuarioValido
        sceneDelegate?.mostrarApp()
    }

    @objc private func crearCuentaTocado() {
        navigationController?.pushViewController(RegistroViewController(), animated: true)
    }
}
