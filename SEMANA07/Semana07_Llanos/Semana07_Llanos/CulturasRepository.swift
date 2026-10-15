//
//  CulturasRepository.swift
//  Semana07_Llanos
//
//  Capa de datos: aqui vive la informacion de las culturas.
//  El ViewController solo la pide, no la contiene.
//

import Foundation

class CulturasRepository {

    static func obtenerTodas() -> [Cultura] {
        return [caral(), chavin(), paracas(), nazca(), moche(), wari(), inca()]
    }

    // MARK: - Culturas

    private static func caral() -> Cultura {
        return Cultura(
            nombre: "Caral",
            region: "Costa norcentral - Valle de Supe, Lima",
            descripcion: "Caral es considerada la civilización más antigua de América, con unos 5000 años de antigüedad. Sus habitantes construyeron pirámides escalonadas y plazas circulares hundidas sin conocer la cerámica. Su economía combinaba la agricultura del algodón con el intercambio de productos marinos.",
            imagen: "caral",
            aportes: [
                Aporte(titulo: "Pirámide Mayor",
                       detalle: "Edificio principal de unos 18 m de altura con plaza circular hundida al frente, centro del poder ceremonial."),
                Aporte(titulo: "Quipu más antiguo",
                       detalle: "Se halló un conjunto de cuerdas anudadas de alrededor de 2500 a.C., el registro contable más temprano conocido en los Andes."),
                Aporte(titulo: "Urbanismo planificado",
                       detalle: "La ciudad se organizó en zonas alta y baja, con edificios públicos y residenciales dispuestos según jerarquía social."),
                Aporte(titulo: "Economía sin cerámica",
                       detalle: "Intercambiaban algodón de los valles por pescado y mariscos de la costa, sin usar alfarería."),
                Aporte(titulo: "Antaras y flautas",
                       detalle: "Se recuperaron flautas de hueso de pelícano y cóndor, muestra de una tradición musical ritual."),
                Aporte(titulo: "Shicras antisísmicas",
                       detalle: "Bolsas de fibra vegetal rellenas de piedra usadas como cimiento flexible para resistir sismos.")
            ]
        )
    }

    private static func chavin() -> Cultura {
        return Cultura(
            nombre: "Chavín",
            region: "Sierra norte - Áncash",
            descripcion: "La cultura Chavín floreció alrededor del año 1200 a.C. y es conocida como la cultura matriz del Perú antiguo. Su centro ceremonial, Chavín de Huántar, albergaba galerías subterráneas y el célebre Lanzón monolítico. Destacaron en la escultura en piedra con figuras de felinos, serpientes y aves.",
            imagen: "chavin",
            aportes: [
                Aporte(titulo: "Lanzón Monolítico",
                       detalle: "Escultura de 4.5 m tallada en granito, ubicada en el corazón del templo antiguo."),
                Aporte(titulo: "Estela Raimondi",
                       detalle: "Losa de diorita con la imagen del Dios de los Báculos, legible desde dos orientaciones."),
                Aporte(titulo: "Galerías subterráneas",
                       detalle: "Red de pasadizos con ductos de ventilación y acústica diseñada para el ritual."),
                Aporte(titulo: "Metalurgia del oro",
                       detalle: "Primeras técnicas de soldadura y repujado en los Andes centrales."),
                Aporte(titulo: "Obelisco Tello",
                       detalle: "Monolito que representa un caimán sagrado asociado al origen de las plantas cultivadas."),
                Aporte(titulo: "Cabezas clavas",
                       detalle: "Esculturas empotradas en los muros del templo que muestran la transformación del sacerdote en felino.")
            ]
        )
    }

    private static func paracas() -> Cultura {
        return Cultura(
            nombre: "Paracas",
            region: "Costa sur - Ica",
            descripcion: "Paracas se desarrolló en el desierto de Ica entre los años 700 a.C. y 200 d.C. Son famosos por sus textiles de extraordinaria calidad, bordados con lanas teñidas de colores intensos. También practicaron las trepanaciones craneanas y el fardo funerario para enterrar a sus muertos.",
            imagen: "paracas",
            aportes: [
                Aporte(titulo: "Mantos bordados",
                       detalle: "Tejidos de algodón y lana con cientos de figuras bordadas, considerados entre los mejores textiles del mundo antiguo."),
                Aporte(titulo: "Trepanaciones craneanas",
                       detalle: "Cirugías en el cráneo con cuchillos de obsidiana y placas de oro, con evidencia de pacientes que sobrevivieron."),
                Aporte(titulo: "Fardos funerarios",
                       detalle: "El difunto era envuelto en capas de tejidos finos en posición fetal dentro de cestas."),
                Aporte(titulo: "Deformación craneal",
                       detalle: "Modelaban el cráneo desde la infancia con tablillas para marcar diferencias de rango social."),
                Aporte(titulo: "Necrópolis de Wari Kayan",
                       detalle: "Cementerio subterráneo donde se hallaron más de 400 fardos con sus ajuares completos."),
                Aporte(titulo: "Tintes resistentes",
                       detalle: "Dominaron más de 190 tonalidades obtenidas de plantas y minerales que conservan su color hasta hoy.")
            ]
        )
    }

