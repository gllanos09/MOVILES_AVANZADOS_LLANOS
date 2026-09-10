# 🚇 Metro de Lima — Terminal App

Aplicación de consulta del Metro de Lima y Callao para terminal, desarrollada en Swift. Permite consultar información sobre líneas, estaciones, rutas y lugares cercanos mediante un menú interactivo y preguntas en lenguaje natural con IA.

---

## 🛠 Tecnologías

- Swift 5.7+
- Foundation
- Gemini API (generativelanguage.googleapis.com)
- macOS 12 Monterey o superior

---

## ⚙️ Configuración

Antes de ejecutar el programa, configura tu API Key de Gemini como variable de entorno:

```bash
export GEMINI_API_KEY="AIza..."
```

---

## ▶️ Cómo ejecutar

```bash
cd MetroLima
swift MetroLima.swift
```

---

## 📋 Requerimientos Funcionales

**RF-01 — Navegación por menú numérico**  
El sistema presenta un menú principal con opciones numeradas. Entradas inválidas muestran un mensaje claro sin interrumpir la ejecución.

**RF-02 — Consulta de estaciones por línea**  
Lista todas las estaciones de una línea seleccionada con nombre, orden, distrito y estado operativo (✅ operativa / ⚠️ en construcción / 📋 planificada).

**RF-03 — Búsqueda con normalización de texto**  
Permite buscar estaciones aceptando variaciones en mayúsculas, minúsculas y tildes. "Aviacion", "aviación" y "AVIACIÓN" producen el mismo resultado.

**RF-04 — Consulta de rutas entre estaciones**  
Indica cómo llegar de una estación a otra. Si están en la misma línea muestra estaciones intermedias. Si están en líneas distintas busca conexiones cercanas en el JSON.

**RF-05 — Preguntas en lenguaje natural mediante IA**  
Permite escribir preguntas libres en español. Usa la API de Gemini con el JSON completo como contexto para responder basándose en datos reales.

**RF-06 — Historial de conversación por sesión**  
Mantiene en memoria el historial de mensajes de la sesión para que la IA responda preguntas de seguimiento con contexto previo.

**RF-07 — Información detallada por estación**  
Muestra nombre, línea, distrito, estado operativo, lugares de referencia cercanos y conexiones con otras líneas cuando existen.

**RF-08 — Cierre controlado del programa**  
Opción 0 cierra con despedida. Ctrl+C solicita confirmación antes de cerrar.

---

## 🗂 Estructura del proyecto

```
MetroLima/
├── MetroLima.swift    ← Código fuente completo
└── README.md          ← Este archivo
```

---

## 📦 Commits

| # | Commit |
|---|---|
| 1 | chore: inicializar archivo principal y estructura del proyecto |
| 2 | feat: agregar JSON completo de líneas y estaciones hardcodeado |
| 3 | feat: implementar parseo de JSON y normalización de texto |
| 4 | feat: implementar búsqueda local de estaciones y rutas |
| 5 | feat: agregar menú interactivo con todas las opciones |
| 6 | feat: integrar Gemini API con historial de sesión |
| 7 | fix: agregar SIGINT, despedida y validaciones finales |
| 8 | docs: agregar README con descripción y requerimientos funcionales |

---

## 🗺 Cobertura de datos

| Línea | Estaciones totales | Operativas |
|---|---|---|
| Línea 1 (Verde) | 26 | 26 |
| Línea 2 (Amarillo) | 27 | 5 |

---

## ✅ Validaciones implementadas

| Situación | Comportamiento |
|---|---|
| Entrada vacía en menú | Mensaje de advertencia, no interrumpe el loop |
| Número fuera de rango | "Opción no válida. Elige entre 0 y 5." |
| Estación no encontrada | "No encontré estaciones para: X" |
| Estación en construcción | Muestra info con indicador ⚠️ |
| API Key no configurada | Mensaje de error claro, resto funciona normal |
| Sin conexión a internet | Error de conexión informado al usuario |
| Ruta sin conexión entre líneas | Busca estaciones_cercanas en JSON |
| Ctrl+C | Solicita confirmación antes de cerrar |

---

## 👤 Autor

Gabriel Llanos — EL CLAN EAFC S.A. / TECSUP Lima
