package com.jhon64.ms_listas_app.services.servicesImpl;

import com.jhon64.ms_listas_app.models.dto.response.http.ResponseDTO;
import com.jhon64.ms_listas_app.models.dto.response.http.StatusCodeResult;
import com.jhon64.ms_listas_app.models.entities.Product;
import com.jhon64.ms_listas_app.repository.ProductRepository;

import com.jhon64.ms_listas_app.services.interfaces.IProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ProductServiceImpl implements IProductService {

    @Autowired
    private ProductRepository repository;

    @Override
    public ResponseDTO<List<Product>> getFindAll() {
        ResponseDTO<List<Product>> result = new ResponseDTO<List<Product>>(StatusCodeResult.BadRequest.Value,
                "Actualizando información del producto");
        try {
            List<Product> listResult = this.repository.findAll();
            result.setStatusCode(StatusCodeResult.Success.Value);
            result.setData(listResult);

        } catch (Exception e) {
            result = new ResponseDTO<List<Product>>(StatusCodeResult.InternalServer.Value, e.getMessage());
        }
        return result;
    }

    @Override
    public ResponseDTO<Optional<Product>> getFindByID(Long id) {
        // return Optional.empty();
        ResponseDTO<Optional<Product>> result = new ResponseDTO<Optional<Product>>(StatusCodeResult.BadRequest.Value,
                "Actualizando información del producto");
        try {
            Optional<Product> listResult = this.repository.findById(id);
            result.setStatusCode(StatusCodeResult.Success.Value);
            result.setData(listResult);

        } catch (Exception e) {
            result = new ResponseDTO<Optional<Product>>(StatusCodeResult.InternalServer.Value, e.getMessage());
        }
        return result;

    }

    @Override
    public ResponseDTO<Optional<Product>> getFindByCode(String code) {
        // return Optional.empty();
        ResponseDTO<Optional<Product>> result = new ResponseDTO<Optional<Product>>(StatusCodeResult.BadRequest.Value,
                "Actualizando información del producto");
        try {
            Optional<Product> listResult = Optional.empty();
            result.setStatusCode(StatusCodeResult.Success.Value);
            result.setData(listResult);

        } catch (Exception e) {
            result = new ResponseDTO<Optional<Product>>(StatusCodeResult.InternalServer.Value, e.getMessage());
        }
        return result;

    }

    @Override
    public ResponseDTO<Product> save(Product product) {
        ResponseDTO<Product> result = new ResponseDTO<Product>(StatusCodeResult.BadRequest.Value,
                "Actualizando información del producto");
        try {
            Product saved = this.repository.save(product);
            result.setStatusCode(StatusCodeResult.Success.Value);
            result.setData(saved);

        } catch (Exception e) {
            result = new ResponseDTO<Product>(StatusCodeResult.InternalServer.Value, e.getMessage());
        }
        return result;

    }

    @Override
    public ResponseDTO<Product> update(Product product) {
        ResponseDTO<Product> result = new ResponseDTO<Product>(StatusCodeResult.BadRequest.Value,
                "Actualizando información del producto");
        try {
            Product saved = this.repository.save(product);
            result.setStatusCode(StatusCodeResult.Success.Value);
            result.setData(saved);

        } catch (Exception e) {
            result = new ResponseDTO<Product>(StatusCodeResult.InternalServer.Value, e.getMessage());
        }
        return result;
    }

    @Override
    public ResponseDTO<Integer> Delete(Long id) {
        ResponseDTO<Integer> result = new ResponseDTO<Integer>(StatusCodeResult.BadRequest.Value,
                "Obteniendo informacion");

        try {
            Product p = new Product();
            p.setProductID(id);
            this.repository.delete(p);
            result = new ResponseDTO<Integer>(1);

        } catch (Exception e) {
            result = new ResponseDTO<Integer>(StatusCodeResult.InternalServer.Value, e.getMessage());
        }
        return result;
    }
}
