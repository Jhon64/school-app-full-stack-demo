package com.jhon64.ms_listas_app.models.dto.response.usuario;

import com.jhon64.ms_listas_app.models.entities.Roles;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Date;
import java.util.List;


@Getter
@Setter
@NoArgsConstructor
public class LoginResponseDTO {
   private String username;
   private String password;
   private String fullName;
   private String token;
   private List<Roles> roles;
   private Date expiredDate;
   long userID;

   
}
