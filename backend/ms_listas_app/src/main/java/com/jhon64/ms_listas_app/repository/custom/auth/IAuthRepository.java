package com.jhon64.ms_listas_app.repository.custom.auth;

import com.jhon64.ms_listas_app.models.dto.request.usuario.LoginDTO;
import com.jhon64.ms_listas_app.models.entities.Usuario;

import java.util.List;

public interface IAuthRepository {
   List<Usuario> login(LoginDTO login);
}
