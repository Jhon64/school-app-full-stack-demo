package com.jhon64.ms_listas_app.repository;

import com.jhon64.ms_listas_app.models.entities.Roles;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface RolesRespository extends JpaRepository<Roles,Long> {

    @Query(value="SELECT u.* FROM roles u WHERE u.deleted = 0",  nativeQuery = true)
    List<Roles> findAllActiveUsers();

    @Query(value="SELECT r.* FROM roles r inner join users_roles rs on rs.rol_id=r.rol_id " +
            "WHERE r.deleted = 0 and rs.user_id=:userID",  nativeQuery = true)
    List<Roles> findAllByUserID(long userID);
}
