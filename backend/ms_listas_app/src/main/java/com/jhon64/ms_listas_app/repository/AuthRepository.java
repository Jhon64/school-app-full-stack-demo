package com.jhon64.ms_listas_app.repository;


import com.jhon64.ms_listas_app.models.dto.request.usuario.LoginDTO;
import com.jhon64.ms_listas_app.models.entities.Usuario;
import com.jhon64.ms_listas_app.repository.custom.auth.IAuthRepository;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class AuthRepository implements IAuthRepository {

    @PersistenceContext
    private EntityManager entityManager;
   @Override
   public List<Usuario> login(LoginDTO login) {
      String sql = "SELECT * FROM users u  " +
                     "WHERE password=:password and username = :username";

        Query query = entityManager.createNativeQuery(sql, Usuario.class);
        query.setParameter("password", login.getPassword());
        query.setParameter("username", login.getUsername());
        return query.getResultList();
   }
   
}
