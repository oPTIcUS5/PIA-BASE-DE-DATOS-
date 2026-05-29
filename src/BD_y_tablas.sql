-- PIA

-- tablas y BD
CREATE DATABASE IF NOT EXISTS SistemaVentas_DB;
USE SistemaVentas_DB;

CREATE TABLE Clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE Productos (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    precio_actual DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL,
    stock_minimo INT NOT NULL DEFAULT 5
);

CREATE TABLE Ventas (
    id_venta INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(10,2) DEFAULT 0.00,
    estado ENUM('ACTIVA', 'CANCELADA') DEFAULT 'ACTIVA',
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente)
);

CREATE TABLE Detalle_Ventas (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    id_venta INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) GENERATED ALWAYS AS (cantidad * precio_unitario) STORED,
    FOREIGN KEY (id_venta) REFERENCES Ventas(id_venta),
    FOREIGN KEY (id_producto) REFERENCES Productos(id_producto)
);

CREATE TABLE Bitacora (
    id_bitacora INT AUTO_INCREMENT PRIMARY KEY,
    tabla_afectada VARCHAR(50),
    accion VARCHAR(50),
    descripcion TEXT,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Alertas_Stock (
    id_alerta INT AUTO_INCREMENT PRIMARY KEY,
    id_producto INT,
    mensaje VARCHAR(255),
    fecha_alerta DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_producto) REFERENCES Productos(id_producto)
);

-- insercion de Datos 
INSERT INTO Clientes (nombre, email) VALUES 
('Alan Turing', 'alan.t@ejemplo.com'),
('Ada Lovelace', 'ada.l@ejemplo.com'),
('Donald Knuth', 'd.knuth@ejemplo.com');

INSERT INTO Productos (nombre, precio_actual, stock, stock_minimo) VALUES 
('Laptop Thinkpad', 15000.00, 10, 3),
('Teclado Mecánico', 1200.00, 20, 5),
('Monitor 27 Pulgadas', 4500.00, 6, 2);
