<?php

namespace App\Http\Controllers;

use App\Models\Shift;
use Illuminate\Http\Request;
use RealRashid\SweetAlert\Facades\Alert;

class ShiftsController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $shifts = Shift::all();

        if (function_exists('confirmDelete')) {
            confirmDelete('Hapus shift', 'Apakah anda yakin ingin menghapus shift?');
        }
        return view('pages.shifts.index', compact('shifts'));
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        return view('pages.shifts.create');
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'max_absence_time' => 'required|integer|min:0',
            'late_tolerance' => 'required|integer|min:0',
        ]);

        try {
            Shift::create($request->all());

            Alert::success('Berhasil menambah shift.', 'Sistem berhasil menambah shift');
            return redirect()->route('shifts.index');
        } catch (\Throwable $th) {
            Alert::error('Gagal menambah shift.', 'Sistem gagal menambah shift');
            return redirect()->route('shifts.create');
        }
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
        $shift = Shift::findOrFail($id);
        return view('pages.shifts.edit', compact('shift'));
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'max_absence_time' => 'required|integer|min:0',
            'late_tolerance' => 'required|integer|min:0',
        ]);

        try {
            $shift = Shift::findOrFail($id);
            $shift->update($request->all());

            Alert::success('Berhasil mengubah shift.', 'Sistem berhasil mengubah shift');
            return redirect()->route('shifts.index');
        } catch (\Throwable $th) {
            Alert::error('Gagal mengubah shift.', 'Sistem gagal mengubah shift');
            return redirect()->route('shifts.edit', $id);
        }
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        try {
            $shift = Shift::findOrFail($id);
            $shift->delete();

            Alert::success('Berhasil menghapus shift.', 'Sistem berhasil menghapus shift');
            return redirect()->route('shifts.index');
        } catch (\Throwable $th) {
            Alert::error('Gagal menghapus shift.', 'Sistem gagal menghapus shift');
            return redirect()->route('shifts.index');
        }
    }
}
