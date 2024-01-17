<?php

namespace App\Http\Controllers;

use App\Models\Division;
use Illuminate\Http\Request;
use RealRashid\SweetAlert\Facades\Alert;

class DivisionsController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $divisions = Division::all();
        if (function_exists('confirmDelete')) {
            confirmDelete('Hapus Divisi', 'Apakah anda yakin ingin menghapus divisi?');
        }
        return view('pages.divisions.index', compact('divisions'));
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        return view('pages.divisions.create');
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $request->validate([
            'division_name' => 'required|string|max:255|unique:divisions,name',
        ], [
            'division_name.unique' => 'Nama divisi sudah terdaftar.',
            'division_name.required' => 'Nama divisi tidak boleh kosong.'
        ]);

        try {
            Division::create([
                'name' => $request->division_name,
            ]);

            Alert::success('Berhasil menambah divisi.', 'Sistem berhasil menambah divisi');
            return redirect()->route('divisions.index');
        } catch (\Throwable $th) {
            Alert::error('Gagal menambah divisi.', 'Sistem gagal menambah divisi');
            return redirect()->route('divisions.create');
        }
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
        $division = Division::findOrFail($id);
        return view('pages.divisions.edit', compact('division'));
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        $request->validate([
            'division_name' => 'required|string|max:255|unique:divisions,name,' . $id,
        ], [
            'division_name.unique' => 'Nama divisi sudah terdaftar.',
            'division_name.required' => 'Nama divisi tidak boleh kosong.'
        ]);

        try {
            Division::findOrFail($id)->update([
                'name' => $request->division_name,
            ]);

            Alert::success('Berhasil mengubah divisi.', 'Sistem berhasil mengubah divisi');
            return redirect()->route('divisions.index');
        } catch (\Throwable $th) {
            Alert::error('Gagal mengubah divisi.', 'Sistem gagal mengubah divisi');
            return redirect()->route('divisions.edit', $id);
        }
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        try {
            Division::findOrFail($id)->delete();

            Alert::success('Berhasil menghapus divisi.', 'Sistem berhasil menghapus divisi');
            return redirect()->route('divisions.index');
        } catch (\Throwable $th) {
            Alert::error('Gagal menghapus divisi.', 'Sistem gagal menghapus divisi');
            return redirect()->route('divisions.index');
        }
    }
}
