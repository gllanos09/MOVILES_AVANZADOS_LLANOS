// ============================================================
// METRO DE LIMA — Terminal App
// Desarrollado por: Gabriel Llanos
// ============================================================

import Foundation

// ─── JSON DATA ───────────────────────────────────────────────
let jsonString = """
{
  "lineas": [
    {
      "id": "L1",
      "nombre": "Línea 1",
      "color": "Verde",
      "tipo": "Elevado/Superficie",
      "operativa": true,
      "inicio": "Villa El Salvador",
      "fin": "Bayóvar",
      "horario_semana": "05:00 - 22:00",
      "horario_domingo": "05:30 - 22:00",
      "tarifa": 1.50,
      "estaciones": [
        {
          "id": "L1-E01",
          "nombre": "Villa El Salvador",
          "orden": 1,
          "distrito": "Villa El Salvador",
          "estado": "operativa",
          "referencias": ["Parque Huáscar", "Av. Revolución", "Mercado Central VES"],
          "estaciones_cercanas": []
        },
        {
          "id": "L1-E02",
          "nombre": "Parque Industrial",
          "orden": 2,
          "distrito": "Villa El Salvador",
          "estado": "operativa",
          "referencias": ["Zona Industrial VES", "Av. Pastor Sevilla"],
          "estaciones_cercanas": []
        },
        {
          "id": "L1-E03",
          "nombre": "Pumacahua",
          "orden": 3,
          "distrito": "Villa María del Triunfo",
          "estado": "operativa",
          "referencias": ["Av. Pumacahua", "Mercado VMT"],
          "estaciones_cercanas": []
        },
        {
          "id": "L1-E04",
          "nombre": "Villa María",
          "orden": 4,
          "distrito": "Villa María del Triunfo",
          "estado": "operativa",
          "referencias": ["Av. Salvador Allende", "Hospital VMT"],
          "estaciones_cercanas": []
        },
        {
          "id": "L1-E05",
          "nombre": "María Auxiliadora",
          "orden": 5,
          "distrito": "San Juan de Miraflores",
          "estado": "operativa",
          "referencias": ["Hospital María Auxiliadora", "Av. Miguel Iglesias"],
          "estaciones_cercanas": []
        },
        {
          "id": "L1-E06",
          "nombre": "San Juan",
          "orden": 6,
          "distrito": "San Juan de Miraflores",
          "estado": "operativa",
          "referencias": ["Av. San Juan", "Municipalidad SJM", "Mega Plaza Sur"],
          "estaciones_cercanas": []
        },
        {
          "id": "L1-E07",
          "nombre": "Atocongo",
          "orden": 7,
          "distrito": "San Juan de Miraflores",
          "estado": "operativa",
          "referencias": ["Cemento Lima", "Av. Atocongo", "Open Plaza Atocongo"],
          "estaciones_cercanas": []
        },
        {
          "id": "L1-E08",
          "nombre": "Jorge Chávez",
          "orden": 8,
          "distrito": "Santiago de Surco",
          "estado": "operativa",
          "referencias": ["Av. Jorge Chávez", "Surco"],
          "estaciones_cercanas": []
        },
        {
          "id": "L1-E09",
          "nombre": "Ayacucho",
          "orden": 9,
          "distrito": "Santiago de Surco",
          "estado": "operativa",
          "referencias": ["Av. Ayacucho", "Surco"],
          "estaciones_cercanas": []
        },
        {
          "id": "L1-E10",
          "nombre": "Cabitos",
          "orden": 10,
          "distrito": "Santiago de Surco",
          "estado": "operativa",
          "referencias": ["Cuartel Cabitos", "Av. Santiago de Surco"],
          "estaciones_cercanas": []
        },
        {
          "id": "L1-E11",
          "nombre": "Angamos",
          "orden": 11,
          "distrito": "Surquillo",
          "estado": "operativa",
          "referencias": ["Av. Angamos", "Surquillo", "Mercado Surquillo"],
          "estaciones_cercanas": []
        },
        {
          "id": "L1-E12",
          "nombre": "San Borja Sur",
          "orden": 12,
          "distrito": "San Borja",
          "estado": "operativa",
          "referencias": ["Av. San Borja Sur", "Biblioteca Nacional", "Ministerio de Educación"],
          "estaciones_cercanas": []
        },
        {
          "id": "L1-E13",
          "nombre": "La Cultura",
          "orden": 13,
          "distrito": "San Borja",
          "estado": "operativa",
          "referencias": ["Museo de la Nación", "Ministerio de Cultura", "Av. Javier Prado Este"],
          "estaciones_cercanas": []
        },
        {
          "id": "L1-E14",
          "nombre": "Arriola",
          "orden": 14,
          "distrito": "La Victoria",
          "estado": "operativa",
          "referencias": ["Av. Arriola", "La Victoria"],
          "estaciones_cercanas": []
        },
        {
          "id": "L1-E15",
          "nombre": "Gamarra",
          "orden": 15,
          "distrito": "La Victoria",
          "estado": "operativa",
          "referencias": ["Emporio Gamarra", "Av. Isabel la Católica", "La Victoria"],
          "estaciones_cercanas": [
            {
              "estacion": "28 de Julio",
              "linea": "L2",
              "distancia_metros": 600,
              "nota": "Sin transbordo oficial, requiere caminar"
            }
          ]
        },
        {
          "id": "L1-E16",
          "nombre": "Miguel Grau",
          "orden": 16,
          "distrito": "La Victoria",
          "estado": "operativa",
          "referencias": ["Av. Miguel Grau", "Cercado de Lima"],
          "estaciones_cercanas": []
        },
        {
          "id": "L1-E17",
          "nombre": "El Ángel",
          "orden": 17,
          "distrito": "El Agustino",
          "estado": "operativa",
          "referencias": ["Cementerio El Ángel", "Av. Riva Agüero"],
          "estaciones_cercanas": []
        },
        {
          "id": "L1-E18",
          "nombre": "Presbítero Maestro",
          "orden": 18,
          "distrito": "El Agustino",
          "estado": "operativa",
          "referencias": ["Cementerio Presbítero Maestro", "Av. Luna Pizarro"],
          "estaciones_cercanas": []
        },
        {
          "id": "L1-E19",
          "nombre": "Caja de Agua",
          "orden": 19,
          "distrito": "San Juan de Lurigancho",
          "estado": "operativa",
          "referencias": ["Av. Próceres de la Independencia", "SJL"],
          "estaciones_cercanas": []
        },
        {
          "id": "L1-E20",
          "nombre": "Pirámide del Sol",
          "orden": 20,
          "distrito": "San Juan de Lurigancho",
          "estado": "operativa",
          "referencias": ["Av. Pirámide del Sol", "SJL"],
          "estaciones_cercanas": []
        },
        {
          "id": "L1-E21",
          "nombre": "Los Jardines",
          "orden": 21,
          "distrito": "San Juan de Lurigancho",
          "estado": "operativa",
          "referencias": ["Av. Los Jardines", "SJL"],
          "estaciones_cercanas": []
        },
        {
          "id": "L1-E22",
          "nombre": "Los Postes",
          "orden": 22,
          "distrito": "San Juan de Lurigancho",
          "estado": "operativa",
          "referencias": ["Av. Los Postes", "SJL"],
          "estaciones_cercanas": []
        },
        {
          "id": "L1-E23",
          "nombre": "San Carlos",
          "orden": 23,
          "distrito": "San Juan de Lurigancho",
          "estado": "operativa",
          "referencias": ["Av. San Carlos", "Universidad César Vallejo SJL"],
          "estaciones_cercanas": []
        },
        {
          "id": "L1-E24",
          "nombre": "San Martín",
          "orden": 24,
          "distrito": "San Juan de Lurigancho",
          "estado": "operativa",
          "referencias": ["Av. San Martín", "SJL"],
          "estaciones_cercanas": []
        },
        {
          "id": "L1-E25",
          "nombre": "Santa Rosa",
          "orden": 25,
          "distrito": "San Juan de Lurigancho",
          "estado": "operativa",
          "referencias": ["Av. Santa Rosa", "SJL"],
          "estaciones_cercanas": []
        },
        {
          "id": "L1-E26",
          "nombre": "Bayóvar",
          "orden": 26,
          "distrito": "San Juan de Lurigancho",
          "estado": "operativa",
          "referencias": ["Terminal Bayóvar", "Av. Wiesse", "SJL"],
          "estaciones_cercanas": []
        }
      ]
    },
    {
      "id": "L2",
      "nombre": "Línea 2",
      "color": "Amarillo",
      "tipo": "Subterráneo",
      "operativa": true,
      "inicio": "Municipalidad de Ate",
      "fin": "Puerto del Callao",
      "horario_semana": "06:00 - 23:00",
      "horario_domingo": "06:00 - 23:00",
      "tarifa": 1.40,
      "estaciones": [
        {
          "id": "L2-E01",
          "nombre": "Municipalidad de Ate",
          "orden": 1,
          "distrito": "Ate",
          "estado": "en_construccion",
          "referencias": ["Municipalidad de Ate", "Av. Nicolás Ayllón"],
          "estaciones_cercanas": []
        },
        {
          "id": "L2-E02",
          "nombre": "Prolongación Javier Prado",
          "orden": 2,
          "distrito": "Ate",
          "estado": "en_construccion",
          "referencias": ["Av. Javier Prado Este", "Ate"],
          "estaciones_cercanas": []
        },
        {
          "id": "L2-E03",
          "nombre": "Vista Alegre",
          "orden": 3,
          "distrito": "Ate",
          "estado": "en_construccion",
          "referencias": ["Urb. Vista Alegre", "Ate"],
          "estaciones_cercanas": []
        },
        {
          "id": "L2-E04",
          "nombre": "Mercado Santa Anita",
          "orden": 4,
          "distrito": "Santa Anita",
          "estado": "operativa",
          "referencias": ["Mercado Santa Anita", "Av. Los Eucaliptos"],
          "estaciones_cercanas": []
        },
        {
          "id": "L2-E05",
          "nombre": "Hermilio Valdizán",
          "orden": 5,
          "distrito": "Santa Anita",
          "estado": "operativa",
          "referencias": ["Hospital Hermilio Valdizán", "Santa Anita"],
          "estaciones_cercanas": []
        },
        {
          "id": "L2-E06",
          "nombre": "Colectora Industrial",
          "orden": 6,
          "distrito": "Santa Anita",
          "estado": "operativa",
          "referencias": ["Av. Colectora Industrial", "Santa Anita"],
          "estaciones_cercanas": []
        },
        {
          "id": "L2-E07",
          "nombre": "Óvalo Santa Anita",
          "orden": 7,
          "distrito": "Santa Anita",
          "estado": "operativa",
          "referencias": ["Óvalo Santa Anita", "Av. Los Frutales"],
          "estaciones_cercanas": []
        },
        {
          "id": "L2-E08",
          "nombre": "Evitamiento",
          "orden": 8,
          "distrito": "San Luis",
          "estado": "operativa",
          "referencias": ["Vía de Evitamiento", "San Luis"],
          "estaciones_cercanas": []
        },
        {
          "id": "L2-E09",
          "nombre": "San Juan de Dios",
          "orden": 9,
          "distrito": "San Luis",
          "estado": "en_construccion",
          "referencias": ["Clínica San Juan de Dios", "San Luis"],
          "estaciones_cercanas": []
        },
        {
          "id": "L2-E10",
          "nombre": "Circunvalación",
          "orden": 10,
          "distrito": "San Luis",
          "estado": "en_construccion",
          "referencias": ["Av. Circunvalación", "San Luis"],
          "estaciones_cercanas": []
        },
        {
          "id": "L2-E11",
          "nombre": "Nicolás Ayllón",
          "orden": 11,
          "distrito": "La Victoria",
          "estado": "en_construccion",
          "referencias": ["Av. Nicolás Ayllón", "La Victoria"],
          "estaciones_cercanas": []
        },
        {
          "id": "L2-E12",
          "nombre": "28 de Julio",
          "orden": 12,
          "distrito": "La Victoria",
          "estado": "en_construccion",
          "referencias": ["Av. 28 de Julio", "La Victoria"],
          "estaciones_cercanas": [
            {
              "estacion": "Gamarra",
              "linea": "L1",
              "distancia_metros": 600,
              "nota": "Sin transbordo oficial, requiere caminar"
            }
          ]
        },
        {
          "id": "L2-E13",
          "nombre": "Cangallo",
          "orden": 13,
          "distrito": "La Victoria",
          "estado": "en_construccion",
          "referencias": ["Av. Cangallo", "La Victoria"],
          "estaciones_cercanas": []
        },
        {
          "id": "L2-E14",
          "nombre": "Manco Cápac",
          "orden": 14,
          "distrito": "La Victoria",
          "estado": "en_construccion",
          "referencias": ["Plaza Manco Cápac", "La Victoria"],
          "estaciones_cercanas": []
        },
        {
          "id": "L2-E15",
          "nombre": "Estación Central",
          "orden": 15,
          "distrito": "Lima",
          "estado": "en_construccion",
          "referencias": ["Paseo Colón", "Centro de Lima", "Metropolitano"],
          "estaciones_cercanas": []
        },
        {
          "id": "L2-E16",
          "nombre": "Plaza Bolognesi",
          "orden": 16,
          "distrito": "Lima",
          "estado": "en_construccion",
          "referencias": ["Plaza Bolognesi", "Av. Alfonso Ugarte"],
          "estaciones_cercanas": []
        },
        {
          "id": "L2-E17",
          "nombre": "Parque Murillo",
          "orden": 17,
          "distrito": "Breña",
          "estado": "en_construccion",
          "referencias": ["Parque Murillo", "Breña"],
          "estaciones_cercanas": []
        },
        {
          "id": "L2-E18",
          "nombre": "Tingo María",
          "orden": 18,
          "distrito": "Breña",
          "estado": "en_construccion",
          "referencias": ["Av. Tingo María", "Breña"],
          "estaciones_cercanas": []
        },
        {
          "id": "L2-E19",
          "nombre": "La Alborada",
          "orden": 19,
          "distrito": "Lima",
          "estado": "en_construccion",
          "referencias": ["Av. Venezuela", "Cercado de Lima"],
          "estaciones_cercanas": []
        },
        {
          "id": "L2-E20",
          "nombre": "Elio",
          "orden": 20,
          "distrito": "Lima",
          "estado": "en_construccion",
          "referencias": ["Av. Germán Amézaga", "UNMSM", "Ciudad Universitaria"],
          "estaciones_cercanas": []
        },
        {
          "id": "L2-E21",
          "nombre": "San Marcos",
          "orden": 21,
          "distrito": "Lima",
          "estado": "en_construccion",
          "referencias": ["Universidad Nacional Mayor de San Marcos", "Av. Venezuela"],
          "estaciones_cercanas": []
        },
        {
          "id": "L2-E22",
          "nombre": "Óscar R. Benavides",
          "orden": 22,
          "distrito": "Lima",
          "estado": "en_construccion",
          "referencias": ["Av. Oscar R. Benavides", "Av. Colonial"],
          "estaciones_cercanas": []
        },
        {
          "id": "L2-E23",
          "nombre": "Carmen de la Legua",
          "orden": 23,
          "distrito": "Carmen de la Legua",
          "estado": "en_construccion",
          "referencias": ["Av. Oscar R. Benavides", "Carmen de la Legua"],
          "estaciones_cercanas": []
        },
        {
          "id": "L2-E24",
          "nombre": "Insurgentes",
          "orden": 24,
          "distrito": "Callao",
          "estado": "en_construccion",
          "referencias": ["Av. Insurgentes", "Callao"],
          "estaciones_cercanas": []
        },
        {
          "id": "L2-E25",
          "nombre": "Juan Pablo II",
          "orden": 25,
          "distrito": "Callao",
          "estado": "en_construccion",
          "referencias": ["Av. Juan Pablo II", "Callao"],
          "estaciones_cercanas": []
        },
        {
          "id": "L2-E26",
          "nombre": "Buenos Aires",
          "orden": 26,
          "distrito": "Callao",
          "estado": "en_construccion",
          "referencias": ["Av. Buenos Aires", "Callao"],
          "estaciones_cercanas": []
        },
        {
          "id": "L2-E27",
          "nombre": "Puerto del Callao",
          "orden": 27,
          "distrito": "Callao",
          "estado": "en_construccion",
          "referencias": ["Puerto del Callao", "Terminal Marítimo", "Av. Guardia Chalaca"],
          "estaciones_cercanas": []
        }
      ]
    }
  ]
}
"""

