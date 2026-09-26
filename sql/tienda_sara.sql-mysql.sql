-- =============================================================================
-- ASIGNATURA: Desarrollo de Sistemas Web II
-- UNIVERSIDAD: Universidad Corporativa Global Academy | Coppel
-- ESCENARIO: Actividad 1 - Base de Datos para el Sistema Web (Tienda Sara)
-- MOTOR: MySQL / MariaDB (Compatibilidad con Connector/J 8.0+)
-- =============================================================================

-- 1. CREACIÓN Y SELECCIÓN DE LA BASE DE DATOS
DROP DATABASE IF EXISTS TiendaSara;
CREATE DATABASE TiendaSara CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE TiendaSara;

-- 2. TABLA: Categorias
CREATE TABLE Categorias (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Descripcion VARCHAR(100) NOT NULL
) ENGINE=InnoDB;

-- 3. TABLA: Marcas
CREATE TABLE Marcas (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Descripcion VARCHAR(100) NOT NULL
) ENGINE=InnoDB;

-- 4. TABLA: Productos
CREATE TABLE Productos (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Descripcion VARCHAR(150) NOT NULL,
    Precio DECIMAL(10, 2) NOT NULL CHECK (Precio >= 0),
    Cantidad INT NOT NULL CHECK (Cantidad >= 0),
    idCategoria INT NOT NULL,
    idMarca INT NOT NULL,
    CONSTRAINT FK_Productos_Categorias FOREIGN KEY (idCategoria) REFERENCES Categorias(Id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT FK_Productos_Marcas FOREIGN KEY (idMarca) REFERENCES Marcas(Id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 5. TABLA: Carrito
CREATE TABLE Carrito (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    FolioVenta VARCHAR(50) NOT NULL UNIQUE,
    TotalCompra DECIMAL(10, 2) NOT NULL DEFAULT 0.00 CHECK (TotalCompra >= 0),
    Estatus VARCHAR(30) NOT NULL DEFAULT 'Pendiente',
    idCategoria INT NULL,
    idMarca INT NULL,
    CONSTRAINT FK_Carrito_Categorias FOREIGN KEY (idCategoria) REFERENCES Categorias(Id) ON DELETE SET NULL,
    CONSTRAINT FK_Carrito_Marcas FOREIGN KEY (idMarca) REFERENCES Marcas(Id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- 6. TABLA: CarritoDetalle
CREATE TABLE CarritoDetalle (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    IdCarrito INT NOT NULL,
    IdProducto INT NOT NULL,
    Cantidad INT NOT NULL CHECK (Cantidad > 0),
    Subtotal DECIMAL(10, 2) NOT NULL CHECK (Subtotal >= 0),
    CONSTRAINT FK_Detalle_Carrito FOREIGN KEY (IdCarrito) REFERENCES Carrito(Id) ON DELETE CASCADE,
    CONSTRAINT FK_Detalle_Productos FOREIGN KEY (IdProducto) REFERENCES Productos(Id) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- =============================================================================
-- INSERCIÓN DE DATOS DE PRUEBA (5 Registros por tabla requeridos en Actividad 1)
-- =============================================================================

-- Inserciones en Categorias
INSERT INTO Categorias (Descripcion) VALUES 
('Electrónica'),
('Cómputo'),
('Ropa y Calzado'),
('Línea Blanca'),
('Muebles');

-- Inserciones en Marcas
INSERT INTO Marcas (Descripcion) VALUES 
('Sony'),
('ASUS'),
('Nike'),
('Samsung'),
('LG');

-- Inserciones en Productos
INSERT INTO Productos (Descripcion, Precio, Cantidad, idCategoria, idMarca) VALUES 
('Laptop ASUS ROG Strix 16', 28500.00, 10, 2, 2),
('Pantalla Sony 55 OLED 4K', 19999.00, 5, 1, 1),
('Tenis Running Air Max', 2499.00, 20, 3, 3),
('Refrigerador Samsung French Door', 22500.00, 8, 4, 4),
('Lavadora LG Inverter 22kg', 14200.00, 12, 4, 5);

-- Inserciones en Carrito
INSERT INTO Carrito (FolioVenta, TotalCompra, Estatus, idCategoria, idMarca) VALUES 
('FOL-2026-001', 28500.00, 'Pagado', 2, 2),
('FOL-2026-002', 22498.00, 'Pendiente', 1, 1),
('FOL-2026-003', 2499.00, 'Completado', 3, 3),
('FOL-2026-004', 36700.00, 'Pagado', 4, 4),
('FOL-2026-005', 0.00, 'Cancelado', NULL, NULL);

-- Inserciones en CarritoDetalle
INSERT INTO CarritoDetalle (Fecha, IdCarrito, IdProducto, Cantidad, Subtotal) VALUES 
(NOW(), 1, 1, 1, 28500.00),
(NOW(), 2, 2, 1, 19999.00),
(NOW(), 2, 3, 1, 2499.00),
(NOW(), 3, 3, 1, 2499.00),
(NOW(), 4, 4, 1, 22500.00);

-- =============================================================================
-- CONSULTAS DE DEMOSTRACIÓN (INNER JOINs requeridos en el Paso 7 de Actividad 1)
-- =============================================================================

-- Consulta A: Productos con sus Marcas y sus Categorías
SELECT 
    p.Id AS ProductoID,
    p.Descripcion AS Producto,
    p.Precio,
    p.Cantidad AS Stock,
    c.Descripcion AS Categoria,
    m.Descripcion AS Marca
FROM Productos p
INNER JOIN Categorias c ON p.idCategoria = c.Id
INNER JOIN Marcas m ON p.idMarca = m.Id;

-- Consulta B: Carritos con sus detalles y productos asociados
SELECT 
    c.FolioVenta,
    c.Estatus,
    cd.Fecha,
    p.Descripcion AS ProductoComprado,
    cd.Cantidad,
    cd.Subtotal
FROM Carrito c
INNER JOIN CarritoDetalle cd ON c.Id = cd.IdCarrito
INNER JOIN Productos p ON cd.IdProducto = p.Id;

-- Consulta C: Vista completa multitabla (Carrito -> Detalle -> Producto -> Marca -> Categoría)
SELECT 
    c.FolioVenta,
    c.Estatus,
    p.Descripcion AS Producto,
    m.Descripcion AS Marca,
    cat.Descripcion AS Categoria,
    cd.Cantidad,
    cd.Subtotal
FROM Carrito c
INNER JOIN CarritoDetalle cd ON c.Id = cd.IdCarrito
INNER JOIN Productos p ON cd.IdProducto = p.Id
INNER JOIN Marcas m ON p.idMarca = m.Id
INNER JOIN Categorias cat ON p.idCategoria = cat.Id;