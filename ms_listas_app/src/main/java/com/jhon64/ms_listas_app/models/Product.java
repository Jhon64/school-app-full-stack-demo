package com.jhon64.ms_listas_app.models;

import jakarta.persistence.*;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Data
@Entity
@Getter
@Setter
@NoArgsConstructor
@Table(name = "products")
public class Product {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "productID")
    private Long productID;

    @Column(name = "nombre", length = 250, nullable = false)
    private String nombre;
    @Column(name = "descripcion")
    private String Descripcion;
    @Column(name = "precio", nullable = true)
    private float precio=0;

    @Column(name = "imageURL", nullable = true)
    private String imageURL="";
    @Column(name = "estado", nullable = true)
    private int estado=1;
    @Column(name = "deleted", nullable = false)
    private boolean deleted=false;
}
