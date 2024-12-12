package com.jhon64.ms_listas_app.dto.response.http;

public enum StatusCodeResult {
   InternalServer(-1),
   BadRequest(0),
   Success(1);

   public final Integer Value;

   private StatusCodeResult(Integer value) {
      Value = value;
   }
}