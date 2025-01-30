package com.jhon64.ms_listas_app.dto.response.http;

import java.util.Optional;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class ResponseDTO<T> {
   private Integer statusCode;
   private String message;
   private T data;

   public ResponseDTO(Integer statusCode, Optional<String> message, T data) {
      this.statusCode = statusCode;
      this.message = message == null ? "Obteniendo información" : message.toString();
      this.data = data;
   };

  

   public ResponseDTO(Optional<String> message, T data) {
      this.statusCode = StatusCodeResult.Success.Value;
      this.message = message == null ? "Obteniendo información" : message.toString();
      this.data = data;
   };

   public ResponseDTO(T data) {
      this.statusCode = StatusCodeResult.Success.Value;
      this.message = "Obteniendo información";
      this.data = data;
   };

   public ResponseDTO(Integer statusCode, String message) {
      this.statusCode = statusCode;
      this.message = message==null?"":message.toString();

   };

}
