<?php

namespace App\Http\Controllers;

use App\Models\Attendance;
use App\Models\Employee;
use Carbon\Carbon;
use Illuminate\Http\Request;
use RealRashid\SweetAlert\Facades\Alert;

class AttendancesController extends Controller
{
    public function index()
    {
        if (function_exists('confirmDelete')) {
            confirmDelete('Hapus Data Kehadiran', 'Apakah anda yakin ingin menghapus data kehadiran?');
        }
        return view('pages.attendances.index');
    }

    public function daily()
    {
        if (function_exists('confirmDelete')) {
            confirmDelete('Hapus Data Kehadiran', 'Apakah anda yakin ingin menghapus data kehadiran?');
        }
        return view('pages.attendances.daily');
    }

    public function show($id)
    {
        $attendance = Attendance::with('employee.user', 'employee.location', 'employee.position.division')->findOrFail($id);

        Carbon::setLocale('id');
        $check_in = Carbon::now('UTC')->toDateString() . ' ' . $attendance->check_in;
        $check_out = Carbon::now('UTC')->toDateString() . ' ' . $attendance->check_out;

        $attendance->read_date = Carbon::createFromFormat('Y-m-d H:i:s', $attendance->date)->setTimezone('Asia/Jakarta')->isoFormat('dddd, D MMMM Y');

        if ($attendance->check_in !== null) {
            $attendance->check_in = Carbon::createFromFormat('Y-m-d H:i:s', $check_in, 'UTC')->setTimezone('Asia/Jakarta')->isoFormat('HH:mm:ss');
        }

        if ($attendance->check_out !== null) {
            $attendance->check_out = Carbon::createFromFormat('Y-m-d H:i:s', $check_out, 'UTC')->setTimezone('Asia/Jakarta')->isoFormat('HH:mm:ss');
        }

        $status = [
            'PRESENT' => 'HADIR',
            'LATE' => 'TERLAMBAT',
            'LEAVE' => 'IZIN',
            'SICK_LEAVE' => 'SAKIT',
            'ANNUAL_LEAVE' => 'CUTI',
        ];

        $attendance->read_status = $status[$attendance->status];

        return view('pages.attendances.show', compact('attendance'));
    }

    public function create()
    {
        $employees = Employee::with('user')->get();

        return view('pages.attendances.create', compact('employees'));
    }

    public function store(Request $request)
    {
        $request->validate([
            'employee_id' => 'required|exists:employees,id',
            'date' => 'required|date',
            'check_in' => 'required|date_format:H:i',
            'check_out' => 'required|date_format:H:i',
            'status' => 'required|in:PRESENT,LATE,LEAVE,SICK_LEAVE,ANNUAL_LEAVE',
        ]);

        try {
            $check_in = Carbon::createFromFormat('Y-m-d H:i', $request->date . ' ' . $request->check_in, 'Asia/Jakarta');
            $check_out = Carbon::createFromFormat('Y-m-d H:i', $request->date . ' ' . $request->check_out, 'Asia/Jakarta');

            // calculate work hours
            if ($check_out->lt($check_in)) {
                $check_out->addDay();
            }
            $work_hours = $check_out->diffInHours($check_in);

            $date = $request->date . ' ' . $check_in->toTimeString();
            $date = Carbon::createFromFormat('Y-m-d H:i:s', $date, 'Asia/Jakarta')->tz('UTC')->format('Y-m-d H:i:s');

            Attendance::create([
                'employee_id' => $request->employee_id,
                'date' => $date,
                'check_in' => $check_in->setTimezone('UTC'),
                'check_out' => $check_out->setTimezone('UTC'),
                'status' => $request->status,
                'work_hour' => $work_hours,
            ]);

            Alert::success('Berhasil menambah data.', 'Sistem berhasil menambah data presensi');
            return redirect()->route('attendances.index');
        } catch (\Throwable $th) {
            Alert::error('Gagal menambah data.', 'Sistem gagal menambah data presensi');
            return redirect()->route('attendances.create');
        }
    }

    public function destroy($id)
    {
        try {
            $attendance = Attendance::findOrFail($id);
            $attendance->delete();

            Alert::success('Berhasil menghapus data.', 'Sistem berhasil menghapus data presensi');
            return redirect()->route('attendances.index');
        } catch (\Throwable $th) {
            Alert::error('Gagal menghapus data.', 'Sistem gagal menghapus data presensi');
            return redirect()->route('attendances.index');
        }
    }

    public function ajaxDaily(Request $request)
    {
        // get all attendance with employee
        $attendances = Attendance::with('employee.user')->orderBy('date', 'desc')->get();
        return response()->json([
            'status' => 'success',
            'data' => $attendances
        ], 200);
    }
}
