package com.jhon64.ms_listas_app.models;

import java.time.LocalDateTime;

import jakarta.persistence.Column;


public class BaseModel {
   @Column(name = "estado", nullable = false)
   private int estado = 1;
   @Column(name = "deleted")
   private boolean deleted = false;
   @Column(name = "created_at")
   private LocalDateTime createdAt;
   @Column(name = "updated_at")
   private LocalDateTime UpdatedAt;

}
