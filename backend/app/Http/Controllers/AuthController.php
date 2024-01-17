<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class AuthController extends Controller
{
    public function index()
    {
        return view('pages.auth.login');
    }

    public function authenticate(Request $request)
    {
        $request->validate([
            'email' => 'required',
            'password' => 'required',
        ], [
            'email.required' => 'Email masih kosong',
            'password.required' => 'Password masing kosong'
        ]);

        $email = $request->email;
        $password = $request->password;

        if (!User::where('email', $email)->first()) {
            return redirect()->back()->with('error', 'Email atau password salah');
        }

        $isAdmin = User::where('email', $email)->first()->role === 'admin';

        if ($isAdmin && Auth::attempt(['email' => $email, 'password' => $password])) {
            return redirect()->intended('/');
        }

        return redirect()->back()->with('error', 'Email atau password salah');
    }

    public function logout(Request $request)
    {
        Auth::logout();
        $request->session()->invalidate();
        $request->session()->regenerateToken();

        return redirect()->intended('/auth/login');
    }
}
