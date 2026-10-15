//
//  Cultura.swift
//  Semana07_Llanos
//

import UIKit

class Cultura {
    
    var nombre: String
    var region: String
    var descripcion: String
    var imagen: String
    var aportes: [Aporte]
    
    init(nombre: String, region: String, descripcion: String, imagen: String, aportes: [Aporte]) {
        self.nombre = nombre
        self.region = region
        self.descripcion = descripcion
        self.imagen = imagen
        self.aportes = aportes
    }
}
