package com.jhon64.ms_listas_app.services.interfaces;

import com.jhon64.ms_listas_app.models.dto.request.usuario.LoginDTO;
import com.jhon64.ms_listas_app.models.dto.response.http.ResponseDTO;
import com.jhon64.ms_listas_app.models.dto.response.usuario.LoginResponseDTO;
import com.jhon64.ms_listas_app.models.entities.Usuario;

import java.util.List;
import java.util.Optional;

public interface IUsuarioService {
   ResponseDTO<List<Usuario>> findAll();

   ResponseDTO<Optional<Usuario>> findByID(long id);

   ResponseDTO<Usuario> save(Usuario usuario);

   ResponseDTO<Usuario> Update(Usuario usuario);

   ResponseDTO<Integer> Delete(Integer id);

   ResponseDTO<LoginResponseDTO> login(LoginDTO login);


    Optional<Usuario> findByUsername(String username);
}
