package com.jhon64.ms_listas_app.models;

import java.util.Set;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.ManyToMany;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "roles")
public class Roles extends BaseModel {
   @Id
   @GeneratedValue(strategy = GenerationType.IDENTITY)
  @Column(name = "rol_id") 
   private long Rolid;
   @Column(name = "nombre")
   private String nombre;

   @ManyToMany(mappedBy = "roles")
    private Set<Usuario> usuarios;

}
