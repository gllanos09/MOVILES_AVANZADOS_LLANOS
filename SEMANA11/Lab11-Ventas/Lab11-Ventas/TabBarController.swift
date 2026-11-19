import UIKit

/// Pestañas según el rol del usuario de la sesión.
/// Vendedor: Productos, Clientes, Venta, Mis ventas, Cuenta.
/// Supervisor: Resumen, Ventas, Productos, Clientes, Cuenta.
/// Cada pantalla está diseñada en Main.storyboard y se obtiene por su Storyboard ID;
/// aquí solo se envuelve en una navegación con su ícono de pestaña.
final class TabBarController: UITabBarController {

    private let storyboardPrincipal = UIStoryboard(name: "Main", bundle: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Barra opaca: algunas pantallas tienen la tabla debajo de una cabecera
        // y la barra no detecta el borde del scroll.
        let apariencia = UITabBarAppearance()
        apariencia.configureWithDefaultBackground()
        tabBar.standardAppearance = apariencia
        tabBar.scrollEdgeAppearance = apariencia

        let productos = pestana("Productos", "Productos", "shippingbox")
        let clientes = pestana("Clientes", "Clientes", "person.2")
        let cuenta = pestana("Cuenta", "Cuenta", "person.crop.circle")

        if Sesion.shared.esSupervisor {
            viewControllers = [
                pestana("Resumen", "Resumen", "chart.bar"),
                pestana("VentasEquipo", "Ventas", "list.bullet.rectangle"),
                productos, clientes, cuenta
            ]
        } else {
            viewControllers = [
                productos, clientes,
                pestana("NuevaVenta", "Venta", "cart.badge.plus"),
                pestana("MisVentas", "Mis ventas", "list.bullet.rectangle"),
                cuenta
            ]
        }
    }

    /// Instancia la pantalla del storyboard por su Storyboard ID y la pone en una navegación.
    private func pestana(_ id: String, _ titulo: String, _ icono: String) -> UINavigationController {
        // El título de la barra viene del storyboard ("Nueva venta", "Ventas del equipo"...);
        // aquí solo se pone el texto corto de la pestaña.
        let controlador = storyboardPrincipal.instantiateViewController(withIdentifier: id)
        let navegacion = UINavigationController(rootViewController: controlador)
        // A9 (Resumen) tiene su propia cabecera con saludo: sin barra de navegación.
        navegacion.isNavigationBarHidden = id == "Resumen"
        navegacion.tabBarItem = UITabBarItem(title: titulo, image: UIImage(systemName: icono), selectedImage: nil)
        return navegacion
    }
}
