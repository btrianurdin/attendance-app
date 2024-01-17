<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Employee;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;

class ProfileController extends Controller
{
    public function index()
    {
        $employee = Employee::where('user_id', Auth::id())->with('position.division', 'location')->first();
        $employee->name = Auth::user()->name;
        $employee->email = Auth::user()->email;
        $employee->phone = Auth::user()->phone;
        $employee->profile_pic = asset($employee->profile_pic ?? 'pictures/default-pic.jpg');

        return response()->json([
            'status' => 'success',
            'data' => $employee,
        ]);
    }

    public function password(Request $request)
    {
        $validated = Validator::make($request->all(), [
            'current_password' => 'required',
            'new_password' => 'required|confirmed',
        ], [
            'current_password.required' => 'Password lama harus diisi',
            'new_password.required' => 'Password baru harus diisi',
            'new_password.confirmed' => 'Konfirmasi password tidak cocok',
        ]);

        if ($validated->fails()) {
            return response()->json([
                'status' => 'error',
                'message' => $validated->errors()->first(),
            ], 400);
        }


        if (!Hash::check($request->current_password, auth()->user()->password)) {
            return response()->json([
                'status' => 'error',
                'message' => 'Password lama salah',
            ], 400);
        }

        /**
         * @var \App\Models\User $user
         */
        $user = auth()->user();
        $user->password = Hash::make($request->new_password);
        $user->save();

        return response()->json([
            'status' => 'success',
            'message' => 'Password berhasil diubah',
        ]);
    }
}
