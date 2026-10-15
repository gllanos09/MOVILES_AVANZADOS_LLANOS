//
//  ViewController.swift
//  Semana07_Llanos
//
//  Created by Tecsup on 15/10/26.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tablaCulturas: UITableView!

    var culturas: [Cultura] = []
    var culturaSeleccionada: Cultura?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Culturas Peruanas"
        cargarCulturas()
    }

    func cargarCulturas() {
        // Los datos viven en la capa de repositorio, no en el ViewController.
        culturas = CulturasRepository.obtenerTodas()
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return culturas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celdaCultura", for: indexPath) as! CulturaTableViewCell

        let cultura = culturas[indexPath.row]
        celda.lblNombre.text = cultura.nombre
        celda.imgCultura.image = UIImage(named: cultura.imagen)

        return celda
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Guardamos la cultura elegida. El segue "verDetalle" sale de la celda,
        // por lo que UIKit ya lo dispara solo al tocarla: si llamaramos aqui a
        // performSegue, la pantalla de detalle se abriria dos veces.
        culturaSeleccionada = culturas[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Navegacion

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "verDetalle" {
            guard let destino = segue.destination as? DetalleViewController else { return }

            // La celda que origina el segue viaja en sender; si esta disponible
            // tomamos su fila, y si no usamos la ultima seleccion registrada.
            if let celda = sender as? UITableViewCell,
               let indexPath = tablaCulturas.indexPath(for: celda) {
                destino.cultura = culturas[indexPath.row]
            } else {
                destino.cultura = culturaSeleccionada
            }
        }
    }
}
