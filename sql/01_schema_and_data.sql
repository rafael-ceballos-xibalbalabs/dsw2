-- 1. CREACIÓN DE LA BASE DE DATOS
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'TiendaSara')
BEGIN
    CREATE DATABASE TiendaSara;
END;
GO

USE TiendaSara;
GO

-- 2. TABLA CATEGORIAS
CREATE TABLE Categorias (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Descripcion VARCHAR(100) NOT NULL
);

-- 3. TABLA MARCAS
CREATE TABLE Marcas (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Descripcion VARCHAR(100) NOT NULL
);

-- 4. TABLA PRODUCTOS
CREATE TABLE Productos (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Descripcion VARCHAR(150) NOT NULL,
    Precio DECIMAL(10, 2) NOT NULL CHECK (Precio >= 0),
    Cantidad INT NOT NULL CHECK (Cantidad >= 0),
    idCategoria INT NOT NULL,
    idMarca INT NOT NULL,
    CONSTRAINT FK_Productos_Categorias FOREIGN KEY (idCategoria) REFERENCES Categorias(Id),
    CONSTRAINT FK_Productos_Marcas FOREIGN KEY (idMarca) REFERENCES Marcas(Id)
);

-- 5. INSERCIONES DE PRUEBA
INSERT INTO Categorias (Descripcion) VALUES ('Electrónica'), ('Cómputo'), ('Ropa');
INSERT INTO Marcas (Descripcion) VALUES ('Sony'), ('ASUS'), ('Nike');

INSERT INTO Productos (Descripcion, Precio, Cantidad, idCategoria, idMarca) 
VALUES 
('Laptop ASUS ROG Strix', 25000.00, 10, 2, 2),
('Pantalla Sony 55 OLED 4K', 18500.00, 5, 1, 1),
('Tenis Running Pro', 2200.00, 15, 3, 3);