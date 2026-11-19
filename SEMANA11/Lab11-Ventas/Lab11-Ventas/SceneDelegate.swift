import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private let storyboard = UIStoryboard(name: "Main", bundle: nil)

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        window = UIWindow(windowScene: windowScene)
        window?.makeKeyAndVisible()
        mostrarLogin()
    }

    /// Pantalla inicial: el login de Main.storyboard (la escena con la flecha de inicio)
    /// dentro de una navegación, para que el segue a Crear cuenta pueda apilarse.
    func mostrarLogin() {
        guard let login = storyboard.instantiateInitialViewController() else { return }
        cambiarRaiz(UINavigationController(rootViewController: login))
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
