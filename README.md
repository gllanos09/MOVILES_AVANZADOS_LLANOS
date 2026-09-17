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
swift MetroLimaApp.swift
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
Indica cómo llegar de una estación a otra. Si están en la misma línea muestra estaciones intermedias. Si están en líneas distintas busca el punto de transbordo en el JSON y arma la ruta en dos tramos con conteo de estaciones y tiempo estimado.

**RF-05 — Preguntas en lenguaje natural mediante IA**  
Permite escribir preguntas libres en español. Usa la API de Gemini con el JSON completo como contexto para responder basándose en datos reales y conocimiento general de Lima.

**RF-06 — Historial de conversación por sesión**  
Mantiene en memoria el historial de mensajes de la sesión para que la IA responda preguntas de seguimiento con contexto previo.

**RF-07 — Información detallada por estación**  
Muestra nombre, línea, distrito, estado operativo, lugares de referencia cercanos y conexiones con otras líneas cuando existen.

**RF-08 — Cierre controlado del programa**  
Opción 0 cierra con despedida. Ctrl+C solicita confirmación antes de cerrar.

**RF-09 — Planificación de viaje con transbordo**  
Calcula rutas completas entre líneas distintas identificando el punto de transbordo más cercano. Muestra estaciones por tramo, tiempo estimado y advertencias si alguna estación no está operativa. Si no hay conexión directa, delega a la IA.

**RF-10 — Gestión de tarjeta de transporte**  
Simula una tarjeta Lima Pass con saldo, recarga y cobro automático por viaje según la tarifa de la línea. Incluye historial de movimientos de la sesión. Solo cobra si la estación de origen es operativa y la ruta existe.

**RF-11 — Modo administrador**  
Acceso protegido por contraseña con bloqueo tras 3 intentos fallidos. Permite insertar estaciones en cualquier posición de una línea existente (antes o después de un paradero) con reordenamiento automático, y crear nuevas líneas con todos sus metadatos. Incluye validaciones completas en cada campo.

---

## 🗂 Estructura del proyecto

```
MetroLima/
├── MetroLimaApp.swift    ← Código fuente completo
└── README.md             ← Este archivo
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
| 9 | feat: mejorar system prompt para respuestas en texto plano y conocimiento general de Lima |
| 10 | feat: agregar Línea 3, Línea 4 y Metropolitano al JSON |
| 11 | feat: implementar planificación de viaje con transbordo entre líneas y reintentos de IA |
| 12 | feat: agregar gestión de tarjeta de transporte con saldo, recarga e historial |
| 13 | feat: agregar modo administrador con inserción de estaciones y creación de líneas |
| 14 | fix: agregar validaciones completas en insertar estación y crear línea |
| 15 | docs: actualizar README con commit 15 y validaciones del modo admin |

---

## 🗺 Cobertura de datos

| Línea | Estaciones totales | Operativas | Estado |
|---|---|---|---|
| Línea 1 (Verde) | 26 | 26 | Operativa |
| Línea 2 (Amarillo) | 27 | 5 | Parcial — en construcción |
| Línea 3 (Celeste) | 28 | 0 | Planificada (2035) |
| Línea 4 (Rojo) | 28 | 0 | En construcción / Planificada |
| Metropolitano (Naranja) | 44 | 44 | Operativo |

---

## 🧭 Menú principal

| Opción | Acción |
|---|---|
| 1 | Pregunta libre (IA) |
| 2 | Ver estaciones por línea |
| 3 | Buscar estación o lugar |
| 4 | Información de una línea |
| 5 | ¿Cómo llegar a...? |
| 6 | Gestionar tarjeta de transporte |
| 7 | Modo administrador |
| 0 | Salir |

---

## ✅ Validaciones implementadas

| Situación | Comportamiento |
|---|---|
| Entrada vacía en menú | Mensaje de advertencia, no interrumpe el loop |
| Número fuera de rango | "Opción no válida. Elige entre 0 y 7." |
| Estación no encontrada | "No encontré estaciones para: X" |
| Estación en construcción o planificada | Muestra info con indicador ⚠️ o 📋 y aviso explícito |
| Ruta con estaciones no operativas | Avisa estaciones afectadas y muestra ruta como referencia futura |
| API Key no configurada | Mensaje de error claro, resto del programa funciona normal |
| IA con alta demanda | Reintenta automáticamente hasta 3 veces antes de mostrar aviso |
| Sin conexión a internet | Error de conexión informado al usuario |
| Ruta sin conexión entre líneas | Busca transbordo en JSON; si no hay, delega a la IA |
| Saldo insuficiente en tarjeta | Informa tarifa requerida y saldo actual sin registrar el viaje |
| Ruta inexistente al cobrar viaje | No ofrece cobro si la ruta falló |
| Contraseña admin incorrecta 3 veces | Bloqueo y regreso al menú principal |
| Ctrl+C | Solicita confirmación antes de cerrar |
| Admin — estado inválido al insertar | Solicita corrección hasta 3 veces, luego asigna "planificada" |
| Admin — nombre duplicado en línea | Rechaza la inserción e informa el conflicto |
| Admin — distrito vacío | Rechaza la inserción y solicita el dato |
| Admin — posición inválida (no 1 ni 2) | Avisa y cancela la operación |
| Admin — ID de línea con espacios | Rechaza la creación e informa el error |
| Admin — tarifa negativa o inválida | Solicita corrección hasta 3 veces, luego asigna 0.0 |
| Admin — tipo de línea inválido | Solicita corrección hasta 3 veces, luego asigna "Subterráneo" |
| Admin — campos vacíos al crear línea | Rechaza cada campo vacío con mensaje específico |

---

## 👤 Autor

Gabriel Llanos
