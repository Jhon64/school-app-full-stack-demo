package com.jhon64.ms_listas_app.dto.response.http;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ResponseAPI<T> {
   private HttpStatus status;
   private T data;

   public ResponseAPI(HttpStatus status, T data) {
      if (status == null) {
         this.status = HttpStatus.OK;
      } else {
         this.status = status;
      }

      this.data = data;
   }

   public ResponseEntity<T> result() {
      return ResponseEntity.status(this.status).body(this.data);
   }
}