// ─── NORMALIZACIÓN DE TEXTO ──────────────────────────────────
func normalizar(_ texto: String) -> String {
    let caracteresBase = [
        "á": "a", "é": "e", "í": "i", "ó": "o", "ú": "u",
        "Á": "a", "É": "e", "Í": "i", "Ó": "o", "Ú": "u",
        "ñ": "n", "Ñ": "n", "ü": "u", "Ü": "u"
    ]
    var resultado = texto.lowercased()
    for (con, sin) in caracteresBase {
        resultado = resultado.replacingOccurrences(of: con, with: sin)
    }
    return resultado.trimmingCharacters(in: .whitespaces)
}

// ─── PARSEO DEL JSON ─────────────────────────────────────────
var lineas: [[String: Any]] = []

func cargarDatos() {
    guard let data = jsonString.data(using: .utf8) else {
        print("Error: no se pudo convertir el JSON a datos.")
        return
    }
    guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
        print("Error: JSON inválido.")
        return
    }
    guard let lineasJSON = json["lineas"] as? [[String: Any]] else {
        print("Error: no se encontraron líneas en el JSON.")
        return
    }
    lineas = lineasJSON
    print("✅ Datos cargados: \(lineas.count) líneas encontradas.")
}

// ─── INICIO ──────────────────────────────────────────────────
cargarDatos()

