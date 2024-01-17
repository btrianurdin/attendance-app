<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use RealRashid\SweetAlert\Facades\Alert;

class SettingsController extends Controller
{
    public function index()
    {
        return view('pages.settings.index');
    }

    public function changePassword(Request $request)
    {

        $validated = Validator::make($request->all(), [
            'current_password' => 'required',
            'new_password' => 'required|confirmed',
        ], [
            'current_password.required' => 'Password lama harus diisi',
            'new_password.required' => 'Password baru harus diisi',
            'new_password.confirmed' => 'Password baru tidak cocok',
        ]);

        if ($validated->fails()) {
            return redirect()->back()->withErrors($validated);
        }

        /**
         * @var \App\Models\User $user
         */
        $user = auth()->user();

        if (!Hash::check($request->current_password, $user->password)) {
            return redirect()->back()->withErrors(['current_password' => 'Password lama tidak sesuai']);
        }

        $user->password = bcrypt($request->new_password);
        $user->save();

        Alert::success('Berhasil', 'Password berhasil diubah');
        return redirect()->back();
    }
}
