import UIKit

/// Pestañas según el rol del usuario de la sesión.
/// En Main.storyboard este Tab Bar Controller tiene las 7 pestañas posibles (flechas de
/// relación), cada una con un Tag en su Tab Bar Item. Aquí se dejan solo las del rol:
/// Vendedor: Productos, Clientes, Venta, Mis ventas, Cuenta.
/// Supervisor: Resumen, Ventas, Productos, Clientes, Cuenta.
final class TabBarController: UITabBarController {

    private enum Pestana: Int {
        case resumen = 1, ventasEquipo, productos, clientes, nuevaVenta, misVentas, cuenta
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Barra opaca: algunas pantallas tienen la tabla debajo de una cabecera
        // y la barra no detecta el borde del scroll.
        let apariencia = UITabBarAppearance()
        apariencia.configureWithDefaultBackground()
        tabBar.standardAppearance = apariencia
        tabBar.scrollEdgeAppearance = apariencia

        let delRol: [Pestana] = Sesion.shared.esSupervisor
            ? [.resumen, .ventasEquipo, .productos, .clientes, .cuenta]
            : [.productos, .clientes, .nuevaVenta, .misVentas, .cuenta]

        let todas = viewControllers ?? []
        viewControllers = delRol.compactMap { pestana in
            todas.first { $0.tabBarItem.tag == pestana.rawValue }.map(enNavegacion)
        }
    }

    /// Cada pestaña va dentro de una navegación (título y botón +). A9 (Resumen) tiene su
    /// propia cabecera con saludo, así que su barra de navegación queda oculta.
    private func enNavegacion(_ pantalla: UIViewController) -> UINavigationController {
        let item = pantalla.tabBarItem
        let navegacion = UINavigationController(rootViewController: pantalla)
        navegacion.isNavigationBarHidden = item?.tag == Pestana.resumen.rawValue
        navegacion.tabBarItem = item
        return navegacion
    }
}
