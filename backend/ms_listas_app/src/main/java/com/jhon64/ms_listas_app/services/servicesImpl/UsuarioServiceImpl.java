package com.jhon64.ms_listas_app.services.servicesImpl;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Optional;
import java.util.Set;

import com.jhon64.ms_listas_app.models.entities.Roles;

import com.jhon64.ms_listas_app.services.interfaces.IRolesService;
import com.jhon64.ms_listas_app.services.interfaces.IUsuarioService;

import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.security.SecurityProperties.User;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestBody;

import com.jhon64.ms_listas_app.models.dto.request.usuario.LoginDTO;
import com.jhon64.ms_listas_app.models.dto.response.http.ResponseDTO;
import com.jhon64.ms_listas_app.models.dto.response.http.StatusCodeResult;
import com.jhon64.ms_listas_app.models.dto.response.usuario.LoginResponseDTO;
import com.jhon64.ms_listas_app.models.entities.Usuario;
import com.jhon64.ms_listas_app.repository.UsuarioRepository;
import com.jhon64.ms_listas_app.repository.custom.auth.IAuthRepository;
import com.jhon64.ms_listas_app.security.entity.UserLogged;
import com.jhon64.ms_listas_app.security.services.JWTService;

@Service
public class UsuarioServiceImpl implements IUsuarioService {

    @Autowired
    private UsuarioRepository repository;
    @Autowired
    private IAuthRepository authRepository;
    @Autowired
    private IRolesService rolesService;
    @Autowired
    private JWTService jwtService;

    @Override
    public ResponseDTO<List<Usuario>> findAll() {
        ResponseDTO<List<Usuario>> result = new ResponseDTO<List<Usuario>>(StatusCodeResult.BadRequest.Value,
                "Actualizando información de usuarios");
        try {
            List<Usuario> listResult = this.repository.findAll();
            result.setStatusCode(StatusCodeResult.Success.Value);
            result.setData(listResult);

        } catch (Exception e) {
            result = new ResponseDTO<List<Usuario>>(StatusCodeResult.InternalServer.Value, e.getMessage());
        }
        return result;

    }

    @Override
    public ResponseDTO<Optional<Usuario>> findByID(long id) {
        // TODO Auto-generated method stub
        // return Optional.empty();
        ResponseDTO<Optional<Usuario>> result = new ResponseDTO<Optional<Usuario>>(StatusCodeResult.BadRequest.Value,
                "Actualizando información del producto");
        try {
            Optional<Usuario> listResult = this.repository.findById(id);
            result.setStatusCode(StatusCodeResult.Success.Value);
            result.setData(listResult);

        } catch (Exception e) {
            result = new ResponseDTO<Optional<Usuario>>(StatusCodeResult.InternalServer.Value, e.getMessage());
        }
        return result;
    }

    @Override
    public ResponseDTO<Usuario> save(Usuario usuario) {
        ResponseDTO<Usuario> result = new ResponseDTO<Usuario>(StatusCodeResult.BadRequest.Value,
                "Actualizando información del producto");
        try {
            Usuario saved = this.repository.save(usuario);
            result.setStatusCode(StatusCodeResult.Success.Value);
            result.setData(saved);

        } catch (Exception e) {
            result = new ResponseDTO<Usuario>(StatusCodeResult.InternalServer.Value, e.getMessage());
        }
        return result;
    }

    @Override
    public ResponseDTO<Usuario> Update(Usuario usuario) {
        ResponseDTO<Usuario> result = new ResponseDTO<Usuario>(StatusCodeResult.BadRequest.Value,
                "Actualizando información del producto");
        try {
            Usuario saved = this.repository.save(usuario);
            result.setStatusCode(StatusCodeResult.Success.Value);
            result.setData(saved);

        } catch (Exception e) {
            result = new ResponseDTO<Usuario>(StatusCodeResult.InternalServer.Value, e.getMessage());
        }
        return result;
    }

    @Override
    public ResponseDTO<Integer> Delete(Integer id) {
        ResponseDTO<Integer> result = new ResponseDTO<Integer>(StatusCodeResult.BadRequest.Value,
                "Obteniendo informacion");

        try {
            Usuario p = new Usuario();
            p.setId(id);
            this.repository.delete(p);
            result = new ResponseDTO<Integer>(1);

        } catch (Exception e) {
            result = new ResponseDTO<Integer>(StatusCodeResult.InternalServer.Value, e.getMessage());
        }
        return result;
    }

    @Override
    public ResponseDTO<LoginResponseDTO> login(@RequestBody LoginDTO login) {

        ResponseDTO<LoginResponseDTO> resultLogin = new ResponseDTO<LoginResponseDTO>(null);
        LoginResponseDTO usuarioAuth = new LoginResponseDTO();

        try {
            List<Usuario> resultValidate = this.authRepository.login(login);
            if (!resultValidate.isEmpty()) {
                Usuario user = resultValidate.getFirst();
                usuarioAuth.setPassword(user.getPassword());
                usuarioAuth.setUsername(user.getUsername());
                usuarioAuth.setFullName(user.getFullName());



                // obtenemos roles
                // List<Roles> roles = this.rolesService.findAllByUserID(user.getId()).getData();
                List<Roles> roles =new ArrayList<Roles>();
                Iterator<Roles> rolesIte=user.getRoles().iterator();
                while (rolesIte.hasNext()) {
                    roles.add(rolesIte.next());
                }

                usuarioAuth.setRoles(roles);
                Collection<? extends GrantedAuthority> authorities = List.of(new SimpleGrantedAuthority("ROLE_ADMINISTRADOR"));
                org.springframework.security.core.userdetails.User userDetail = new org.springframework.security.core.userdetails.User(
                        usuarioAuth.getUsername(),
                        usuarioAuth.getPassword(), authorities);

                UserLogged logged = new UserLogged();
                logged.setUsername(userDetail.getUsername());
                logged.setUser(userDetail);
                usuarioAuth.setToken(jwtService.generateToken(logged));
                usuarioAuth.setExpiredDate(jwtService.expiredAt());
                usuarioAuth.setUserID(user.getId());

                resultLogin.setStatusCode(StatusCodeResult.Success.Value);
                resultLogin.setData(usuarioAuth);

            } else {
                resultLogin = new ResponseDTO<LoginResponseDTO>(StatusCodeResult.unauthorized.Value,
                        "Error al autenticar");
            }

            // result.setStatusCode(StatusCodeResult.Success.Value);
            // result.setData(listResult);
            // Object infoUsuario=this.repository.login(login);

        } catch (Exception e) {
            resultLogin = new ResponseDTO<LoginResponseDTO>(StatusCodeResult.InternalServer.Value, e.getMessage());
        }

        return resultLogin;

    }

    @Override
    public Optional<Usuario> findByUsername(String username) {
        return this.repository.findByUsername(username);
    }

}
