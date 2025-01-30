package com.jhon64.ms_listas_app.models.dto.response.http;

import lombok.Getter;
import lombok.Setter;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

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
      ResponseAPI<T> response=new ResponseAPI<T>(this.status,this.data);
      return (ResponseEntity<T>) ResponseEntity.status(this.status).body(response);
   }
}