// ─── BÚSQUEDA DE ESTACIONES ──────────────────────────────────
func buscarEstacion(_ termino: String) -> [[String: Any]] {
    let terminoNorm = normalizar(termino)
    var resultados: [[String: Any]] = []

    for linea in lineas {
        guard let estaciones = linea["estaciones"] as? [[String: Any]] else { continue }
        for estacion in estaciones {
            let nombre = estacion["nombre"] as? String ?? ""
            let distrito = estacion["distrito"] as? String ?? ""
            let referencias = estacion["referencias"] as? [String] ?? []

            // Buscar por nombre
            if normalizar(nombre).contains(terminoNorm) {
                resultados.append(estacion)
                continue
            }
            // Buscar por distrito
            if normalizar(distrito).contains(terminoNorm) {
                resultados.append(estacion)
                continue
            }
            // Buscar por referencias
            for ref in referencias {
                if normalizar(ref).contains(terminoNorm) {
                    resultados.append(estacion)
                    break
                }
            }
        }
    }
    return resultados
}

// ─── OBTENER LÍNEA DE UNA ESTACIÓN ───────────────────────────
func obtenerLinea(deEstacion idEstacion: String) -> [String: Any]? {
    for linea in lineas {
        guard let estaciones = linea["estaciones"] as? [[String: Any]] else { continue }
        for estacion in estaciones {
            if let id = estacion["id"] as? String, id == idEstacion {
                return linea
            }
        }
    }
    return nil
}

