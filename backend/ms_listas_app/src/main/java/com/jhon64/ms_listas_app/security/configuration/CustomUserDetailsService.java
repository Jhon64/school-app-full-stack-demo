package com.jhon64.ms_listas_app.security.configuration;

import com.jhon64.ms_listas_app.models.entities.Usuario;
import com.jhon64.ms_listas_app.repository.RolesRespository;
import com.jhon64.ms_listas_app.security.entity.UserLogged;
import com.jhon64.ms_listas_app.security.utils.SecurityUtils;
import com.jhon64.ms_listas_app.services.interfaces.IUsuarioService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.Set;

@Service
public class CustomUserDetailsService implements UserDetailsService {
    @Autowired
    private IUsuarioService service;

    @Autowired
    private RolesRespository rolesRepository;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        Usuario _user = service.findByUsername(username).orElseThrow(
                () -> new UsernameNotFoundException("el usuario no fue encontrado"));
//
//        SimpleGrantedAuthority authoritiesList = new SimpleGrantedAuthority();
//
//        List<Roles> roles = rolesRepository.findAllByUserID(_user.getId());
//        for (Roles rol: roles) {
//            authoritiesList.add(SecurityUtils.convertToAuthority(rol.getNombre()));  ;
//        }




        Set<GrantedAuthority> authorities = Set.of(SecurityUtils.convertToAuthority("ADMIN"));
//        String username, String password, Collection<? extends GrantedAuthority> authorities
        User user=new User(_user.getUsername(), _user.getPassword(), authorities);

        return UserLogged.builder().user(user)
                .id(_user.getId())
                .username(_user.getUsername())
                .password(_user.getPassword())
                .authorities(authorities)
                .build();
    }
}