    private static func nazca() -> Cultura {
        return Cultura(
            nombre: "Nazca",
            region: "Costa sur - Ica",
            descripcion: "La cultura Nazca es mundialmente conocida por sus geoglifos trazados en el desierto, visibles solo desde el aire. Desarrollaron los acueductos subterráneos llamados puquios para enfrentar la aridez de su territorio. Su cerámica polícroma representa animales, plantas y seres mitológicos.",
            imagen: "nazca",
            aportes: [
                Aporte(titulo: "Líneas de Nazca",
                       detalle: "Geoglifos de hasta 300 m trazados en la pampa, con figuras de colibrí, mono y araña."),
                Aporte(titulo: "Acueductos de puquios",
                       detalle: "Galerías filtrantes en espiral que captan agua subterránea y siguen funcionando actualmente."),
                Aporte(titulo: "Cerámica polícroma",
                       detalle: "Vasijas pintadas antes de la cocción con hasta once colores distintos aplicados con engobes."),
                Aporte(titulo: "Centro de Cahuachi",
                       detalle: "Complejo ceremonial de adobe con pirámides, usado como lugar de peregrinación y no como ciudad."),
                Aporte(titulo: "Antaras de cerámica",
                       detalle: "Flautas de pan afinadas con escalas propias, usadas en ceremonias religiosas."),
                Aporte(titulo: "Cabezas trofeo",
                       detalle: "Cráneos preparados con un orificio para colgarlos, asociados a ritos de fertilidad agrícola.")
            ]
        )
    }

    private static func moche() -> Cultura {
        return Cultura(
            nombre: "Moche",
            region: "Costa norte - La Libertad y Lambayeque",
            descripcion: "Los Moche dominaron la costa norte entre los siglos I y VIII d.C. y fueron maestros de la metalurgia del oro, la plata y el cobre. Edificaron las Huacas del Sol y de la Luna con millones de adobes. El hallazgo del Señor de Sipán reveló la riqueza de su élite gobernante.",
            imagen: "moche",
            aportes: [
                Aporte(titulo: "Señor de Sipán",
                       detalle: "Tumba intacta de un gobernante hallada en 1987, con ornamentos de oro, plata y turquesa."),
                Aporte(titulo: "Huacas del Sol y la Luna",
                       detalle: "Dos templos de adobe en Trujillo; la Huaca de la Luna conserva murales polícromos del dios Ai Apaec."),
                Aporte(titulo: "Huacos retrato",
                       detalle: "Ceramios que reproducen rostros humanos reales con enorme realismo, únicos en América precolombina."),
                Aporte(titulo: "Dorado por electroquímica",
                       detalle: "Lograron recubrir cobre con una capa de oro mediante baños químicos, siglos antes que Europa."),
                Aporte(titulo: "Ingeniería hidráulica",
                       detalle: "Canales de riego que unían valles y permitían cultivar en pleno desierto costeño."),
                Aporte(titulo: "Cerámica erótica",
                       detalle: "Representaciones explícitas con un sentido ritual ligado a la fertilidad y al ciclo agrícola.")
            ]
        )
    }

    private static func wari() -> Cultura {
        return Cultura(
            nombre: "Wari",
            region: "Sierra sur - Ayacucho",
            descripcion: "Wari conformó el primer gran imperio andino, expandiéndose desde Ayacucho entre los siglos VII y XII d.C. Construyeron ciudades planificadas con muros de piedra y una extensa red de caminos. Su sistema administrativo y urbano influyó directamente en los incas.",
            imagen: "wari",
            aportes: [
                Aporte(titulo: "Primer imperio andino",
                       detalle: "Unificaron gran parte de los Andes centrales mediante conquista y centros administrativos."),
                Aporte(titulo: "Ciudades planificadas",
                       detalle: "Urbes como Pikillacta y Viracochapampa trazadas en cuadrícula con recintos rectangulares."),
                Aporte(titulo: "Red de caminos",
                       detalle: "Rutas que conectaban los centros provinciales y fueron la base del posterior Qhapaq Ñan inca."),
                Aporte(titulo: "Andenería agrícola",
                       detalle: "Sistematizaron las terrazas de cultivo en laderas para ganar tierra y evitar la erosión."),
                Aporte(titulo: "Textiles de tapiz",
                       detalle: "Túnicas tejidas con diseños geométricos abstractos y altísima densidad de hilos."),
                Aporte(titulo: "Quipus tempranos",
                       detalle: "Usaron cuerdas con nudos para el registro administrativo antes de que los incas los perfeccionaran.")
            ]
        )
    }

    private static func inca() -> Cultura {
        return Cultura(
            nombre: "Inca",
            region: "Sierra sur - Cusco",
            descripcion: "El Tahuantinsuyo fue el imperio más extenso de la América precolombina, con el Cusco como capital. Los incas levantaron obras como Machu Picchu y Sacsayhuamán con una arquitectura de piedra perfectamente ensamblada. Administraron su territorio mediante el quipu, los mitimaes y la red del Qhapaq Ñan.",
            imagen: "inca",
            aportes: [
                Aporte(titulo: "Machu Picchu",
                       detalle: "Santuario construido en el siglo XV sobre una cresta andina, con arquitectura integrada al paisaje."),
                Aporte(titulo: "Qhapaq Ñan",
                       detalle: "Red vial de unos 30 000 km que articulaba los cuatro suyos con tambos y puentes colgantes."),
                Aporte(titulo: "Quipu administrativo",
                       detalle: "Sistema de cuerdas y nudos para registrar censos, tributos y reservas de los depósitos."),
                Aporte(titulo: "Arquitectura sismorresistente",
                       detalle: "Muros de piedra pulida ensamblada sin mortero, con paredes inclinadas y vanos trapezoidales."),
                Aporte(titulo: "Trabajo recíproco",
                       detalle: "Organizaron la mano de obra mediante el ayni, la minka y la mita al servicio del Estado."),
                Aporte(titulo: "Andenes de Moray",
                       detalle: "Terrazas circulares con microclimas escalonados usadas para adaptar cultivos a distintas altitudes.")
            ]
        )
    }
}
