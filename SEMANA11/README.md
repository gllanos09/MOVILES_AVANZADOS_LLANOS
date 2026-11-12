# Lab 11 · Grupo A · Caso Ventas (UIKit + Core Data)

App de una tienda que registra productos, clientes y ventas, con inicio de sesión
y dos roles: **Vendedor** y **Supervisor**. Hecha en UIKit (sin storyboard) con Core Data.

- Proyecto: `Lab11-Ventas/Lab11-Ventas.xcodeproj`
- Xcode 14.2, iOS 16.0 o superior, probado en el simulador iPhone SE (3.ª generación)
- Nombre bajo el ícono: **Ventas**

## Cómo probarla

La primera vez que se abre, la app carga datos de ejemplo:

| Dato | Detalle |
|---|---|
| Vendedor de prueba | usuario `jperez`, clave `123456` |
| Productos | Laptop S/ 200 (stock 40), Mouse S/ 35 (stock 60), Teclado, Monitor, Audífonos, Parlante |
| Clientes | Comercial Andina SAC (**VIP**, S/ 5,310.00 comprados), María Torres (Regular), Pedro Quispe (sin compras) |
| Ventas | 6 ventas de `jperez` en los últimos 6 días, para el gráfico del resumen |

Para un supervisor, regístralo desde **Crear cuenta** (caso de prueba 1).
Para volver a empezar desde cero: mantén pulsado el ícono ▸ Eliminar app, y ejecuta de nuevo.

## Modelo de datos

| Entidad | Atributos | Relaciones (delete rule) |
|---|---|---|
| Usuario | nombre, usuario, clave, rol (String) | ventas: To Many ▸ Venta (**Deny**) |
| Producto | nombre, categoria (String), precio (Double), stock (Int) | ventas: To Many ▸ Venta (**Deny**) |
| Cliente | nombre, documento (String) | ventas: To Many ▸ Venta (**Deny**) |
| Venta | fecha (Date), cantidad (Int), precioUnitario, descuento, igv, total (Double), anulada (Bool), motivoAnulacion (String, opcional) | vendedor ▸ Usuario, producto ▸ Producto, cliente ▸ Cliente (To One, Nullify) |

Con **Deny**, Core Data rechaza el guardado si se intenta borrar un producto, cliente o
usuario que tiene ventas. La app deshace el cambio (`rollback`) y muestra una alerta.

## Pestañas y permisos por rol

| | Vendedor | Supervisor |
|---|---|---|
| Pestañas | Productos, Clientes, Venta, Mis ventas, Cuenta | Resumen, Ventas, Productos, Clientes, Cuenta |
| Productos | Solo consultar y buscar | Crear, editar y borrar |
| Clientes | Crear, editar y consultar | Crear, editar, consultar y borrar |
| Ventas | Registrar y ver solo las suyas | Ver todas, filtrar por vendedor y anular con motivo |
| Resumen | No lo ve | Indicadores, gráfico de 7 días y ranking |

## Pantallas

| Pant. | Archivo | Qué hace |
|---|---|---|
| A1 | `LoginViewController` | Usuario y clave; error genérico "Usuario o clave incorrectos" |
| A2 | `RegistroViewController` | Usuario único sin distinguir mayúsculas, clave de mínimo 6 caracteres con confirmación, rol; entra directo |
| A3 | `ProductosViewController` | Búsqueda, chips de categoría, stock en color, deslizar para borrar (supervisor) |
| A4 | `ClientesViewController` | Iniciales, documento, total comprado y categoría calculada |
| A5 | `NuevaVentaViewController` | Vendedor de la sesión, cliente, producto, cantidad con stepper y resumen calculado |
| A6 | `VentasViewController` (modo propias) | Indicadores de hoy y del mes, Todas/Hoy/Mes, búsqueda; anuladas tachadas |
| A7 | `VentasViewController` (modo equipo) | Chips por vendedor y deslizar para anular |
| A8 | Alerta en `VentasViewController` | Resumen de la venta, motivo obligatorio, Anular deshabilitado sin motivo |
| A9 | `ResumenViewController` | Saludo, indicadores contra ayer, gráfico de 7 días, ranking del mes, stock bajo |
| — | `CuentaViewController` | Nombre, usuario, rol y Cerrar sesión |

La sesión es un objeto compartido (`Sesion.shared`) con el usuario conectado. Cerrar sesión
lo pone en `nil` y vuelve al login.

## Reglas de negocio (`Reglas.swift`)

- **Categoría del cliente** (calculada, no guardada), con lo comprado en ventas no anuladas:
  Regular menos de S/ 1,000; Frecuente desde S/ 1,000; VIP desde S/ 5,000.
- **Descuento**: VIP 10 % del subtotal; los demás 0 %.
- **IGV**: 18 % sobre (subtotal − descuento). **Total** = subtotal − descuento + IGV.
- **Stock**: la venta baja el stock; si la cantidad supera el stock, alerta y no se registra.
- **Anular** (solo supervisor): exige motivo, marca la venta, devuelve el stock y deja de
  contar en reportes y en la categoría del cliente.

Ejemplo (caso 3): 2 Laptop × S/ 200.00 a un cliente VIP → subtotal 400.00,
descuento 40.00, IGV (400 − 40) × 18 % = 64.80, total 424.80.

## Casos de prueba

| N.º | Caso | Resultado esperado |
|---|---|---|
| 1 | Registrar a "lparedes" como Supervisor e intentar registrar otro "LPAREDES" | Se crea el primero y entra a la app; el segundo se rechaza por usuario repetido |
| 2 | Registrar con claves distintas o de 4 caracteres | Mensaje de error; no se crea el usuario |
| 3 | Login con clave incorrecta | "Usuario o clave incorrectos"; no entra |
| 4 | `jperez` vende 2 Laptop a Comercial Andina SAC (VIP) | Subtotal 400.00 · descuento 40.00 · IGV 64.80 · total 424.80 · stock 40 a 38 |
| 5 | `jperez` vende 3 Mouse a María Torres (Regular) | Subtotal 105.00 · IGV 18.90 · total 123.90 |
| 6 | Venta de 50 Laptop con stock 40 | Alerta y no se registra; el stock no cambia |
| 7 | `jperez` abre Mis ventas | Solo aparecen sus ventas y ninguna fila permite Anular |
| 8 | El supervisor anula la venta del caso 4 sin motivo y luego con motivo | Sin motivo no se puede; con motivo queda anulada, el stock vuelve a 40 y el resumen baja en 424.80 |
| 9 | Borrar un cliente que tiene ventas | Se impide y se muestra un mensaje |

Las reglas de los casos 4 y 5 y la regla Deny del caso 9 se verificaron también por consola
contra el modelo de Core Data.

## Ícono

`Assets.xcassets/AppIcon` tiene un PNG de 1024 × 1024 sin transparencia (carrito blanco sobre
fondo azul). El nombre bajo el ícono sale de *Display Name* = Ventas.
