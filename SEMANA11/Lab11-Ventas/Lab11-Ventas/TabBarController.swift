import UIKit

/// Pestañas según el rol del usuario de la sesión.
/// Vendedor: Productos, Clientes, Venta, Mis ventas, Cuenta.
/// Supervisor: Resumen, Ventas, Productos, Clientes, Cuenta.
final class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Barra opaca: algunas pantallas tienen la tabla debajo de una cabecera
        // y la barra no detecta el borde del scroll.
        let apariencia = UITabBarAppearance()
        apariencia.configureWithDefaultBackground()
        tabBar.standardAppearance = apariencia
        tabBar.scrollEdgeAppearance = apariencia

        let productos = pestana(ProductosViewController(), "Productos", "shippingbox")
        let clientes = pestana(ClientesViewController(), "Clientes", "person.2")
        let cuenta = pestana(CuentaViewController(), "Cuenta", "person.crop.circle")

        if Sesion.shared.esSupervisor {
            viewControllers = [
                pestana(ResumenViewController(), "Resumen", "chart.bar"),
                pestana(VentasViewController(modo: .equipo), "Ventas", "list.bullet.rectangle"),
                productos, clientes, cuenta
            ]
        } else {
            viewControllers = [
                productos, clientes,
                pestana(NuevaVentaViewController(), "Venta", "cart.badge.plus"),
                pestana(VentasViewController(modo: .propias), "Mis ventas", "list.bullet.rectangle"),
                cuenta
            ]
        }
    }

    private func pestana(_ controlador: UIViewController, _ titulo: String, _ icono: String) -> UINavigationController {
        controlador.title = titulo
        let navegacion = UINavigationController(rootViewController: controlador)
        navegacion.navigationBar.prefersLargeTitles = true
        navegacion.tabBarItem = UITabBarItem(title: titulo, image: UIImage(systemName: icono), selectedImage: nil)
        return navegacion
    }
}
