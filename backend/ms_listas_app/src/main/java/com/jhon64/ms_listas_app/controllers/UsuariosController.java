package com.jhon64.ms_listas_app.controllers;

import com.jhon64.ms_listas_app.models.dto.request.usuario.LoginDTO;
import com.jhon64.ms_listas_app.models.dto.response.http.ResponseAPI;
import com.jhon64.ms_listas_app.models.dto.response.http.ResponseDTO;
import com.jhon64.ms_listas_app.models.dto.response.http.StatusCodeResult;
import com.jhon64.ms_listas_app.models.dto.response.usuario.LoginResponseDTO;
import com.jhon64.ms_listas_app.models.entities.Usuario;
import com.jhon64.ms_listas_app.services.interfaces.IUsuarioService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("v1/usuarios")
public class UsuariosController {
    @Autowired
    private IUsuarioService service;

    @GetMapping("/list")
    public ResponseEntity<ResponseDTO<List<Usuario>>> findAll() {
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
                dataResult).result();
    }

    @PostMapping("/save")
    public ResponseEntity<ResponseDTO<Usuario>> save(@RequestBody Usuario form) {
        ResponseDTO<Usuario> dataResult = new ResponseDTO<Usuario>(StatusCodeResult.BadRequest.Value, null);
        HttpStatus statusHttp = HttpStatus.OK;

        try {
            dataResult = this.service.save(form);
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
        return new ResponseAPI<ResponseDTO<Usuario>>(
                statusHttp,
                dataResult).result();

    }

    @PostMapping("/login")
    public ResponseEntity<ResponseDTO<LoginResponseDTO>> save(@RequestBody LoginDTO form) {
        ResponseDTO<LoginResponseDTO> dataResult = new ResponseDTO<LoginResponseDTO>(StatusCodeResult.BadRequest.Value,
                null);
        HttpStatus statusHttp = HttpStatus.OK;
        boolean validForm = true;
        try {
            if (form.getPassword().isEmpty() || form.getPassword().isBlank() || form.getUsername() == null) {
                statusHttp = HttpStatus.BAD_REQUEST;
//            dataResult.setStatusCode(400);
                dataResult.setMessage("Password is required");
                validForm = false;
            }
            if (form.getUsername() == null || form.getUsername().isEmpty() || form.getUsername().isBlank()) {
                statusHttp = HttpStatus.BAD_REQUEST;
//            dataResult.setStatusCode(400);
                dataResult.setMessage("username is required");
                validForm = false;
            }
            if (validForm) {
                dataResult = this.service.login(form);
                if (dataResult.getStatusCode() == StatusCodeResult.Success.Value) {
                    statusHttp = HttpStatus.OK;
//               dataResult.setStatusCode(200);
                } else if (dataResult.getStatusCode() == StatusCodeResult.BadRequest.Value) {
                    statusHttp = HttpStatus.BAD_REQUEST;
//               dataResult.setStatusCode(400);
                } else if (dataResult.getStatusCode() == StatusCodeResult.InternalServer.Value) {
//               dataResult.setStatusCode(500);
                    statusHttp = HttpStatus.INTERNAL_SERVER_ERROR;
                } else if (dataResult.getStatusCode() == StatusCodeResult.unauthorized.Value) {
                    statusHttp = HttpStatus.UNAUTHORIZED;
                }
            }

        } catch (Exception e) {
            dataResult.setMessage(e.getMessage());
            statusHttp = HttpStatus.INTERNAL_SERVER_ERROR;
            dataResult.setStatusCode(StatusCodeResult.InternalServer.Value);
        }
        return new ResponseAPI<ResponseDTO<LoginResponseDTO>>(
                statusHttp,
                dataResult).result();

    }
}
