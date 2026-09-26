package com.tiendasara.jdbc.model;

public class Producto {
    private int id;
    private String descripcion;
    private double precio;
    private int cantidad;
    private int idCategoria;
    private int idMarca;
    private String nombreCategoria;
    private String nombreMarca;

    public Producto() {}

    public Producto(String descripcion, double precio, int cantidad, int idCategoria, int idMarca) {
        this.descripcion = descripcion;
        this.precio = precio;
        this.cantidad = cantidad;
        this.idCategoria = idCategoria;
        this.idMarca = idMarca;
    }

    // Getters y Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }
    public double getPrecio() { return precio; }
    public void setPrecio(double precio) { this.precio = precio; }
    public int getCantidad() { return cantidad; }
    public void setCantidad(int cantidad) { this.cantidad = cantidad; }
    public int getIdCategoria() { return idCategoria; }
    public void setIdCategoria(int idCategoria) { this.idCategoria = idCategoria; }
    public int getIdMarca() { return idMarca; }
    public void setIdMarca(int idMarca) { this.idMarca = idMarca; }
    public String getNombreCategoria() { return nombreCategoria; }
    public void setNombreCategoria(String nombreCategoria) { this.nombreCategoria = nombreCategoria; }
    public String getNombreMarca() { return nombreMarca; }
    public void setNombreMarca(String nombreMarca) { this.nombreMarca = nombreMarca; }

    @Override
    public String toString() {
        return String.format("ID: %d | Producto: %-25s | Precio: $%.2f | Stock: %d | Cat: %s | Marca: %s",
                id, descripcion, precio, cantidad, 
                (nombreCategoria != null ? nombreCategoria : idCategoria), 
                (nombreMarca != null ? nombreMarca : idMarca));
    }
}