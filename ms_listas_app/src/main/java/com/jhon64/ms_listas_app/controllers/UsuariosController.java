package com.jhon64.ms_listas_app.controllers;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.jhon64.ms_listas_app.dto.response.http.ResponseDTO;
import com.jhon64.ms_listas_app.dto.response.http.ResponseAPI;
import com.jhon64.ms_listas_app.dto.response.http.StatusCodeResult;

import com.jhon64.ms_listas_app.models.Usuario;
import com.jhon64.ms_listas_app.services.IUsuarioService;

@RestController
@RequestMapping("v1/usuarios")
public class UsuariosController {
   @Autowired
   private IUsuarioService service;

   @GetMapping("/list")
   public ResponseAPI<ResponseDTO<List<Usuario>>> findAll() {
      ResponseDTO<List<Usuario>> dataResult = new ResponseDTO<List<Usuario>>(StatusCodeResult.BadRequest.Value, "");
      HttpStatus statusHttp = HttpStatus.OK;

      try {
         dataResult = this.service.findAll();
         if (dataResult.getStatusCode() == StatusCodeResult.Success.Value) {
            statusHttp = HttpStatus.OK;
            dataResult.setStatusCode(200);

         } else if (dataResult.getStatusCode() == StatusCodeResult.BadRequest.Value) {
            statusHttp = HttpStatus.BAD_REQUEST;
            dataResult.setStatusCode(400);
         } else if (dataResult.getStatusCode() == StatusCodeResult.InternalServer.Value) {
            dataResult.setStatusCode(500);
            statusHttp = HttpStatus.INTERNAL_SERVER_ERROR;
         }
      } catch (Exception e) {
         dataResult.setStatusCode(500);
         dataResult.setMessage(e.getMessage());
         statusHttp = HttpStatus.INTERNAL_SERVER_ERROR;
      }
      return new ResponseAPI<ResponseDTO<List<Usuario>>>(
            statusHttp,
            dataResult);
   }
}
