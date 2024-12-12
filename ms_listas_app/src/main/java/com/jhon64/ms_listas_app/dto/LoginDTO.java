package com.jhon64.ms_listas_app.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Data;
// import lombok.Getter;
// import lombok.Setter;
import lombok.NoArgsConstructor;

// @Getter
// @Setter
@Data
@NoArgsConstructor
public class LoginDTO {
   @JsonProperty("usuario")
   String username;
   @JsonProperty("clave")
   String password;
}
