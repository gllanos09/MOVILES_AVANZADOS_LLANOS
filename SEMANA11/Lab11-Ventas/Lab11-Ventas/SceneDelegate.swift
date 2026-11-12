import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        window = UIWindow(windowScene: windowScene)
        window?.makeKeyAndVisible()
        mostrarLogin()
    }

    /// Pantalla inicial: el login dentro de una navegación (para ir a Crear cuenta).
    func mostrarLogin() {
        let navegacion = UINavigationController(rootViewController: LoginViewController())
        cambiarRaiz(navegacion)
    }

    /// Al entrar, se abre el UITabBarController con las pestañas del rol.
    func mostrarApp() {
        cambiarRaiz(TabBarController())
    }

    private func cambiarRaiz(_ controlador: UIViewController) {
        guard let window = window else { return }
        window.rootViewController = controlador
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        BaseDatos.shared.guardar()
    }
}

extension UIViewController {
    var sceneDelegate: SceneDelegate? {
        view.window?.windowScene?.delegate as? SceneDelegate
    }
}
