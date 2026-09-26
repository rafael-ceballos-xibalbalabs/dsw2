package com.tiendasara.jdbc.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConfig {

    // Configuración para Microsoft SQL Server o PostgreSQL
    // private static final String URL = "jdbc:sqlserver://localhost:1433;databaseName=TiendaSara;encrypt=false;";
    // 1. Cadena de conexión JDBC para MySQL (Puerto por defecto 3306)
    private static final String URL = "jdbc:mysql://localhost:3306/TiendaSara?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
    private static final String USER = "root";
    private static final String PASSWORD = "";

    public static Connection getConnection() throws SQLException {
        try {
            // Carga del Driver JDBC Tipo 4 en memoria (Opcional en JDBC 4.0+)
            // Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("❌ Error: No se encontró el driver JDBC en el classpath.");
            System.err.println("❌ Exception Message: " + e.getMessage());
        }
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}