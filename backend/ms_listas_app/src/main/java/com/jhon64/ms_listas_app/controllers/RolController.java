package com.jhon64.ms_listas_app.controllers;

import com.jhon64.ms_listas_app.models.dto.response.http.ResponseAPI;
import com.jhon64.ms_listas_app.models.dto.response.http.ResponseDTO;
import com.jhon64.ms_listas_app.models.dto.response.http.StatusCodeResult;
import com.jhon64.ms_listas_app.models.entities.Roles;
import com.jhon64.ms_listas_app.services.interfaces.IRolesService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/v1/roles")
public class RolController {
   @Autowired
    private IRolesService service;

    @GetMapping("/list")
    public ResponseAPI<ResponseDTO<List<Roles>>> findAll() {

        HttpStatus statusHttp = HttpStatus.OK;
        ResponseDTO<List<Roles>> dataResult = new ResponseDTO<List<Roles>>();

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

        return new ResponseAPI<ResponseDTO<List<Roles>>>(
                statusHttp,
                dataResult);

        // return listResultApiDTO;
    }

    @PostMapping("/save")
    public ResponseAPI<ResponseDTO<Roles>> save(@RequestBody Roles form) {
        ResponseDTO<Roles> dataResult = new ResponseDTO<Roles>(StatusCodeResult.BadRequest.Value, null);
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
        return new ResponseAPI<ResponseDTO<Roles>>(
                statusHttp,
                dataResult);

    }

    @PutMapping("/update")
    public ResponseAPI<ResponseDTO<Roles>> update(@RequestBody Roles form) {

        ResponseDTO<Roles> dataResult = new ResponseDTO<Roles>(StatusCodeResult.BadRequest.Value, null);
        HttpStatus statusHttp = HttpStatus.OK;

        try {
            dataResult = this.service.Update(form);
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
        return new ResponseAPI<ResponseDTO<Roles>>(
                statusHttp,
                dataResult);

    }

    @DeleteMapping("/delete/{productID}")
    public ResponseAPI<ResponseDTO<Integer>> delete(@PathVariable Integer productID) {
        ResponseDTO<Integer> dataResult = new ResponseDTO<Integer>(StatusCodeResult.BadRequest.Value, null);
        HttpStatus statusHttp = HttpStatus.OK;

        try {
            dataResult = this.service.Delete(productID);
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
        return new ResponseAPI<ResponseDTO<Integer>>(
                statusHttp,
                dataResult);

    }

}
