//
//  DetalleViewController.swift
//  Semana07_Llanos
//

import UIKit

class DetalleViewController: UIViewController {

    @IBOutlet weak var imgDetalle: UIImageView!
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var lblRegion: UILabel!
    @IBOutlet weak var lblDescripcion: UILabel!
    @IBOutlet weak var btnQueOfrece: UIButton!

    var cultura: Cultura?

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let cultura = cultura else { return }

        title = cultura.nombre
        imgDetalle.image = UIImage(named: cultura.imagen)
        lblNombre.text = cultura.nombre
        lblRegion.text = cultura.region
        lblDescripcion.text = cultura.descripcion
    }

    // MARK: - Navegacion

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "verAportes" {
            if let destino = segue.destination as? AportesViewController {
                destino.cultura = cultura
            }
        }
    }
}
