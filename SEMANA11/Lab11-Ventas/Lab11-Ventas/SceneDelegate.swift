import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    /// La pantalla inicial es el login de Main.storyboard (la flecha de inicio), dentro de una
    /// navegación para que el segue a Crear cuenta pueda apilarse. El resto del flujo
    /// (entrar, pestañas y cerrar sesión) son segues del storyboard.
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene,
              let login = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = UINavigationController(rootViewController: login)
        window?.makeKeyAndVisible()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        BaseDatos.shared.guardar()
    }
}
