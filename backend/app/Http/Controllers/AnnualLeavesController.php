<?php

namespace App\Http\Controllers;

use App\Models\Attendance;
use App\Models\Leave;
use App\Models\LeaveDetail;
use Illuminate\Support\Facades\DB;
use RealRashid\SweetAlert\Facades\Alert;

class AnnualLeavesController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        // get leave with leave details
        $leaves = Leave::with('leaveDetails', 'employee.user')
            ->where('type', 'ANNUAL_LEAVE')
            ->orderBy('submission_date', 'desc')
            ->get();

        if (function_exists('confirmDelete')) {
            confirmDelete('Hapus Izin', 'Apakah anda yakin ingin menghapus pengajuan izin?');
        }
        return view('pages.annual-leaves.index', compact('leaves'));
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        try {
            DB::transaction(function () use ($id) {
                $leave = Leave::findOrFail($id);

                Attendance::where('employee_id', $leave->employee_id)
                    ->whereIn('date', $leave->leaveDetails->pluck('date'))
                    ->where('status', $leave->type)
                    ->delete();

                LeaveDetail::where('leave_id', $id)->delete();
                $leave->delete();
            });

            Alert::success('Berhasil', 'Pengajuan izin berhasil dihapus');
            return redirect()->route('annual_leaves.index');
        } catch (\Throwable $th) {
            Alert::error('Gagal', 'Pengajuan izin gagal dihapus');
            return redirect()->route('annual_leaves.index');
        }
    }

    public function approve(string $id)
    {
        try {

            DB::transaction(function () use ($id) {
                $leave = Leave::findOrFail($id);
                $leave->status = 'APPROVED';
                $leave->save();

                $leaveDetails = LeaveDetail::where('leave_id', $id)->get();

                $attendance = [];

                foreach ($leaveDetails as $leaveDetail) {
                    $attendance[] = [
                        'employee_id' => $leave->employee_id,
                        'date' => $leaveDetail->date,
                        'status' => $leave->type,
                        'created_at' => now(),
                        'updated_at' => now(),
                    ];
                }

                Attendance::insert($attendance);
            });

            Alert::success('Berhasil', 'Pengajuan izin berhasil disetujui');
            return redirect()->route('annual_leaves.index');
        } catch (\Throwable $th) {
            Alert::error('Gagal', 'Pengajuan izin gagal disetujui');
            return redirect()->route('annual_leaves.index');
        }
    }

    public function reject(string $id)
    {
        try {
            DB::transaction(function () use ($id) {
                $leave = Leave::findOrFail($id);
                $leave->status = 'REJECTED';
                $leave->save();

                Attendance::where('employee_id', $leave->employee_id)
                    ->whereIn('date', $leave->leaveDetails->pluck('date'))
                    ->where('status', $leave->type)
                    ->delete();
            });

            Alert::success('Berhasil', 'Pengajuan izin berhasil ditolak');
            return redirect()->route('annual_leaves.index');
        } catch (\Throwable $th) {
            Alert::error('Gagal', 'Pengajuan izin gagal ditolak');
            return redirect()->route('annual_leaves.index');
        }
    }
}
