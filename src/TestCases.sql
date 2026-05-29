-- Test cases
CALL sp_registrar_venta(1, 1, 2);


SELECT * FROM Ventas;
SELECT * FROM Detalle_Ventas;
SELECT id_producto, nombre, stock FROM Productos WHERE id_producto = 1;


CALL sp_registrar_venta(2, 1, 5);

SELECT * FROM Alertas_Stock;

CALL sp_cancelar_venta(1);

SELECT id_venta, estado FROM Ventas WHERE id_venta = 1;
SELECT id_producto, stock FROM Productos WHERE id_producto = 1; 

-- Validar disparo del trigger de auditoría
SELECT * FROM Bitacora;

CALL sp_reporte_ventas(CURRENT_DATE, CURRENT_DATE);