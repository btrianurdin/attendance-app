<?php

namespace App\Http\Controllers;

use App\Models\Location;
use Illuminate\Http\Request;
use RealRashid\SweetAlert\Facades\Alert;

class LocationsController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {

        $locations = Location::all();
        if (function_exists('confirmDelete')) {
            confirmDelete('Hapus Lokasi', 'Apakah anda yakin ingin menghapus lokasi?');
        }
        return view('pages.locations.index', compact('locations'));
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        return view('pages.locations.create');
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $request->validate([
            'location_name' => 'required',
            'latitude' => 'required|numeric',
            'longitude' => 'required|numeric',
            'radius' => 'required|numeric'
        ], [
            '*.required' => 'Kolom :attribute harus diisi.',
            '*.numeric' => 'Kolom :attribute harus berupa angka.'
        ]);

        try {
            Location::create([
                'name' => $request->location_name,
                'latitude' => $request->latitude,
                'longitude' => $request->longitude,
                'address' => $request->address,
                'radius' => $request->radius
            ]);

            Alert::success('Berhasil menambah lokasi.', 'Sistem berhasil menambah lokasi');
            return redirect()->route('locations.index');
        } catch (\Throwable $th) {
            dd($th);
            Alert::error('Gagal menambah lokasi.', 'Sistem gagal menambah lokasi');
            return redirect()->route('locations.create');
        }
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
        $location = Location::findOrFail($id);

        return view('pages.locations.edit', compact('location'));
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        $request->validate([
            'location_name' => 'required',
            'latitude' => 'required|numeric',
            'longitude' => 'required|numeric',
            'radius' => 'required|numeric'
        ], [
            '*.required' => 'Kolom :attribute harus diisi.',
            '*.numeric' => 'Kolom :attribute harus berupa angka.'
        ]);

        try {
            $location = Location::findOrFail($id);
            $location->update([
                'name' => $request->location_name,
                'latitude' => $request->latitude,
                'longitude' => $request->longitude,
                'address' => $request->address,
                'radius' => $request->radius
            ]);

            Alert::success('Berhasil mengubah lokasi.', 'Sistem berhasil mengubah lokasi');
            return redirect()->route('locations.index');
        } catch (\Throwable $th) {
            dd($th);
            Alert::error('Gagal mengubah lokasi.', 'Sistem gagal mengubah lokasi');
            return redirect()->route('locations.edit', $id);
        }
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        try {
            $location = Location::findOrFail($id);
            $location->delete();

            Alert::success('Berhasil menghapus lokasi.', 'Sistem berhasil menghapus lokasi');
            return redirect()->route('locations.index');
        } catch (\Throwable $th) {
            Alert::error('Gagal menghapus lokasi.', 'Sistem gagal menghapus lokasi');
            return redirect()->route('locations.index');
        }
    }
}
