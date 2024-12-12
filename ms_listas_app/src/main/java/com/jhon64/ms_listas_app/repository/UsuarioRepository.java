package com.jhon64.ms_listas_app.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.jhon64.ms_listas_app.models.Usuario;

@Repository
public interface UsuarioRepository extends JpaRepository<Usuario,Long> {
   
}
