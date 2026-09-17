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
          "estaciones_cercanas": [
            {
              "estacion": "Cabitos",
              "linea": "L3",
              "distancia_metros": 0,
              "nota": "Transbordo con Línea 3 (planificado)"
            }
          ]
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
          "estaciones_cercanas": [
            {
              "estacion": "Estación Central",
              "linea": "L3",
              "distancia_metros": 0,
              "nota": "Transbordo con Línea 3 (planificado)"
            },
            {
              "estacion": "Estación Central",
              "linea": "MET",
              "distancia_metros": 200,
              "nota": "Conexión con Metropolitano"
            }
          ]
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
          "estaciones_cercanas": [
            {
              "estacion": "Carmen de la Legua",
              "linea": "L4",
              "distancia_metros": 0,
              "nota": "Transbordo con Línea 4 (en construcción)"
            }
          ]
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
    },
    {
      "id": "L3",
      "nombre": "Línea 3",
      "color": "Celeste",
      "tipo": "Subterráneo",
      "operativa": false,
      "inicio": "El Álamo",
      "fin": "Pedro Miotta",
      "horario_semana": "Por definir",
      "horario_domingo": "Por definir",
      "tarifa": 0.0,
      "estaciones": [
        {
          "id": "L3-E01",
          "nombre": "El Álamo",
          "orden": 1,
          "distrito": "Comas",
          "estado": "planificada",
          "referencias": ["Av. El Álamo", "Comas"],
          "estaciones_cercanas": []
        },
        {
          "id": "L3-E02",
          "nombre": "Huandoy",
          "orden": 2,
          "distrito": "Los Olivos",
          "estado": "planificada",
          "referencias": ["Av. Huandoy", "Los Olivos"],
          "estaciones_cercanas": []
        },
        {
          "id": "L3-E03",
          "nombre": "2 de Octubre",
          "orden": 3,
          "distrito": "Los Olivos",
          "estado": "planificada",
          "referencias": ["Av. 2 de Octubre", "Los Olivos"],
          "estaciones_cercanas": []
        },
        {
          "id": "L3-E04",
          "nombre": "Villa Sol",
          "orden": 4,
          "distrito": "Los Olivos",
          "estado": "planificada",
          "referencias": ["Urb. Villa Sol", "Los Olivos"],
          "estaciones_cercanas": []
        },
        {
          "id": "L3-E05",
          "nombre": "Naranjal",
          "orden": 5,
          "distrito": "Independencia",
          "estado": "planificada",
          "referencias": ["Terminal Naranjal", "Metropolitano", "Independencia"],
          "estaciones_cercanas": [
            {
              "estacion": "Naranjal",
              "linea": "MET",
              "distancia_metros": 100,
              "nota": "Conexión con Terminal Naranjal del Metropolitano"
            }
          ]
        },
        {
          "id": "L3-E06",
          "nombre": "Carlos Izaguirre",
          "orden": 6,
          "distrito": "Independencia",
          "estado": "planificada",
          "referencias": ["Av. Carlos Izaguirre", "Independencia"],
          "estaciones_cercanas": []
        },
        {
          "id": "L3-E07",
          "nombre": "Tomás Valle",
          "orden": 7,
          "distrito": "San Martín de Porres",
          "estado": "planificada",
          "referencias": ["Av. Tomás Valle", "SMP"],
          "estaciones_cercanas": []
        },
        {
          "id": "L3-E08",
          "nombre": "Bartolomé de las Casas",
          "orden": 8,
          "distrito": "San Martín de Porres",
          "estado": "planificada",
          "referencias": ["Av. Bartolomé de las Casas", "SMP"],
          "estaciones_cercanas": []
        },
        {
          "id": "L3-E09",
          "nombre": "José Granda",
          "orden": 9,
          "distrito": "San Martín de Porres",
          "estado": "planificada",
          "referencias": ["Av. José Granda", "SMP"],
          "estaciones_cercanas": []
        },
        {
          "id": "L3-E10",
          "nombre": "Caquetá",
          "orden": 10,
          "distrito": "Rímac",
          "estado": "planificada",
          "referencias": ["Av. Caquetá", "Rímac", "Mercado de Caquetá"],
          "estaciones_cercanas": []
        },
        {
          "id": "L3-E11",
          "nombre": "Tacna",
          "orden": 11,
          "distrito": "Lima",
          "estado": "planificada",
          "referencias": ["Av. Tacna", "Centro de Lima"],
          "estaciones_cercanas": []
        },
        {
          "id": "L3-E12",
          "nombre": "Garcilaso de la Vega",
          "orden": 12,
          "distrito": "Lima",
          "estado": "planificada",
          "referencias": ["Av. Garcilaso de la Vega", "Centro de Lima"],
          "estaciones_cercanas": []
        },
        {
          "id": "L3-E13",
          "nombre": "Estación Central",
          "orden": 13,
          "distrito": "Lima",
          "estado": "planificada",
          "referencias": ["Paseo Colón", "Centro de Lima", "Metropolitano"],
          "estaciones_cercanas": [
            {
              "estacion": "Estación Central",
              "linea": "L2",
              "distancia_metros": 0,
              "nota": "Transbordo con Línea 2 (planificado)"
            },
            {
              "estacion": "Estación Central",
              "linea": "MET",
              "distancia_metros": 200,
              "nota": "Conexión con Metropolitano"
            }
          ]
        },
        {
          "id": "L3-E14",
          "nombre": "Parque de la Reserva",
          "orden": 14,
          "distrito": "Lima",
          "estado": "planificada",
          "referencias": ["Parque de la Reserva", "Circuito Mágico del Agua"],
          "estaciones_cercanas": []
        },
        {
          "id": "L3-E15",
          "nombre": "Museo de Historia Natural",
          "orden": 15,
          "distrito": "Jesús María",
          "estado": "planificada",
          "referencias": ["Museo de Historia Natural UNMSM", "Av. Arenales"],
          "estaciones_cercanas": []
        },
        {
          "id": "L3-E16",
          "nombre": "César Canevaro",
          "orden": 16,
          "distrito": "Lince",
          "estado": "planificada",
          "referencias": ["Av. César Canevaro", "Lince"],
          "estaciones_cercanas": []
        },
        {
          "id": "L3-E17",
          "nombre": "Conde de San Isidro",
          "orden": 17,
          "distrito": "San Isidro",
          "estado": "planificada",
          "referencias": ["Av. Arequipa", "Av. Javier Prado", "San Isidro"],
          "estaciones_cercanas": [
            {
              "estacion": "Conde de San Isidro",
              "linea": "L4",
              "distancia_metros": 0,
              "nota": "Transbordo con Línea 4 (planificado)"
            }
          ]
        },
        {
          "id": "L3-E18",
          "nombre": "Andrés Aramburú",
          "orden": 18,
          "distrito": "San Isidro",
          "estado": "planificada",
          "referencias": ["Av. Andrés Aramburú", "San Isidro"],
          "estaciones_cercanas": []
        },
        {
          "id": "L3-E19",
          "nombre": "Huaca Pucllana",
          "orden": 19,
          "distrito": "Miraflores",
          "estado": "planificada",
          "referencias": ["Huaca Pucllana", "Miraflores"],
          "estaciones_cercanas": []
        },
        {
          "id": "L3-E20",
          "nombre": "Parque Central de Miraflores",
          "orden": 20,
          "distrito": "Miraflores",
          "estado": "planificada",
          "referencias": ["Parque Kennedy", "Miraflores", "Av. Larco"],
          "estaciones_cercanas": []
        },
        {
          "id": "L3-E21",
          "nombre": "Parque Reducto",
          "orden": 21,
          "distrito": "Miraflores",
          "estado": "planificada",
          "referencias": ["Parque Reducto", "Av. Benavides", "Miraflores"],
          "estaciones_cercanas": []
        },
        {
          "id": "L3-E22",
          "nombre": "República de Panamá",
          "orden": 22,
          "distrito": "Miraflores",
          "estado": "planificada",
          "referencias": ["Av. República de Panamá", "Surquillo"],
          "estaciones_cercanas": []
        },
        {
          "id": "L3-E23",
          "nombre": "Juana Alarco",
          "orden": 23,
          "distrito": "Santiago de Surco",
          "estado": "planificada",
          "referencias": ["Av. Juana Alarco", "Surco"],
          "estaciones_cercanas": []
        },
        {
          "id": "L3-E24",
          "nombre": "Cabitos",
          "orden": 24,
          "distrito": "Santiago de Surco",
          "estado": "planificada",
          "referencias": ["Cuartel Cabitos", "Av. Santiago de Surco"],
          "estaciones_cercanas": [
            {
              "estacion": "Cabitos",
              "linea": "L1",
              "distancia_metros": 0,
              "nota": "Transbordo con Línea 1 (planificado)"
            }
          ]
        },
        {
          "id": "L3-E25",
          "nombre": "Alejandro Velasco",
          "orden": 25,
          "distrito": "Santiago de Surco",
          "estado": "planificada",
          "referencias": ["Av. Alejandro Velasco Astete", "Surco"],
          "estaciones_cercanas": []
        },
        {
          "id": "L3-E26",
          "nombre": "Las Gardenias",
          "orden": 26,
          "distrito": "Santiago de Surco",
          "estado": "planificada",
          "referencias": ["Av. Las Gardenias", "Surco"],
          "estaciones_cercanas": []
        },
        {
          "id": "L3-E27",
          "nombre": "Los Héroes",
          "orden": 27,
          "distrito": "San Juan de Miraflores",
          "estado": "planificada",
          "referencias": ["Av. Los Héroes", "SJM"],
          "estaciones_cercanas": []
        },
        {
          "id": "L3-E28",
          "nombre": "Pedro Miotta",
          "orden": 28,
          "distrito": "San Juan de Miraflores",
          "estado": "planificada",
          "referencias": ["Av. Pedro Miotta", "SJM"],
          "estaciones_cercanas": []
        }
      ]
    },
    {
      "id": "L4",
      "nombre": "Línea 4",
      "color": "Rojo",
      "tipo": "Subterráneo",
      "operativa": false,
      "inicio": "Gambetta",
      "fin": "Mercado Santa Anita",
      "horario_semana": "Por definir",
      "horario_domingo": "Por definir",
      "tarifa": 0.0,
      "estaciones": [
        {
          "id": "L4-E01",
          "nombre": "Gambetta",
          "orden": 1,
          "distrito": "Callao",
          "estado": "en_construccion",
          "referencias": ["Av. Néstor Gambetta", "Av. Faucett", "Callao"],
          "estaciones_cercanas": []
        },
        {
          "id": "L4-E02",
          "nombre": "Canta Callao",
          "orden": 2,
          "distrito": "Callao",
          "estado": "en_construccion",
          "referencias": ["Av. Canta Callao", "Av. Faucett"],
          "estaciones_cercanas": []
        },
        {
          "id": "L4-E03",
          "nombre": "Bocanegra",
          "orden": 3,
          "distrito": "Callao",
          "estado": "en_construccion",
          "referencias": ["Av. Bocanegra", "Av. Faucett"],
          "estaciones_cercanas": []
        },
        {
          "id": "L4-E04",
          "nombre": "Aeropuerto",
          "orden": 4,
          "distrito": "Callao",
          "estado": "en_construccion",
          "referencias": ["Aeropuerto Internacional Jorge Chávez", "Av. Faucett"],
          "estaciones_cercanas": []
        },
        {
          "id": "L4-E05",
          "nombre": "El Olivar",
          "orden": 5,
          "distrito": "Callao",
          "estado": "en_construccion",
          "referencias": ["Av. El Olivar", "Av. Faucett"],
          "estaciones_cercanas": []
        },
        {
          "id": "L4-E06",
          "nombre": "Quilca",
          "orden": 6,
          "distrito": "Callao",
          "estado": "en_construccion",
          "referencias": ["Av. Quilca", "Av. Faucett"],
          "estaciones_cercanas": []
        },
        {
          "id": "L4-E07",
          "nombre": "Morales Duárez",
          "orden": 7,
          "distrito": "Callao",
          "estado": "en_construccion",
          "referencias": ["Av. Morales Duárez", "Av. Faucett"],
          "estaciones_cercanas": []
        },
        {
          "id": "L4-E08",
          "nombre": "Carmen de la Legua",
          "orden": 8,
          "distrito": "Carmen de la Legua",
          "estado": "en_construccion",
          "referencias": ["Av. Oscar R. Benavides", "Av. Faucett"],
          "estaciones_cercanas": [
            {
              "estacion": "Carmen de la Legua",
              "linea": "L2",
              "distancia_metros": 0,
              "nota": "Transbordo con Línea 2 (en construcción)"
            }
          ]
        },
        {
          "id": "L4-E09",
          "nombre": "Venezuela",
          "orden": 9,
          "distrito": "Lima",
          "estado": "planificada",
          "referencias": ["Av. Venezuela", "Cercado de Lima"],
          "estaciones_cercanas": []
        },
        {
          "id": "L4-E10",
          "nombre": "Rafael Escardó",
          "orden": 10,
          "distrito": "San Miguel",
          "estado": "planificada",
          "referencias": ["Av. Rafael Escardó", "San Miguel"],
          "estaciones_cercanas": []
        },
        {
          "id": "L4-E11",
          "nombre": "Pando",
          "orden": 11,
          "distrito": "San Miguel",
          "estado": "planificada",
          "referencias": ["Av. Pando", "San Miguel", "PUCP"],
          "estaciones_cercanas": []
        },
        {
          "id": "L4-E12",
          "nombre": "José de Sucre",
          "orden": 12,
          "distrito": "Pueblo Libre",
          "estado": "planificada",
          "referencias": ["Av. José de Sucre", "Pueblo Libre"],
          "estaciones_cercanas": []
        },
        {
          "id": "L4-E13",
          "nombre": "Brasil",
          "orden": 13,
          "distrito": "Pueblo Libre",
          "estado": "planificada",
          "referencias": ["Av. Brasil", "Pueblo Libre", "Jesús María"],
          "estaciones_cercanas": []
        },
        {
          "id": "L4-E14",
          "nombre": "Felipe Salaverry",
          "orden": 14,
          "distrito": "Jesús María",
          "estado": "planificada",
          "referencias": ["Av. Felipe Salaverry", "Jesús María"],
          "estaciones_cercanas": []
        },
        {
          "id": "L4-E15",
          "nombre": "Guillermo Prescott",
          "orden": 15,
          "distrito": "San Isidro",
          "estado": "planificada",
          "referencias": ["Av. Guillermo Prescott", "San Isidro"],
          "estaciones_cercanas": []
        },
        {
          "id": "L4-E16",
          "nombre": "Las Palmeras",
          "orden": 16,
          "distrito": "San Isidro",
          "estado": "planificada",
          "referencias": ["Av. Las Palmeras", "San Isidro"],
          "estaciones_cercanas": []
        },
        {
          "id": "L4-E17",
          "nombre": "Conde de San Isidro",
          "orden": 17,
          "distrito": "San Isidro",
          "estado": "planificada",
          "referencias": ["Av. Arequipa", "Av. Javier Prado", "San Isidro"],
          "estaciones_cercanas": [
            {
              "estacion": "Conde de San Isidro",
              "linea": "L3",
              "distancia_metros": 0,
              "nota": "Transbordo con Línea 3 (planificado)"
            }
          ]
        },
        {
          "id": "L4-E18",
          "nombre": "Rivera Navarrete",
          "orden": 18,
          "distrito": "San Isidro",
          "estado": "planificada",
          "referencias": ["Av. Rivera Navarrete", "San Isidro", "Centro Empresarial"],
          "estaciones_cercanas": []
        },
        {
          "id": "L4-E19",
          "nombre": "Pablo Carriquirry",
          "orden": 19,
          "distrito": "San Isidro",
          "estado": "planificada",
          "referencias": ["Av. Pablo Carriquirry", "San Isidro"],
          "estaciones_cercanas": []
        },
        {
          "id": "L4-E20",
          "nombre": "La Cultura",
          "orden": 20,
          "distrito": "San Borja",
          "estado": "planificada",
          "referencias": ["Museo de la Nación", "Av. Javier Prado Este", "San Borja"],
          "estaciones_cercanas": []
        },
        {
          "id": "L4-E21",
          "nombre": "San Luis",
          "orden": 21,
          "distrito": "San Luis",
          "estado": "planificada",
          "referencias": ["Av. San Luis", "San Luis"],
          "estaciones_cercanas": []
        },
        {
          "id": "L4-E22",
          "nombre": "Monterrico",
          "orden": 22,
          "distrito": "Santiago de Surco",
          "estado": "planificada",
          "referencias": ["Monterrico", "Jockey Plaza", "Surco"],
          "estaciones_cercanas": []
        },
        {
          "id": "L4-E23",
          "nombre": "Manuel Olguín",
          "orden": 23,
          "distrito": "Santiago de Surco",
          "estado": "planificada",
          "referencias": ["Av. Manuel Olguín", "Surco"],
          "estaciones_cercanas": []
        },
        {
          "id": "L4-E24",
          "nombre": "Los Frutales",
          "orden": 24,
          "distrito": "Ate",
          "estado": "planificada",
          "referencias": ["Av. Los Frutales", "Ate"],
          "estaciones_cercanas": []
        },
        {
          "id": "L4-E25",
          "nombre": "La Molina",
          "orden": 25,
          "distrito": "La Molina",
          "estado": "planificada",
          "referencias": ["Av. La Molina", "La Molina", "Universidad La Molina"],
          "estaciones_cercanas": []
        },
        {
          "id": "L4-E26",
          "nombre": "Santa Patricia",
          "orden": 26,
          "distrito": "La Molina",
          "estado": "planificada",
          "referencias": ["Urb. Santa Patricia", "La Molina"],
          "estaciones_cercanas": []
        },
        {
          "id": "L4-E27",
          "nombre": "Mayorazgo",
          "orden": 27,
          "distrito": "Ate",
          "estado": "planificada",
          "referencias": ["Av. Mayorazgo", "Ate"],
          "estaciones_cercanas": []
        },
        {
          "id": "L4-E28",
          "nombre": "Mercado Santa Anita",
          "orden": 28,
          "distrito": "Santa Anita",
          "estado": "planificada",
          "referencias": ["Mercado Santa Anita", "Santa Anita"],
          "estaciones_cercanas": []
        }
      ]
    },
    {
      "id": "MET",
      "nombre": "Metropolitano",
      "color": "Naranja",
      "tipo": "BRT (Bus Rapid Transit)",
      "operativa": true,
      "inicio": "Terminal Naranjal",
      "fin": "Terminal Matellini",
      "horario_semana": "05:00 - 23:00",
      "horario_domingo": "05:00 - 22:00",
      "tarifa": 2.70,
      "estaciones": [
        {
          "id": "MET-E01",
          "nombre": "Terminal Naranjal",
          "orden": 1,
          "distrito": "Independencia",
          "estado": "operativa",
          "referencias": ["Av. Túpac Amaru", "Independencia", "Comas"],
          "estaciones_cercanas": [
            {
              "estacion": "Naranjal",
              "linea": "L3",
              "distancia_metros": 100,
              "nota": "Conexión futura con Línea 3"
            }
          ]
        },
        {
          "id": "MET-E02",
          "nombre": "Izaguirre",
          "orden": 2,
          "distrito": "Los Olivos",
          "estado": "operativa",
          "referencias": ["Av. Carlos Izaguirre", "Los Olivos"],
          "estaciones_cercanas": []
        },
        {
          "id": "MET-E03",
          "nombre": "Chimpu Ocllo",
          "orden": 3,
          "distrito": "Los Olivos",
          "estado": "operativa",
          "referencias": ["Av. Chimpu Ocllo", "Los Olivos"],
          "estaciones_cercanas": []
        },
        {
          "id": "MET-E04",
          "nombre": "Los Jazmines",
          "orden": 4,
          "distrito": "Los Olivos",
          "estado": "operativa",
          "referencias": ["Av. Los Jazmines", "Los Olivos"],
          "estaciones_cercanas": []
        },
        {
          "id": "MET-E05",
          "nombre": "Tomás Valle",
          "orden": 5,
          "distrito": "Los Olivos",
          "estado": "operativa",
          "referencias": ["Av. Tomás Valle", "Los Olivos"],
          "estaciones_cercanas": []
        },
        {
          "id": "MET-E06",
          "nombre": "Universitaria",
          "orden": 6,
          "distrito": "San Martín de Porres",
          "estado": "operativa",
          "referencias": ["Av. Universitaria", "SMP"],
          "estaciones_cercanas": []
        },
        {
          "id": "MET-E07",
          "nombre": "Honorio Delgado",
          "orden": 7,
          "distrito": "San Martín de Porres",
          "estado": "operativa",
          "referencias": ["Hospital Honorio Delgado", "SMP"],
          "estaciones_cercanas": []
        },
        {
          "id": "MET-E08",
          "nombre": "Caquetá",
          "orden": 8,
          "distrito": "Rímac",
          "estado": "operativa",
          "referencias": ["Av. Caquetá", "Mercado de Caquetá", "Rímac"],
          "estaciones_cercanas": []
        },
        {
          "id": "MET-E09",
          "nombre": "Plaza de Armas",
          "orden": 9,
          "distrito": "Lima",
          "estado": "operativa",
          "referencias": ["Plaza de Armas", "Palacio de Gobierno", "Centro Histórico"],
          "estaciones_cercanas": []
        },
        {
          "id": "MET-E10",
          "nombre": "Estación Central",
          "orden": 10,
          "distrito": "Lima",
          "estado": "operativa",
          "referencias": ["Paseo Colón", "Av. España", "Centro de Lima"],
          "estaciones_cercanas": [
            {
              "estacion": "Estación Central",
              "linea": "L2",
              "distancia_metros": 200,
              "nota": "Conexión futura con Línea 2"
            },
            {
              "estacion": "Estación Central",
              "linea": "L3",
              "distancia_metros": 200,
              "nota": "Conexión futura con Línea 3"
            }
          ]
        },
        {
          "id": "MET-E11",
          "nombre": "Colmena",
          "orden": 11,
          "distrito": "Lima",
          "estado": "operativa",
          "referencias": ["Av. La Colmena", "Centro de Lima"],
          "estaciones_cercanas": []
        },
        {
          "id": "MET-E12",
          "nombre": "Quilca",
          "orden": 12,
          "distrito": "Lima",
          "estado": "operativa",
          "referencias": ["Jr. Quilca", "Centro de Lima"],
          "estaciones_cercanas": []
        },
        {
          "id": "MET-E13",
          "nombre": "Canadá",
          "orden": 13,
          "distrito": "Lima",
          "estado": "operativa",
          "referencias": ["Av. Canadá", "La Victoria"],
          "estaciones_cercanas": []
        },
        {
          "id": "MET-E14",
          "nombre": "Javier Prado",
          "orden": 14,
          "distrito": "San Isidro",
          "estado": "operativa",
          "referencias": ["Av. Javier Prado Oeste", "San Isidro"],
          "estaciones_cercanas": []
        },
        {
          "id": "MET-E15",
          "nombre": "Aramburú",
          "orden": 15,
          "distrito": "San Isidro",
          "estado": "operativa",
          "referencias": ["Av. Andrés Aramburú", "San Isidro"],
          "estaciones_cercanas": []
        },
        {
          "id": "MET-E16",
          "nombre": "Cortijo",
          "orden": 16,
          "distrito": "San Isidro",
          "estado": "operativa",
          "referencias": ["Av. Cortijo", "San Isidro"],
          "estaciones_cercanas": []
        },
        {
          "id": "MET-E17",
          "nombre": "Domingo Orué",
          "orden": 17,
          "distrito": "Surquillo",
          "estado": "operativa",
          "referencias": ["Av. Domingo Orué", "Surquillo"],
          "estaciones_cercanas": []
        },
        {
          "id": "MET-E18",
          "nombre": "Angamos",
          "orden": 18,
          "distrito": "Miraflores",
          "estado": "operativa",
          "referencias": ["Av. Angamos", "Miraflores", "Surquillo"],
          "estaciones_cercanas": []
        },
        {
          "id": "MET-E19",
          "nombre": "Ricardo Palma",
          "orden": 19,
          "distrito": "Miraflores",
          "estado": "operativa",
          "referencias": ["Av. Ricardo Palma", "Miraflores", "Parque Kennedy"],
          "estaciones_cercanas": []
        },
        {
          "id": "MET-E20",
          "nombre": "Benavides",
          "orden": 20,
          "distrito": "Miraflores",
          "estado": "operativa",
          "referencias": ["Av. Benavides", "Miraflores"],
          "estaciones_cercanas": []
        },
        {
          "id": "MET-E21",
          "nombre": "Balta",
          "orden": 21,
          "distrito": "Miraflores",
          "estado": "operativa",
          "referencias": ["Av. José Balta", "Miraflores"],
          "estaciones_cercanas": []
        },
        {
          "id": "MET-E22",
          "nombre": "República de Panamá",
          "orden": 22,
          "distrito": "Surquillo",
          "estado": "operativa",
          "referencias": ["Av. República de Panamá", "Surquillo"],
          "estaciones_cercanas": []
        },
        {
          "id": "MET-E23",
          "nombre": "Tomás Marsano",
          "orden": 23,
          "distrito": "Santiago de Surco",
          "estado": "operativa",
          "referencias": ["Av. Tomás Marsano", "Surco"],
          "estaciones_cercanas": []
        },
        {
          "id": "MET-E24",
          "nombre": "Higuereta",
          "orden": 24,
          "distrito": "Santiago de Surco",
          "estado": "operativa",
          "referencias": ["Av. Higuereta", "Surco"],
          "estaciones_cercanas": []
        },
        {
          "id": "MET-E25",
          "nombre": "Jorge Chávez",
          "orden": 25,
          "distrito": "Santiago de Surco",
          "estado": "operativa",
          "referencias": ["Av. Jorge Chávez", "Surco"],
          "estaciones_cercanas": []
        },
        {
          "id": "MET-E26",
          "nombre": "Góticos",
          "orden": 26,
          "distrito": "Santiago de Surco",
          "estado": "operativa",
          "referencias": ["Av. Góticos", "Surco"],
          "estaciones_cercanas": []
        },
        {
          "id": "MET-E27",
          "nombre": "Ayacucho",
          "orden": 27,
          "distrito": "Santiago de Surco",
          "estado": "operativa",
          "referencias": ["Av. Ayacucho", "Surco"],
          "estaciones_cercanas": []
        },
        {
          "id": "MET-E28",
          "nombre": "Primavera",
          "orden": 28,
          "distrito": "Santiago de Surco",
          "estado": "operativa",
          "referencias": ["Av. Primavera", "Surco"],
          "estaciones_cercanas": []
        },
        {
          "id": "MET-E29",
          "nombre": "Croniquillas",
          "orden": 29,
          "distrito": "Santiago de Surco",
          "estado": "operativa",
          "referencias": ["Av. Croniquillas", "Surco"],
          "estaciones_cercanas": []
        },
        {
          "id": "MET-E30",
          "nombre": "La Ronda",
          "orden": 30,
          "distrito": "Santiago de Surco",
          "estado": "operativa",
          "referencias": ["Av. La Ronda", "Surco"],
          "estaciones_cercanas": []
        },
        {
          "id": "MET-E31",
          "nombre": "El Derby",
          "orden": 31,
          "distrito": "Santiago de Surco",
          "estado": "operativa",
          "referencias": ["Av. El Derby", "Surco"],
          "estaciones_cercanas": []
        },
        {
          "id": "MET-E32",
          "nombre": "Monterrico",
          "orden": 32,
          "distrito": "Santiago de Surco",
          "estado": "operativa",
          "referencias": ["Monterrico", "Jockey Plaza", "Surco"],
          "estaciones_cercanas": []
        },
        {
          "id": "MET-E33",
          "nombre": "Villasol",
          "orden": 33,
          "distrito": "Santiago de Surco",
          "estado": "operativa",
          "referencias": ["Av. Villasol", "Surco"],
          "estaciones_cercanas": []
        },
        {
          "id": "MET-E34",
          "nombre": "Alipio Ponce",
          "orden": 34,
          "distrito": "Santiago de Surco",
          "estado": "operativa",
          "referencias": ["Av. Alipio Ponce", "Surco"],
          "estaciones_cercanas": []
        },
        {
          "id": "MET-E35",
          "nombre": "Andrés Tinoco",
          "orden": 35,
          "distrito": "Santiago de Surco",
          "estado": "operativa",
          "referencias": ["Av. Andrés Tinoco", "Surco"],
          "estaciones_cercanas": []
        },
        {
          "id": "MET-E36",
          "nombre": "Benavides 2",
          "orden": 36,
          "distrito": "Chorrillos",
          "estado": "operativa",
          "referencias": ["Av. Benavides", "Chorrillos"],
          "estaciones_cercanas": []
        },
        {
          "id": "MET-E37",
          "nombre": "Bulevar",
          "orden": 37,
          "distrito": "Chorrillos",
          "estado": "operativa",
          "referencias": ["Av. Bulevar", "Chorrillos"],
          "estaciones_cercanas": []
        },
        {
          "id": "MET-E38",
          "nombre": "Los Héroes",
          "orden": 38,
          "distrito": "San Juan de Miraflores",
          "estado": "operativa",
          "referencias": ["Av. Los Héroes", "SJM"],
          "estaciones_cercanas": []
        },
        {
          "id": "MET-E39",
          "nombre": "Atocongo",
          "orden": 39,
          "distrito": "San Juan de Miraflores",
          "estado": "operativa",
          "referencias": ["Av. Atocongo", "SJM"],
          "estaciones_cercanas": []
        },
        {
          "id": "MET-E40",
          "nombre": "San Juan",
          "orden": 40,
          "distrito": "San Juan de Miraflores",
          "estado": "operativa",
          "referencias": ["Av. San Juan", "SJM"],
          "estaciones_cercanas": []
        },
        {
          "id": "MET-E41",
          "nombre": "Pumacahua",
          "orden": 41,
          "distrito": "Chorrillos",
          "estado": "operativa",
          "referencias": ["Av. Pumacahua", "Chorrillos"],
          "estaciones_cercanas": []
        },
        {
          "id": "MET-E42",
          "nombre": "Plaza Flores",
          "orden": 42,
          "distrito": "Barranco",
          "estado": "operativa",
          "referencias": ["Barranco", "Av. Grau"],
          "estaciones_cercanas": []
        },
        {
          "id": "MET-E43",
          "nombre": "Escuela Militar",
          "orden": 43,
          "distrito": "Chorrillos",
          "estado": "operativa",
          "referencias": ["Escuela Militar de Chorrillos", "Chorrillos"],
          "estaciones_cercanas": []
        },
        {
          "id": "MET-E44",
          "nombre": "Terminal Matellini",
          "orden": 44,
          "distrito": "Chorrillos",
          "estado": "operativa",
          "referencias": ["Av. Matellini", "Chorrillos"],
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

// ─── MOSTRAR ESTACIÓN ────────────────────────────────────────
func mostrarEstacion(_ estacion: [String: Any], linea: String = "") {
    let nombre    = estacion["nombre"]   as? String ?? ""
    let distrito  = estacion["distrito"] as? String ?? ""
    let estado    = estacion["estado"]   as? String ?? ""
    let orden     = estacion["orden"]    as? Int    ?? 0
    let refs      = estacion["referencias"] as? [String] ?? []
    let cercanas  = estacion["estaciones_cercanas"] as? [[String: Any]] ?? []

    var estadoIcon = ""
    switch estado {
    case "operativa":       estadoIcon = "✅ Operativa"
    case "en_construccion": estadoIcon = "⚠️  En construcción"
    case "planificada":     estadoIcon = "📋 Planificada"
    default:                estadoIcon = estado
    }

    print("\n  Estación #\(orden): \(nombre)")
    if !linea.isEmpty { print("  Línea:    \(linea)") }
    print("  Distrito: \(distrito)")
    print("  Estado:   \(estadoIcon)")
    if !refs.isEmpty {
        print("  Cerca de: \(refs.joined(separator: ", "))")
    }
    if !cercanas.isEmpty {
        for c in cercanas {
            let cNombre = c["estacion"] as? String ?? ""
            let cLinea  = c["linea"]    as? String ?? ""
            let cDist   = c["distancia_metros"] as? Int ?? 0
            let cNota   = c["nota"]     as? String ?? ""
            print("  Conexión: \(cNombre) (\(cLinea)) — \(cDist)m — \(cNota)")
        }
    }
}

// ─── MOSTRAR LÍNEA ───────────────────────────────────────────
func mostrarInfoLinea(_ linea: [String: Any]) {
    let nombre    = linea["nombre"]          as? String ?? ""
    let color     = linea["color"]           as? String ?? ""
    let tipo      = linea["tipo"]            as? String ?? ""
    let inicio    = linea["inicio"]          as? String ?? ""
    let fin       = linea["fin"]             as? String ?? ""
    let horarioS  = linea["horario_semana"]  as? String ?? ""
    let horarioD  = linea["horario_domingo"] as? String ?? ""
    let tarifa    = linea["tarifa"]          as? Double ?? 0.0
    let estaciones = linea["estaciones"]     as? [[String: Any]] ?? []
    let operativas = estaciones.filter { $0["estado"] as? String == "operativa" }.count

    print("\n══════════════════════════════════════════")
    print("  \(nombre) — \(color)")
    print("══════════════════════════════════════════")
    print("  Tipo:       \(tipo)")
    print("  Recorrido:  \(inicio) → \(fin)")
    print("  Horario:    L-S \(horarioS) | Dom \(horarioD)")
    print("  Tarifa:     S/. \(tarifa)")
    print("  Estaciones: \(estaciones.count) total — \(operativas) operativas")
    print("══════════════════════════════════════════")
}

// ─── SUBMENÚ LÍNEAS ──────────────────────────────────────────
func submenuLineas() {
    print("\n¿De qué línea deseas ver las estaciones?")
    for (i, linea) in lineas.enumerated() {
        let nombre = linea["nombre"] as? String ?? ""
        let color  = linea["color"]  as? String ?? ""
        print("  \(i + 1). \(nombre) (\(color))")
    }
    print("  0. Volver")
    print("\nOpción: ", terminator: "")

    let input = readLine() ?? ""
    guard let opcion = Int(input) else {
        print("⚠️  Opción inválida.")
        return
    }
    if opcion == 0 { return }
    guard opcion >= 1 && opcion <= lineas.count else {
        print("⚠️  Opción fuera de rango.")
        return
    }

    let linea = lineas[opcion - 1]
    _ = linea["nombre"] as? String ?? ""
    let estaciones  = linea["estaciones"] as? [[String: Any]] ?? []

    mostrarInfoLinea(linea)
    print("\n  Estaciones:")
    for estacion in estaciones {
        let nombre = estacion["nombre"] as? String ?? ""
        let estado = estacion["estado"] as? String ?? ""
        let orden  = estacion["orden"]  as? Int    ?? 0
        var icon   = ""
        switch estado {
        case "operativa":       icon = "✅"
        case "en_construccion": icon = "⚠️ "
        case "planificada":     icon = "📋"
        default:                icon = "  "
        }
        print("  \(icon) \(orden). \(nombre)")
    }
}

// ─── OPCIÓN BUSCAR ESTACIÓN ──────────────────────────────────
func opcionBuscarEstacion() {
    print("\nIngresa el nombre o lugar a buscar: ", terminator: "")
    let termino = readLine() ?? ""
    guard !termino.isEmpty else {
        print("⚠️  No ingresaste nada.")
        return
    }
    let resultados = buscarEstacion(termino)
    if resultados.isEmpty {
        print("❌ No encontré estaciones para: \"\(termino)\"")
        return
    }
    print("\n🔍 Resultados para \"\(termino)\": \(resultados.count) encontrada(s)")
    for estacion in resultados {
        let idEst = estacion["id"] as? String ?? ""
        let lineaId = idEst.components(separatedBy: "-")[0]
        let nombreLinea = lineas.first {
            $0["id"] as? String == lineaId
        }.flatMap { $0["nombre"] as? String } ?? ""
        mostrarEstacion(estacion, linea: nombreLinea)
    }
}

// ─── OPCIÓN INFO LÍNEA ───────────────────────────────────────
func opcionInfoLinea() {
    print("\n¿De qué línea deseas información?")
    for (i, linea) in lineas.enumerated() {
        let nombre = linea["nombre"] as? String ?? ""
        print("  \(i + 1). \(nombre)")
    }
    print("  0. Volver")
    print("\nOpción: ", terminator: "")

    let input = readLine() ?? ""
    guard let opcion = Int(input), opcion >= 1, opcion <= lineas.count else {
        if input == "0" { return }
        print("⚠️  Opción inválida.")
        return
    }
    mostrarInfoLinea(lineas[opcion - 1])
}

// ─── OPCIÓN CÓMO LLEGAR ──────────────────────────────────────
func opcionComoLlegar() {
    print("\nEstación de origen: ", terminator: "")
    let origen = readLine() ?? ""
    guard !origen.isEmpty else {
        print("⚠️  No ingresaste el origen.")
        return
    }
    print("Estación de destino: ", terminator: "")
    let destino = readLine() ?? ""
    guard !destino.isEmpty else {
        print("⚠️  No ingresaste el destino.")
        return
    }
    buscarRuta(origen: origen, destino: destino)
}

// ─── HISTORIAL DE CONVERSACIÓN ───────────────────────────────
var historial: [[String: String]] = []

// ─── MANEJO DE SIGINT (Ctrl+C) ───────────────────────────────
func configurarSIGINT() {
    signal(SIGINT) { _ in
        print("\n\n¿Seguro que deseas salir? (s/n): ", terminator: "")
        let respuesta = readLine() ?? ""
        if respuesta.lowercased() == "s" {
            print("\n👋 ¡Hasta luego! Gracias por usar Metro de Lima.")
            exit(0)
        } else {
            print("\n↩️  Regresando al menú...")
        }
    }
}
// ─── LLAMADA A GEMINI API ────────────────────────────────────
func preguntarIA(_ pregunta: String) {
    // Agregar pregunta al historial
    historial.append(["role": "user", "content": pregunta])

    guard let apiKey = ProcessInfo.processInfo.environment["GEMINI_API_KEY"],
          !apiKey.isEmpty else {
        print("❌ No se encontró la API Key. Configura GEMINI_API_KEY.")
        return
    }

    // Construir el system prompt con contexto del JSON
    let systemPrompt = """
    Eres un asistente experto en el Metro de Lima y Callao.
    Responde preguntas sobre líneas, estaciones, rutas y lugares cercanos.
    Basa tus respuestas ÚNICAMENTE en estos datos reales del sistema:

    \(jsonString)

    Reglas:
    - Sé conciso y directo.
    - Si una estación no está operativa, indícalo claramente.
    - Si no tienes información suficiente, dilo honestamente.
    - Responde siempre en español.
    - No inventes estaciones ni datos que no estén en el JSON.
    """

    // Construir el historial en formato Gemini
    var contents: [[String: Any]] = []

    // System prompt como primer mensaje del usuario
    contents.append([
        "role": "user",
        "parts": [["text": systemPrompt]]
    ])
    contents.append([
        "role": "model",
        "parts": [["text": "Entendido. Soy tu asistente experto en el Metro de Lima. ¿En qué puedo ayudarte?"]]
    ])

    // Agregar historial de conversación
    for mensaje in historial {
        let role = mensaje["role"] == "user" ? "user" : "model"
        let content = mensaje["content"] ?? ""
        contents.append([
            "role": role,
            "parts": [["text": content]]
        ])
    }

    let body: [String: Any] = [
        "contents": contents,
        "generationConfig": [
            "maxOutputTokens": 1024,
            "temperature": 0.3
        ]
    ]

    let urlString = "https://generativelanguage.googleapis.com/v1beta/models/gemini-3.6-flash:generateContent?key=\(apiKey)"

    guard let url = URL(string: urlString) else {
        print("❌ URL inválida.")
        return
    }

    guard let bodyData = try? JSONSerialization.data(withJSONObject: body) else {
        print("❌ Error al construir el request.")
        return
    }

    // Configurar el request
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = bodyData

    print("\n🤖 Consultando a la IA...\n")

    // Semáforo para esperar respuesta sincrónica
    let semaphore = DispatchSemaphore(value: 0)
    var respuestaFinal = ""

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        defer { semaphore.signal() }

        if let error = error {
            print("❌ Error de conexión: \(error.localizedDescription)")
            return
        }

        guard let data = data else {
            print("❌ No se recibió respuesta.")
            return
        }

        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            print("❌ Respuesta inválida de la API.")
            return
        }

        // Verificar error de la API
        if let error = json["error"] as? [String: Any],
           let mensaje = error["message"] as? String {
            print("❌ Error de API: \(mensaje)")
            return
        }

        // Extraer la respuesta de Gemini
        guard let candidates = json["candidates"] as? [[String: Any]],
              let primero = candidates.first,
              let content = primero["content"] as? [String: Any],
              let parts = content["parts"] as? [[String: Any]],
              let primerPart = parts.first,
              let texto = primerPart["text"] as? String else {
            print("❌ No se pudo extraer la respuesta.")
            return
        }

        respuestaFinal = texto
    }

    task.resume()
    semaphore.wait()

    if !respuestaFinal.isEmpty {
        historial.append(["role": "assistant", "content": respuestaFinal])
        print("🤖 \(respuestaFinal)")
    }
}
// ─── OPCIÓN PREGUNTA LIBRE ───────────────────────────────────
func opcionPreguntaLibre() {
    print("\nEscribe tu pregunta (o 'volver' para regresar al menú):")
    print("→ ", terminator: "")
    let pregunta = readLine() ?? ""

    guard !pregunta.isEmpty else {
        print("⚠️  No ingresaste nada.")
        return
    }
    guard normalizar(pregunta) != "volver" else {
        return
    }

    preguntarIA(pregunta)
}

// ─── MENÚ PRINCIPAL ──────────────────────────────────────────
func mostrarMenu() {
    print("\n══════════════════════════════════════════")
    print("       METRO DE LIMA — CONSULTAS          ")
    print("══════════════════════════════════════════")
    print("  1. Pregunta libre (IA)")
    print("  2. Ver estaciones por línea")
    print("  3. Buscar estación o lugar")
    print("  4. Información de una línea")
    print("  5. ¿Cómo llegar a...?")
    print("  0. Salir")
    print("══════════════════════════════════════════")
    print("Opción: ", terminator: "")
}

// ─── LOOP PRINCIPAL ──────────────────────────────────────────
func iniciar() {
    configurarSIGINT()
    cargarDatos()
    print("\nBienvenido al Metro de Lima 🚇")

    var continuar = true
    while continuar {
        mostrarMenu()
        let input = readLine() ?? ""

        switch input {
        case "1":
            opcionPreguntaLibre()
        case "2":
            submenuLineas()
        case "3":
            opcionBuscarEstacion()
        case "4":
            opcionInfoLinea()
        case "5":
            opcionComoLlegar()
        case "0":
            continuar = false
            print("\n👋 ¡Hasta luego! Gracias por usar Metro de Lima.")
        default:
            print("⚠️  Opción no válida. Elige entre 0 y 5.")
        }
    }
}

iniciar()
