-- triggers

DELIMITER //
-- trigger 1 alerta de Stock
CREATE TRIGGER trg_alerta_stock
AFTER UPDATE ON Productos
FOR EACH ROW
BEGIN
    IF NEW.stock <= NEW.stock_minimo AND OLD.stock > OLD.stock_minimo THEN
        INSERT INTO Alertas_Stock (id_producto, mensaje)
        VALUES (NEW.id_producto, CONCAT('Atención: El stock ha caído a ', NEW.stock, ' unidades.'));
    END IF;
END //

-- Trigger 2 Bitacora de Cambios 
CREATE TRIGGER trg_bitacora_ventas
AFTER UPDATE ON Ventas
FOR EACH ROW
BEGIN
    IF NEW.estado = 'CANCELADA' AND OLD.estado = 'ACTIVA' THEN
        INSERT INTO Bitacora (tabla_afectada, accion, descripcion)
        VALUES ('Ventas', 'CANCELACION', CONCAT('Se canceló la venta ID: ', NEW.id_venta, ' por un monto de $', NEW.total));
    END IF;
END //

DELIMITER ;
