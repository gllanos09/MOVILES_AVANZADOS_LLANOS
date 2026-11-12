# PROMPTS · Lab 11 · Caso Ventas

Registro de las consultas hechas a la IA para este trabajo, con el formato que pide el laboratorio.

## Consulta 1 · Construcción de la app

**Contexto.** Laboratorio 11 de Programación en Móviles Avanzado (Tecsup), Grupo A, Caso Ventas.
Se entregó a la IA el PDF del laboratorio. El entorno es una Mac con macOS 12.7.6 y Xcode 14.2,
así que el SDK llega solo a iOS 16.2 y Swift 5.7.

**Tarea.** Construir la app completa del Caso Ventas en UIKit + Core Data dentro de la rama
`Caso_Ventas` del repositorio: las 4 entidades con sus relaciones y delete rules, login, registro,
sesión, pestañas por rol, las 9 pantallas, las reglas de negocio (categoría, descuento, IGV,
stock, anulación) y el ícono.

**Restricciones.**
- UIKit con `UITabBarController` y Core Data, sin SwiftUI ni SwiftData.
- Compatible con Xcode 14.2 / iOS 16.
- Respetar la matriz de permisos y los nueve casos de prueba del enunciado.
- Commits cortos.

**Formato esperado.** Proyecto de Xcode que compile, organizado en `SEMANA11/Lab11-Ventas`,
con un archivo por pantalla, más un README con el modelo, los permisos y los casos de prueba.

**Qué hice con la respuesta.**
- La acepté.
- Compilé el proyecto, revisé cada pantalla en el simulador para los dos roles y verifiqué por
  consola los montos de los casos 4 y 5 (424.80 y 123.90).
- También verifiqué por consola que la regla Deny bloquea borrar un cliente o producto con ventas.
- La IA agregó datos de ejemplo (un vendedor, productos y un cliente VIP) para poder probar los
  casos sin cargar todo a mano.

**Pendiente de mi parte.** Recorrer los nueve casos de prueba en el simulador, tomar las capturas
para la entrega y preparar la defensa oral de cada pantalla.
