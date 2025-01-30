package com.jhon64.ms_listas_app.models.dto.response.http;

public enum StatusCodeResult {
   InternalServer(500),
   unauthorized(401),//401
   BadRequest(400),
   Success(200);

   public final Integer Value;

   private StatusCodeResult(Integer value) {
      Value = value;
   }
}