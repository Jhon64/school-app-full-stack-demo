package com.jhon64.ms_listas_app.servicesImpl;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.jhon64.ms_listas_app.dto.response.http.ResponseDTO;
import com.jhon64.ms_listas_app.dto.response.http.StatusCodeResult;
import com.jhon64.ms_listas_app.models.Product;
import com.jhon64.ms_listas_app.models.Usuario;
import com.jhon64.ms_listas_app.repository.UsuarioRepository;
import com.jhon64.ms_listas_app.services.IUsuarioService;

@Service
public class UsuarioServiceImpl implements IUsuarioService {

	@Autowired
	private UsuarioRepository repository;

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

}
