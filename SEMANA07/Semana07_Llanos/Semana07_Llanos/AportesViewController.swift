//
//  AportesViewController.swift
//  Semana07_Llanos
//
//  Tercera pantalla: lista ordenada de lo que ofrece visitar la cultura.
//

import UIKit

class AportesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tablaAportes: UITableView!

    var cultura: Cultura?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Qué ofrece"

        // La celda crece segun el largo del detalle.
        tablaAportes.rowHeight = UITableView.automaticDimension
        tablaAportes.estimatedRowHeight = 70

        tablaAportes.reloadData()
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cultura?.aportes.count ?? 0
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return cultura?.nombre
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celdaAporte", for: indexPath)

        let aporte = cultura?.aportes[indexPath.row]
        celda.textLabel?.text = aporte?.titulo
        celda.textLabel?.font = .preferredFont(forTextStyle: .headline)
        celda.detailTextLabel?.text = aporte?.detalle
        celda.detailTextLabel?.numberOfLines = 0
        celda.selectionStyle = .none

        return celda
    }
}
