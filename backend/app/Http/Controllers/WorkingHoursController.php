<?php

namespace App\Http\Controllers;

use App\Models\Shift;
use App\Models\ShiftDetail;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use RealRashid\SweetAlert\Facades\Alert;

class WorkingHoursController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {

        $shiftDetails = DB::table('shift_details')
            ->join('shifts', 'shift_details.shift_id', '=', 'shifts.id')
            ->select('shift_details.*', 'shifts.name as shift_name', 'shifts.id as shift_id')
            ->get()
            ->groupBy('shift_name');

        if (function_exists('confirmDelete')) {
            confirmDelete('Hapus shift', 'Apakah anda yakin ingin menghapus shift?');
        }
        return view('pages.working-hours.index', compact('shiftDetails'));
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        $shifts = Shift::all()->whereNotIn('id', ShiftDetail::all()->pluck('shift_id'));
        return view('pages.working-hours.create', compact('shifts'));
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $request->validate([
            'shift_id' => 'required',
        ], [
            'shift_id.required' => 'Shift tidak boleh kosong',
        ]);

        $data = [];

        foreach ($request->type as $key => $value) {
            $data[] = [
                'day' => $key,
                'shift_id' => $request->shift_id,
                'type' => $value,
                'check_in' => $request->check_in[$key] ?? null,
                'check_out' => $request->check_out[$key] ?? null,
            ];
        }
        try {
            ShiftDetail::insert($data);
            Alert::success('Berhasil menambah jam kerja', 'Sistem berhasil menambah jam kerja');
            return redirect()->route('working-hours.index');
        } catch (\Throwable $th) {
            Alert::success('Gagal menambah jam kerja', 'Sistem gagal menambah jam kerja');
            return redirect()->route('working-hours.create');
        }
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
        $shiftDetail = DB::table('shifts')
            ->join('shift_details', 'shifts.id', '=', 'shift_details.shift_id')
            ->where('shifts.id', $id)
            ->get();

        $shifts = Shift::all()->whereNotIn('id', ShiftDetail::all()->pluck('shift_id'));

        return view('pages.working-hours.edit', compact('shiftDetail', 'shifts'));
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        $request->validate([
            'shift_id' => 'required',
        ], [
            'shift_id.required' => 'Shift tidak boleh kosong',
        ]);

        $data = [];

        foreach ($request->type as $key => $value) {
            $data[] = [
                'day' => $key,
                'shift_id' => $request->shift_id,
                'type' => $value,
                'check_in' => $request->check_in[$key] ?? null,
                'check_out' => $request->check_out[$key] ?? null,
            ];
        }

        try {
            ShiftDetail::where('shift_id', $id)->delete();
            ShiftDetail::insert($data);
            Alert::success('Berhasil mengubah jam kerja', 'Sistem berhasil mengubah jam kerja');
            return redirect()->route('working-hours.index');
        } catch (\Throwable $th) {
            Alert::success('Gagal mengubah jam kerja', 'Sistem gagal mengubah jam kerja');
            return redirect()->route('working-hours.edit', $id);
        }
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        try {
            ShiftDetail::where('shift_id', $id)->delete();
            Alert::success('Berhasil menghapus jam kerja', 'Sistem berhasil menghapus jam kerja');
            return redirect()->route('working-hours.index');
        } catch (\Throwable $th) {
            Alert::success('Gagal menghapus jam kerja', 'Sistem gagal menghapus jam kerja');
            return redirect()->route('working-hours.index');
        }
    }
}
