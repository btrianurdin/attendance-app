<?php

namespace App\Http\Controllers;

use App\Models\Division;
use App\Models\Position;
use App\Models\Shift;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use RealRashid\SweetAlert\Facades\Alert;

class PositionsController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {

        $positions = Position::with('division', 'shift')->get();
        if (function_exists('confirmDelete')) {
            confirmDelete('Hapus jabatan', 'Apakah anda yakin ingin menghapus jabatan?');
        }
        return view('pages.positions.index', compact('positions'));
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        $shifts = Shift::all();
        $divisions = Division::all();
        $workingHours = DB::table('shift_details')
            ->join('shifts', 'shift_details.shift_id', '=', 'shifts.id')
            ->select('shift_details.*', 'shifts.name as shift_name', 'shifts.id as shift_id')
            ->get()
            ->groupBy('shift_name');

        return view('pages.positions.create', compact('shifts', 'divisions', 'workingHours'));
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $request->validate([
            'position_name' => 'required|max:255',
            'shift_id' => 'required|integer',
            'division_id' => 'required|integer',
        ], [
            'position_name.required' => 'Kolom :attribute harus diisi.',
            'shift_id.required' => 'Kolom shift harus diisi.',
            'division_id.required' => 'Kolom divisi harus diisi.',
        ]);

        try {
            Position::create([
                'name' => $request->position_name,
                'shift_id' => $request->shift_id,
                'division_id' => $request->division_id,
            ]);

            Alert::success('Berhasil menambah jabatan.', 'Sistem berhasil menambah jabatan');
            return redirect()->route('positions.index');
        } catch (\Throwable $th) {
            Alert::error('Gagal menambah jabatan.', 'Sistem gagal menambah jabatan');
            return redirect()->route('positions.index');
        }
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
        $position = Position::find($id);
        $shifts = Shift::all();
        $divisions = Division::all();
        $workingHours = DB::table('shift_details')
            ->join('shifts', 'shift_details.shift_id', '=', 'shifts.id')
            ->select('shift_details.*', 'shifts.name as shift_name', 'shifts.id as shift_id')
            ->get()
            ->groupBy('shift_name');

        return view('pages.positions.edit', compact('position', 'shifts', 'divisions', 'workingHours'));
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        $request->validate([
            'position_name' => 'required|max:255',
            'shift_id' => 'required|integer',
            'division_id' => 'required|integer',
        ], [
            'position_name.required' => 'Kolom :attribute harus diisi.',
            'shift_id.required' => 'Kolom shift harus diisi.',
            'division_id.required' => 'Kolom divisi harus diisi.',
        ]);

        try {
            Position::where('id', $id)->update([
                'name' => $request->position_name,
                'shift_id' => $request->shift_id,
                'division_id' => $request->division_id,
            ]);

            Alert::success('Berhasil mengubah jabatan.', 'Sistem berhasil mengubah jabatan');
            return redirect()->route('positions.index');
        } catch (\Throwable $th) {
            Alert::error('Gagal mengubah jabatan.', 'Sistem gagal mengubah jabatan');
            return redirect()->route('positions.index');
        }
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        try {
            Position::destroy($id);
            Alert::success('Berhasil menghapus jabatan.', 'Sistem berhasil menghapus jabatan');
            return redirect()->route('positions.index');
        } catch (\Throwable $th) {
            Alert::error('Gagal menghapus jabatan.', 'Sistem gagal menghapus jabatan');
            return redirect()->route('positions.index');
        }
    }
}
