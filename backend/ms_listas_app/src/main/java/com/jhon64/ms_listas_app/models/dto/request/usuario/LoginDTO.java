package com.jhon64.ms_listas_app.models.dto.request.usuario;
// import jakarta.validation.constraints.Email;
// import jakarta.validation.constraints.NotBlank;
// import com.fasterxml.jackson.annotation.JsonProperty;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;
import lombok.NoArgsConstructor;

// @Getter
// @Setter
@Data
@NoArgsConstructor
public class LoginDTO {
    @NotBlank(message = "El nombre es obligatorio")
   String username;
    @NotBlank(message = "El nombre es obligatorio")
   String password;
}
