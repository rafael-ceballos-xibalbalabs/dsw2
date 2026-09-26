package com.tiendasara.jdbc;

import com.tiendasara.jdbc.dao.ProductoDAO;
import com.tiendasara.jdbc.model.Producto;

import java.util.List;

public class MainApplication {

    public static void main(String[] args) {
        System.out.println("=================================================");
        System.out.println("   DEMO TUTORÍA 1: DESARROLLO DE SISTEMAS WEB II  ");
        System.out.println("   Manejo de JDBC, SQL Server y Transacciones   ");
        System.out.println("=================================================\n");

        ProductoDAO dao = new ProductoDAO();

        // 1. Probar Inserción Parametrizada (PreparedStatement)
        System.out.println("--- 1. Insertando un nuevo producto ---");
        Producto nuevo = new Producto("Teclado Mecánico RGB", 1250.00, 20, 1, 2);
        boolean insertado = dao.insertarProducto(nuevo);
        System.out.println("Resultado de inserción: " + (insertado ? "Éxito" : "Fallo"));

        // 2. Probar Consulta con INNER JOIN
        System.out.println("\n--- 2. Listado de Productos con Categoría y Marca (INNER JOIN) ---");
        List<Producto> productos = dao.obtenerProductosConDetalle();
        for (Producto p : productos) {
            System.out.println(p);
        }

        // 3. Probar Transacción en Vivo (Con Commit o Rollback)
        System.out.println("\n--- 3. Ejecutando Venta Transaccional (Control de Stock) ---");
        dao.registrarVentaTransaccional(1, 2); // Vende 2 unidades de la Laptop
    }
}