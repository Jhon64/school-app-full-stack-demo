package com.jhon64.ms_listas_app.services.servicesImpl;

import java.util.List;
import java.util.Optional;

import com.jhon64.ms_listas_app.models.entities.Roles;

import com.jhon64.ms_listas_app.services.interfaces.IRolesService;
import com.jhon64.ms_listas_app.services.interfaces.IUsuarioService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestBody;

import com.jhon64.ms_listas_app.models.dto.request.usuario.LoginDTO;
import com.jhon64.ms_listas_app.models.dto.response.http.ResponseDTO;
import com.jhon64.ms_listas_app.models.dto.response.http.StatusCodeResult;
import com.jhon64.ms_listas_app.models.dto.response.usuario.LoginResponseDTO;
import com.jhon64.ms_listas_app.models.entities.Usuario;
import com.jhon64.ms_listas_app.repository.UsuarioRepository;
import com.jhon64.ms_listas_app.repository.custom.auth.IAuthRepository;


@Service
public class UsuarioServiceImpl implements IUsuarioService {

    @Autowired
    private UsuarioRepository repository;
    @Autowired
    private IAuthRepository authRepository;
    @Autowired
    private IRolesService rolesService;

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
//				usuarioAuth.setPassword(user.getPassword());
                usuarioAuth.setUsername(user.getUsername());
                usuarioAuth.setFullName(user.getFullName());
                //obtenemos roles
                List<Roles> roles = this.rolesService.findAllByUserID(user.getId()).getData();
                usuarioAuth.setRoles(roles);
//                String token = Jwts.builder()
//                        .setSubject(userDetails.getUsername())
//                        .claim("roles", roles)  // HERE IS LINE
//                        .setIssuedAt(now)
//                        .setExpiration(expiryDate)
//                        .signWith(SignatureAlgorithm.HS512, APP_SECRET)
//                        .compact();


                resultLogin.setStatusCode(StatusCodeResult.Success.Value);
                resultLogin.setData(usuarioAuth);


            } else {
                resultLogin = new ResponseDTO<LoginResponseDTO>(StatusCodeResult.unauthorized.Value, "Error al autenticar");
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
