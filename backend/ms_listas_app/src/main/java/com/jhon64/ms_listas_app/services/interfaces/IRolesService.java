package com.jhon64.ms_listas_app.services.interfaces;

import com.jhon64.ms_listas_app.models.dto.response.http.ResponseDTO;
import com.jhon64.ms_listas_app.models.entities.Roles;

import java.util.List;
import java.util.Optional;

public interface IRolesService {
   
    ResponseDTO<List<Roles>> findAll();
    ResponseDTO<List<Roles>> findAllByUserID(long userID);

   ResponseDTO<Optional<Roles>> findByID(long id);

   ResponseDTO<Roles> save(Roles usuario);

   ResponseDTO<Roles> Update(Roles usuario);

   ResponseDTO<Integer> Delete(Integer id);


}
