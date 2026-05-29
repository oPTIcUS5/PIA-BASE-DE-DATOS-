-- Stores procedures

DELIMITER //
-- SP 1 Registrar Venta 
CREATE PROCEDURE sp_registrar_venta (
    IN p_id_cliente INT,
    IN p_id_producto INT,
    IN p_cantidad INT
)
BEGIN
    DECLARE v_precio DECIMAL(10,2);
    DECLARE v_stock_actual INT;
    DECLARE v_id_venta INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    -- verificar stock y obtener precio
    SELECT precio_actual, stock INTO v_precio, v_stock_actual 
    FROM Productos WHERE id_producto = p_id_producto FOR UPDATE;

    IF v_stock_actual < p_cantidad THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Stock insuficiente para realizar la venta.';
    ELSE
        INSERT INTO Ventas (id_cliente, total, estado) VALUES (p_id_cliente, v_precio * p_cantidad, 'ACTIVA');
        SET v_id_venta = LAST_INSERT_ID();

        INSERT INTO Detalle_Ventas (id_venta, id_producto, cantidad, precio_unitario) 
        VALUES (v_id_venta, p_id_producto, p_cantidad, v_precio);

        UPDATE Productos SET stock = stock - p_cantidad WHERE id_producto = p_id_producto;

        COMMIT;
    END IF;
END //

-- SP cancelar venta
CREATE PROCEDURE sp_cancelar_venta (
    IN p_id_venta INT
)
BEGIN
    DECLARE v_estado_actual VARCHAR(20);
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    SELECT estado INTO v_estado_actual FROM Ventas WHERE id_venta = p_id_venta FOR UPDATE;

    IF v_estado_actual = 'CANCELADA' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: La venta ya se encuentra cancelada.';
    ELSE
        UPDATE Productos p
        INNER JOIN Detalle_Ventas dv ON p.id_producto = dv.id_producto
        SET p.stock = p.stock + dv.cantidad
        WHERE dv.id_venta = p_id_venta;

        UPDATE Ventas SET estado = 'CANCELADA' WHERE id_venta = p_id_venta;

        COMMIT;
    END IF;
END //

-- SP 3: Reporte de Ventas por Rango de Fechas
CREATE PROCEDURE sp_reporte_ventas (
    IN p_fecha_inicio DATE,
    IN p_fecha_fin DATE
)
BEGIN
    SELECT 
        v.id_venta,
        c.nombre AS Cliente,
        v.fecha,
        v.total,
        v.estado,
        COUNT(dv.id_detalle) AS articulos_diferentes
    FROM Ventas v
    JOIN Clientes c ON v.id_cliente = c.id_cliente
    LEFT JOIN Detalle_Ventas dv ON v.id_venta = dv.id_venta
    WHERE DATE(v.fecha) BETWEEN p_fecha_inicio AND p_fecha_fin
    GROUP BY v.id_venta
    ORDER BY v.fecha DESC;
END //

DELIMITER ;
