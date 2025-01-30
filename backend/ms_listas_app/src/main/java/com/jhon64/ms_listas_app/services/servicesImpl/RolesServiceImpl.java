package com.jhon64.ms_listas_app.services.servicesImpl;

import java.util.List;
import java.util.Optional;

import com.jhon64.ms_listas_app.services.interfaces.IRolesService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.jhon64.ms_listas_app.models.dto.response.http.ResponseDTO;
import com.jhon64.ms_listas_app.models.dto.response.http.StatusCodeResult;
import com.jhon64.ms_listas_app.models.entities.Roles;
import com.jhon64.ms_listas_app.repository.RolesRespository;


import io.swagger.v3.oas.annotations.parameters.RequestBody;

@Service
public class RolesServiceImpl implements IRolesService {

   @Autowired
   private RolesRespository repository;

   @Override
   public ResponseDTO<List<Roles>> findAll() {
      ResponseDTO<List<Roles>> result = new ResponseDTO<List<Roles>>(StatusCodeResult.BadRequest.Value,
            "Actualizando información de usuarios");
      try {
         List<Roles> listResult = this.repository.findAllActiveUsers();
         result.setStatusCode(StatusCodeResult.Success.Value);
         result.setData(listResult);

      } catch (Exception e) {
         result = new ResponseDTO<List<Roles>>(StatusCodeResult.InternalServer.Value, e.getMessage());
      }
      return result;
   }

   @Override
   public ResponseDTO<List<Roles>> findAllByUserID(long userID) {
      ResponseDTO<List<Roles>> result = new ResponseDTO<List<Roles>>(StatusCodeResult.BadRequest.Value,
              "Actualizando información de usuarios");
      try {
         List<Roles> listResult = this.repository.findAllByUserID(userID);
         result.setStatusCode(StatusCodeResult.Success.Value);
         result.setData(listResult);

      } catch (Exception e) {
         result = new ResponseDTO<List<Roles>>(StatusCodeResult.InternalServer.Value, e.getMessage());
      }
      return result;
   }

   @Override
   public ResponseDTO<Optional<Roles>> findByID(long id) {
      ResponseDTO<Optional<Roles>> result = new ResponseDTO<Optional<Roles>>(StatusCodeResult.BadRequest.Value,
            "Actualizando información del producto");
      try {
         Optional<Roles> listResult = this.repository.findById(id);
         result.setStatusCode(StatusCodeResult.Success.Value);
         result.setData(listResult);

      } catch (Exception e) {
         result = new ResponseDTO<Optional<Roles>>(StatusCodeResult.InternalServer.Value, e.getMessage());
      }
      return result;
   }

   @Override
   public ResponseDTO<Roles> save(@RequestBody Roles usuario) {
      ResponseDTO<Roles> result = new ResponseDTO<Roles>(StatusCodeResult.BadRequest.Value,
            "información registrada");
      try {
         Roles saved = this.repository.save(usuario);
         result.setStatusCode(StatusCodeResult.Success.Value);
         result.setData(saved);

      } catch (Exception e) {
         result = new ResponseDTO<Roles>(StatusCodeResult.InternalServer.Value, e.getMessage());
      }
      return result;
   }

   @Override
   public ResponseDTO<Roles> Update(Roles usuario) {
      ResponseDTO<Roles> result = new ResponseDTO<Roles>(StatusCodeResult.BadRequest.Value,
            "información Actualizada");
      try {
         Roles saved = this.repository.save(usuario);
         result.setStatusCode(StatusCodeResult.Success.Value);
         result.setData(saved);

      } catch (Exception e) {
         result = new ResponseDTO<Roles>(StatusCodeResult.InternalServer.Value, e.getMessage());
      }
      return result;
   }

   @Override
   public ResponseDTO<Integer> Delete(Integer id) {
      ResponseDTO<Integer> result = new ResponseDTO<Integer>(StatusCodeResult.BadRequest.Value,
            "Elimando información");

      try {
         Roles p = new Roles();
         p.setRolid(id);
         p.setDeleted(true);
         this.repository.save(p);
         result = new ResponseDTO<Integer>(1);

      } catch (Exception e) {
         result = new ResponseDTO<Integer>(StatusCodeResult.InternalServer.Value, e.getMessage());
      }
      return result;
   }

}
