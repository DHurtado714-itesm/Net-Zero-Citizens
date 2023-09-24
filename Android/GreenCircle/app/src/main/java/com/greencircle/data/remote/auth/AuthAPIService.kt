package com.greencircle.data.remote.auth

import com.greencircle.domain.model.auth.AuthResponse
import retrofit2.http.Body
import retrofit2.http.POST

public interface AuthAPIService {
    data class GoogleLoginRequest(val googleToken: String)

    @POST("auth/login/google")
    suspend fun googleLogin(@Body request: GoogleLoginRequest): AuthResponse
}