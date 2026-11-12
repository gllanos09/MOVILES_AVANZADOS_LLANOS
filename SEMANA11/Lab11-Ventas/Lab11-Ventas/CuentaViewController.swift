import UIKit

/// Cuenta: nombre, usuario, rol y el botón Cerrar sesión.
final class CuentaViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let usuario = Sesion.shared.usuario

        let avatar = UIImageView(image: UIImage(systemName: "person.crop.circle.fill"))
        avatar.tintColor = .tintColor
        avatar.contentMode = .scaleAspectFit
        avatar.heightAnchor.constraint(equalToConstant: 80).isActive = true

        let pila = UIStackView(arrangedSubviews: [
            avatar,
            fila("Nombre", usuario?.nombre),
            fila("Usuario", usuario?.usuario),
            fila("Rol", usuario?.rol)
        ])
        pila.axis = .vertical
        pila.spacing = 12
        pila.setCustomSpacing(24, after: avatar)

        let cerrar = UIButton.principal("Cerrar sesión")
        cerrar.backgroundColor = .systemRed
        cerrar.addTarget(self, action: #selector(cerrarSesion), for: .touchUpInside)
        pila.addArrangedSubview(cerrar)
        pila.setCustomSpacing(32, after: pila.arrangedSubviews[pila.arrangedSubviews.count - 2])

        view.fijarEnScroll(pila)
    }

    private func fila(_ titulo: String, _ valor: String?) -> UIView {
        let etiqueta = UILabel()
        etiqueta.text = titulo
        etiqueta.textColor = .secondaryLabel
        let dato = UILabel()
        dato.text = valor ?? "-"
        dato.font = .systemFont(ofSize: 17, weight: .semibold)
        dato.textAlignment = .right
        let fila = UIStackView(arrangedSubviews: [etiqueta, dato])
        fila.isLayoutMarginsRelativeArrangement = true
        fila.layoutMargins = UIEdgeInsets(top: 12, left: 14, bottom: 12, right: 14)
        fila.backgroundColor = .secondarySystemBackground
        fila.layer.cornerRadius = 10
        return fila
    }

    @objc private func cerrarSesion() {
        Sesion.shared.cerrar()
        sceneDelegate?.mostrarLogin()
    }
}
