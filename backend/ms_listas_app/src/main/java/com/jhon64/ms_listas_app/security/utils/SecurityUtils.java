package com.jhon64.ms_listas_app.security.utils;

import org.springframework.security.core.authority.SimpleGrantedAuthority;


public class SecurityUtils {
    //para cada authority de sprint debe empezar con role prefix

    public static final String ROLE_PREFIX="ROLE_";


    public static SimpleGrantedAuthority convertToAuthority(String role){
        String formattedRole =role.startsWith(ROLE_PREFIX)?role:ROLE_PREFIX+role;
        return new SimpleGrantedAuthority(formattedRole);
    }

}
