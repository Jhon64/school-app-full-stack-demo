package com.jhon64.ms_listas_app.models;

import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;

import com.fasterxml.jackson.annotation.JsonBackReference;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.ManyToMany;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

@Getter
@Setter
@Entity
@Table(name = "roles")
//public class Roles extends BaseModel {
public class Roles {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "rol_id")
    private long Rolid;
    @Column(name = "nombre")
    private String nombre;

    @Column(name = "estado", nullable = false)
    private int estado = 1;
    @Column(name = "deleted")
    private boolean deleted = false;
    @CreationTimestamp
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalDateTime UpdatedAt;


//   @ManyToMany(mappedBy = "roles")
//   @JsonBackReference
//    private Set<Usuario> usuarios = new HashSet<>();

}
