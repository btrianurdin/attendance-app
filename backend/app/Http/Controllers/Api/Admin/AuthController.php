<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;

class AuthController extends Controller
{
    // login with email and password
    public function login(Request $request)
    {
        // validate request
        $credentials = $request->only('email', 'password');

        if (Auth::attempt($credentials)) {
            /**
             * @var \App\Models\User $user
             */
            $user = Auth::user();
            $token = $user->createToken('auth_token')->plainTextToken;

            return response()->json([
                'status' => 'success',
                'message' => 'login success',
                'data' => [
                    'user' => $user,
                    'token' => $token
                ]
            ], 200);
        }

        return response()->json([
            'status' => 'error',
            'message' => 'email or password is wrong',
        ], 401);
    }

    public function logout(Request $request)
    {
        // revoke token
        $request->user()->currentAccessToken()->delete();

        return response()->json([
            'status' => 'success',
            'message' => 'logout success',
        ], 200);
    }

    public function register(Request $request)
    {
        // validate request
        $request->validate([
            'name' => 'required|string',
            'email' => 'required|email|unique:users,email',
            'password' => 'required',
            'phone' => 'required|string|unique:users,phone|min:10|max:15',
        ]);

        // create user
        $user = User::create([
            'name' => $request->name,
            'email' => $request->email,
            'role' => 'admin',
            'phone' => $request->phone,
            // hash password
            'password' => Hash::make($request->password)
        ]);

        // create token
        $token = $user->createToken('auth_token')->plainTextToken;

        // return response
        return response()->json([
            'status' => 'success',
            'message' => 'Register success',
            'data' => [
                'user' => $user,
                'token' => $token
            ]
        ], 200);
    }
}
