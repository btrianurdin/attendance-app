<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class AuthController extends Controller
{
    public function login(Request $request)
    {
        $credentials = $request->only('email', 'password');

        try {
            if (!User::where('email', $request->email)->first()) throw new \Exception('email not found');
            $checkRole = User::where('email', $request->email)->first()->role;

            if ($checkRole === 'employee' && Auth::attempt($credentials)) {
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

            return throw new \Exception('email or password is wrong');
        } catch (\Throwable $th) {
            return response()->json([
                'status' => 'error',
                'message' => 'email or password is wrong',
            ], 400);
        }
    }

    public function logout(Request $request)
    {
        $request->user()->currentAccessToken()->delete();

        return response()->json([
            'status' => 'success',
            'message' => 'logout success',
        ], 200);
    }
}