// ─── BUSCAR RUTA ─────────────────────────────────────────────
func buscarRuta(origen: String, destino: String) {
    let resultadosOrigen = buscarEstacion(origen)
    let resultadosDestino = buscarEstacion(destino)

    guard !resultadosOrigen.isEmpty else {
        print("⚠️  No encontré la estación de origen: \(origen)")
        return
    }
    guard !resultadosDestino.isEmpty else {
        print("⚠️  No encontré la estación de destino: \(destino)")
        return
    }

    let estOrigen = resultadosOrigen[0]
    let estDestino = resultadosDestino[0]

    let idOrigen = estOrigen["id"] as? String ?? ""
    let idDestino = estDestino["id"] as? String ?? ""
    let nombreOrigen = estOrigen["nombre"] as? String ?? ""
    let nombreDestino = estDestino["nombre"] as? String ?? ""

    let lineaOrigen = idOrigen.components(separatedBy: "-")[0]
    let lineaDestino = idDestino.components(separatedBy: "-")[0]

    print("\n📍 Origen:  \(nombreOrigen)")
    print("📍 Destino: \(nombreDestino)")

    if lineaOrigen == lineaDestino {
        // Misma línea
        guard let linea = obtenerLinea(deEstacion: idOrigen),
              let estaciones = linea["estaciones"] as? [[String: Any]],
              let nombreLinea = linea["nombre"] as? String else { return }

        let ordenOrigen = estOrigen["orden"] as? Int ?? 0
        let ordenDestino = estDestino["orden"] as? Int ?? 0
        let min = Swift.min(ordenOrigen, ordenDestino)
        let max = Swift.max(ordenOrigen, ordenDestino)
        let intermedias = estaciones.filter {
            let orden = $0["orden"] as? Int ?? 0
            return orden > min && orden < max
        }

        print("\n🚇 Toma la \(nombreLinea)")
        print("   Estaciones intermedias: \(intermedias.count)")
        if !intermedias.isEmpty {
            for est in intermedias {
                let nombre = est["nombre"] as? String ?? ""
                print("   → \(nombre)")
            }
        }
    } else {
        // Distinta línea — buscar estaciones cercanas
        let cercanas = estOrigen["estaciones_cercanas"] as? [[String: Any]] ?? []
        if !cercanas.isEmpty {
            print("\n🔀 No hay transbordo directo entre líneas.")
            for cercana in cercanas {
                let nombre = cercana["estacion"] as? String ?? ""
                let linea = cercana["linea"] as? String ?? ""
                let distancia = cercana["distancia_metros"] as? Int ?? 0
                let nota = cercana["nota"] as? String ?? ""
                print("   Estación cercana: \(nombre) (\(linea)) — \(distancia)m")
                print("   Nota: \(nota)")
            }
        } else {
            print("\n🔀 Las estaciones están en líneas distintas.")
            print("   Por ahora no hay conexión directa entre ellas.")
            print("   Usa la opción 1 para preguntarle a la IA cómo llegar.")
        }
    }
}
