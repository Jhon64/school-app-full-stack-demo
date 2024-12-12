package com.jhon64.ms_listas_app.controllers;

import com.jhon64.ms_listas_app.dto.response.http.ResponseAPI;
import com.jhon64.ms_listas_app.dto.response.http.ResponseDTO;
import com.jhon64.ms_listas_app.dto.response.http.StatusCodeResult;
import com.jhon64.ms_listas_app.models.Product;
import com.jhon64.ms_listas_app.models.Usuario;
import com.jhon64.ms_listas_app.services.IProductService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/v1/productos")
public class ProductosController {

    @Autowired
    private IProductService service;

    @GetMapping("/list")
    public ResponseAPI<ResponseDTO<List<Product>>> findAll() {

        HttpStatus statusHttp = HttpStatus.OK;
        ResponseDTO<List<Product>> dataResult = new ResponseDTO<List<Product>>();

        try {
            dataResult = this.service.getFindAll();
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

        return new ResponseAPI<ResponseDTO<List<Product>>>(
                statusHttp,
                dataResult);

        // return listResultApiDTO;
    }

    @PostMapping("save")
    public ResponseAPI<ResponseDTO<Product>> save(@RequestBody Product form) {
        ResponseDTO<Product> dataResult = new ResponseDTO<Product>(StatusCodeResult.BadRequest.Value, null);
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
        return new ResponseAPI<ResponseDTO<Product>>(
                statusHttp,
                dataResult);

    }

    @PutMapping("update")
    public ResponseAPI<ResponseDTO<Product>> update(@RequestBody Product form) {

        ResponseDTO<Product> dataResult = new ResponseDTO<Product>(StatusCodeResult.BadRequest.Value, null);
        HttpStatus statusHttp = HttpStatus.OK;

        try {
            dataResult = this.service.update(form);
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
        return new ResponseAPI<ResponseDTO<Product>>(
                statusHttp,
                dataResult);

    }

    @DeleteMapping("delete/{productID}")
    public ResponseAPI<ResponseDTO<Integer>> delete(@PathVariable Long productID) {
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
