import UIKit

/// Fila horizontal de chips seleccionables (categorías, vendedores).
final class ChipsView: UIScrollView {
    private let fila = UIStackView()
    private var botones: [UIButton] = []
    private(set) var seleccion = 0
    var alCambiar: ((Int) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        showsHorizontalScrollIndicator = false
        fila.axis = .horizontal
        fila.spacing = 8
        fila.translatesAutoresizingMaskIntoConstraints = false
        addSubview(fila)
        NSLayoutConstraint.activate([
            fila.leadingAnchor.constraint(equalTo: contentLayoutGuide.leadingAnchor, constant: 16),
            fila.trailingAnchor.constraint(equalTo: contentLayoutGuide.trailingAnchor, constant: -16),
            fila.topAnchor.constraint(equalTo: contentLayoutGuide.topAnchor, constant: 6),
            fila.bottomAnchor.constraint(equalTo: contentLayoutGuide.bottomAnchor, constant: -6),
            fila.heightAnchor.constraint(equalTo: frameLayoutGuide.heightAnchor, constant: -12),
            heightAnchor.constraint(equalToConstant: 46)
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) no se usa") }

    func configurar(opciones: [String], seleccion: Int = 0) {
        botones.forEach { $0.removeFromSuperview() }
        botones = opciones.enumerated().map { indice, titulo in
            var configuracion = UIButton.Configuration.filled()
            configuracion.title = titulo
            configuracion.cornerStyle = .capsule
            configuracion.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 14, bottom: 6, trailing: 14)
            let boton = UIButton(configuration: configuracion)
            boton.tag = indice
            boton.addTarget(self, action: #selector(tocar(_:)), for: .touchUpInside)
            fila.addArrangedSubview(boton)
            return boton
        }
        self.seleccion = min(seleccion, max(opciones.count - 1, 0))
        pintar()
    }

    @objc private func tocar(_ boton: UIButton) {
        seleccion = boton.tag
        pintar()
        alCambiar?(seleccion)
    }

    private func pintar() {
        for boton in botones {
            let activo = boton.tag == seleccion
            boton.configuration?.baseBackgroundColor = activo ? .tintColor : .secondarySystemFill
            boton.configuration?.baseForegroundColor = activo ? .white : .label
        }
    }
}

/// Tarjeta con un título pequeño, un valor grande y un detalle.
final class IndicadorView: UIView {
    let titulo = UILabel()
    let valor = UILabel()
    let detalle = UILabel()

    init(titulo texto: String) {
        super.init(frame: .zero)
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 12

        titulo.text = texto
        titulo.font = .preferredFont(forTextStyle: .caption1)
        titulo.textColor = .secondaryLabel
        valor.font = .systemFont(ofSize: 20, weight: .bold)
        valor.adjustsFontSizeToFitWidth = true
        valor.minimumScaleFactor = 0.6
        detalle.font = .preferredFont(forTextStyle: .caption1)
        detalle.textColor = .secondaryLabel
        detalle.numberOfLines = 2

        let pila = UIStackView(arrangedSubviews: [titulo, valor, detalle])
        pila.axis = .vertical
        pila.spacing = 4
        pila.translatesAutoresizingMaskIntoConstraints = false
        addSubview(pila)
        NSLayoutConstraint.activate([
            pila.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            pila.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            pila.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            pila.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) no se usa") }
}

extension UIViewController {
    func mostrarAlerta(_ titulo: String, _ mensaje: String, alCerrar: (() -> Void)? = nil) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Aceptar", style: .default) { _ in alCerrar?() })
        present(alerta, animated: true)
    }

    /// Formulario corto dentro de una alerta: un campo por cada (placeholder, valor, teclado).
    func pedirDatos(titulo: String,
                    campos: [(placeholder: String, valor: String?, teclado: UIKeyboardType)],
                    alGuardar: @escaping ([String]) -> Void) {
        let alerta = UIAlertController(title: titulo, message: nil, preferredStyle: .alert)
        for campo in campos {
            alerta.addTextField { texto in
                texto.placeholder = campo.placeholder
                texto.text = campo.valor
                texto.keyboardType = campo.teclado
                texto.autocapitalizationType = .sentences
            }
        }
        alerta.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alerta.addAction(UIAlertAction(title: "Guardar", style: .default) { _ in
            let valores = (alerta.textFields ?? []).map {
                ($0.text ?? "").trimmingCharacters(in: .whitespaces)
            }
            alGuardar(valores)
        })
        present(alerta, animated: true)
    }
}

extension UITextField {
    /// Campo con fondo gris y bordes redondeados, usado en login, registro y venta.
    static func campo(_ placeholder: String, seguro: Bool = false) -> UITextField {
        let campo = UITextField()
        campo.placeholder = placeholder
        campo.isSecureTextEntry = seguro
        campo.autocapitalizationType = .none
        campo.autocorrectionType = .no
        campo.backgroundColor = .secondarySystemBackground
        campo.layer.cornerRadius = 10
        campo.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 1))
        campo.leftViewMode = .always
        campo.heightAnchor.constraint(equalToConstant: 46).isActive = true
        return campo
    }
}

extension UIButton {
    static func principal(_ titulo: String) -> UIButton {
        let boton = UIButton(type: .system)
        boton.setTitle(titulo, for: .normal)
        boton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        boton.backgroundColor = .tintColor
        boton.setTitleColor(.white, for: .normal)
        boton.layer.cornerRadius = 12
        boton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return boton
    }
}

extension UIView {
    /// Pone la vista dentro de un scroll que ocupa toda la pantalla, con márgenes.
    func fijarEnScroll(_ contenido: UIView, margen: CGFloat = 20) {
        let scroll = UIScrollView()
        scroll.keyboardDismissMode = .interactive
        scroll.translatesAutoresizingMaskIntoConstraints = false
        contenido.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scroll)
        scroll.addSubview(contenido)
        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scroll.bottomAnchor.constraint(equalTo: bottomAnchor),
            scroll.leadingAnchor.constraint(equalTo: leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: trailingAnchor),
            contenido.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor, constant: margen),
            contenido.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor, constant: -margen),
            contenido.leadingAnchor.constraint(equalTo: scroll.frameLayoutGuide.leadingAnchor, constant: margen),
            contenido.trailingAnchor.constraint(equalTo: scroll.frameLayoutGuide.trailingAnchor, constant: -margen)
        ])
    }
}
