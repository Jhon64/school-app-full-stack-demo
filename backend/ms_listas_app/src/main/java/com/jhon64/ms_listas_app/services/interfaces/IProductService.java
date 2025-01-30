package com.jhon64.ms_listas_app.services.interfaces;

import com.jhon64.ms_listas_app.models.dto.response.http.ResponseDTO;
import com.jhon64.ms_listas_app.models.entities.Product;

import java.util.List;
import java.util.Optional;

public interface IProductService {
    ResponseDTO<List<Product>> getFindAll();

    ResponseDTO<Optional<Product>> getFindByID(Long id);

    ResponseDTO<Optional<Product>> getFindByCode(String code);

    ResponseDTO<Product> save(Product product);

    ResponseDTO<Product> update(Product product);

    ResponseDTO<Integer> Delete(Long productID);
}
