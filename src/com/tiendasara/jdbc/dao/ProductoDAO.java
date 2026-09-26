package com.tiendasara.jdbc.dao;

import com.tiendasara.jdbc.config.DatabaseConfig;
import com.tiendasara.jdbc.model.Producto;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductoDAO {

    // 1. Consulta con INNER JOIN (Requerido en Actividad 1)
    public List<Producto> obtenerProductosConDetalle() {
        List<Producto> lista = new ArrayList<>();
        String sql = "SELECT p.Id, p.Descripcion, p.Precio, p.Cantidad, " +
                     "c.Descripcion AS Categoria, m.Descripcion AS Marca " +
                     "FROM Productos p " +
                     "INNER JOIN Categorias c ON p.idCategoria = c.Id " +
                     "INNER JOIN Marcas m ON p.idMarca = m.Id";

        try (Connection con = DatabaseConfig.getConnection();
             Statement stmt = con.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Producto p = new Producto();
                p.setId(rs.getInt("Id"));
                p.setDescripcion(rs.getString("Descripcion"));
                p.setPrecio(rs.getDouble("Precio"));
                p.setCantidad(rs.getInt("Cantidad"));
                p.setNombreCategoria(rs.getString("Categoria"));
                p.setNombreMarca(rs.getString("Marca"));
                lista.add(p);
            }
        } catch (SQLException e) {
            System.err.println("SQL State: " + e.getSQLState() + " | Error Code: " + e.getErrorCode());
            e.printStackTrace();
        }
        return lista;
    }

    // 2. Inserción segura parametrizada con PreparedStatement
    public boolean insertarProducto(Producto p) {
        String sql = "INSERT INTO Productos (Descripcion, Precio, Cantidad, idCategoria, idMarca) VALUES (?, ?, ?, ?, ?)";

        try (Connection con = DatabaseConfig.getConnection();
             PreparedStatement pstmt = con.prepareStatement(sql)) {

            pstmt.setString(1, p.getDescripcion());
            pstmt.setDouble(2, p.getPrecio());
            pstmt.setInt(3, p.getCantidad());
            pstmt.setInt(4, p.getIdCategoria());
            pstmt.setInt(5, p.getIdMarca());

            int filasAfectadas = pstmt.executeUpdate();
            return filasAfectadas > 0;

        } catch (SQLException e) {
            System.err.println("❌ Error al insertar producto: " + e.getMessage());
            return false;
        }
    }

    // 3. Demostración de Control de Transacciones (ACID)
    public void registrarVentaTransaccional(int idProducto, int cantidadComprada) {
        String sqlStock = "UPDATE Productos SET Cantidad = Cantidad - ? WHERE Id = ? AND Cantidad >= ?";

        Connection con = null;
        try {
            con = DatabaseConfig.getConnection();
            
            // Desactivar el autocommit para iniciar una Transacción
            con.setAutoCommit(false);

            try (PreparedStatement pstmt = con.prepareStatement(sqlStock)) {
                pstmt.setInt(1, cantidadComprada);
                pstmt.setInt(2, idProducto);
                pstmt.setInt(3, cantidadComprada);

                int filas = pstmt.executeUpdate();

                if (filas == 0) {
                    throw new SQLException("Stock insuficiente para realizar la venta.");
                }

                // Confirmación exitosa de la transacción
                con.commit();
                System.out.println("✅ Transacción completada con éxito. Stock actualizado.");
            }

        } catch (SQLException e) {
            System.err.println("⚠️ Excepción durante la transacción: " + e.getMessage());
            if (con != null) {
                try {
                    System.out.println("🔄 Ejecutando Rollback...");
                    con.rollback(); // Reversión de cambios ante error
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        } finally {
            if (con != null) {
                try {
                    con.setAutoCommit(true); // Restaurar estado
                    con.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}