package com.jhon64.ms_listas_app.services;

import java.util.List;
import java.util.Optional;

import com.jhon64.ms_listas_app.dto.response.http.ResponseDTO;
import com.jhon64.ms_listas_app.models.Usuario;

public interface IUsuarioService {
   ResponseDTO<List<Usuario>> findAll();

   ResponseDTO<Optional<Usuario>> findByID(long id);

   ResponseDTO<Usuario> save(Usuario usuario);

   ResponseDTO<Usuario> Update(Usuario usuario);

   ResponseDTO<Integer> Delete(Integer id);
}
