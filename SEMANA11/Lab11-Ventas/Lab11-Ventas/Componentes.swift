import UIKit

/// Fila horizontal de chips seleccionables (categorías, vendedores).
/// En Main.storyboard se coloca como una vista con la clase ChipsView y alto 46;
/// los botones se crean aquí porque dependen de los datos.
final class ChipsView: UIScrollView {
    private let fila = UIStackView()
    private var botones: [UIButton] = []
    private(set) var seleccion = 0
    var alCambiar: ((Int) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        prepararFila()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        prepararFila()
    }

    private func prepararFila() {
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
            fila.heightAnchor.constraint(equalTo: frameLayoutGuide.heightAnchor, constant: -12)
        ])
    }

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
/// Las tres etiquetas se dibujan en Main.storyboard y se conectan a estos outlets.
final class IndicadorView: UIView {
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var valor: UILabel!
    @IBOutlet weak var detalle: UILabel!
}

/// Cuadro de color con iniciales (productos, clientes, vendedor). El color sale del texto,
/// así cada nombre conserva siempre el mismo color.
final class Iniciales: UILabel {
    private static let colores: [UIColor] = [.systemBlue, .systemPurple, .systemTeal, .systemOrange,
                                              .systemPink, .systemIndigo, .systemGreen, .systemBrown]

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = min(bounds.width, bounds.height) * 0.25
        layer.masksToBounds = true
    }

    /// Muestra las iniciales de un nombre ("Laptop Pro 14" → "LP").
    func mostrar(nombre: String?) {
        let texto = Iniciales.de(nombre)
        mostrar(texto, color: Iniciales.color(para: nombre ?? texto))
    }

    func mostrar(_ texto: String, color: UIColor) {
        text = texto
        backgroundColor = color
    }

    /// "Laptop Pro 14" → "LP"; una sola palabra ("Mouse") → "MO".
    static func de(_ nombre: String?) -> String {
        let partes = (nombre ?? "").split(separator: " ")
        if partes.count == 1, let unica = partes.first { return String(unica.prefix(2)).uppercased() }
        return partes.prefix(2).compactMap { $0.first.map(String.init) }.joined().uppercased()
    }

    static func color(para texto: String) -> UIColor {
        let suma = texto.unicodeScalars.reduce(0) { $0 + Int($1.value) }
        return colores[suma % colores.count]
    }
}

/// Etiqueta en forma de pastilla (stock, categoría, "Anulada", "Reponer", rol).
final class Pastilla: UILabel {
    private let relleno = UIEdgeInsets(top: 2, left: 8, bottom: 2, right: 8)

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: relleno))
    }

    override var intrinsicContentSize: CGSize {
        let base = super.intrinsicContentSize
        return CGSize(width: base.width + relleno.left + relleno.right,
                      height: base.height + relleno.top + relleno.bottom)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
        layer.masksToBounds = true
    }

    func pintar(_ texto: String, _ color: UIColor) {
        text = texto
        backgroundColor = color
    }
}

extension UIViewController {
    /// Botón con las iniciales del usuario de la sesión (arriba a la derecha en A6 y A7).
    /// Al tocarlo se abre la pestaña Cuenta.
    func ponerBotonDeCuenta() {
        let boton = UIButton(type: .system)
        let nombre = Sesion.shared.usuario?.nombre
        boton.setTitle(Iniciales.de(nombre), for: .normal)
        boton.titleLabel?.font = .systemFont(ofSize: 13, weight: .bold)
        boton.setTitleColor(.white, for: .normal)
        boton.backgroundColor = Iniciales.color(para: nombre ?? "")
        boton.layer.cornerRadius = 15
        boton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        boton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        boton.addAction(UIAction { [weak self] _ in
            guard let tab = self?.tabBarController,
                  let indice = tab.viewControllers?.firstIndex(where: { $0.tabBarItem.title == "Cuenta" }) else { return }
            tab.selectedIndex = indice
        }, for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: boton)
    }

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
