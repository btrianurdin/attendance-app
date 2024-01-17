<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Attendance;
use App\Models\Shift;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class AttendanceController extends Controller
{
    public function checkin(Request $request)
    {
        try {
            Attendance::create([
                'employee_id' => Auth::user()->employee->id,
                'date' => Carbon::now(),
                'check_in' => Carbon::now(),
                'status' => !$request->is_late ? 'PRESENT' : 'LATE',
            ]);

            return response()->json([
                'status' => 'success',
                'message' => 'presensi masuk success',
            ], 200);
        } catch (\Throwable $th) {
            return response()->json([
                'status' => 'error',
                'message' => 'presensi masuk gagal',
                'error' => $th->getMessage(),
            ], 400);
        }
    }

    public function checkout(Request $request)
    {
        try {
            Attendance::where('id', $request->attendance_id)->update([
                'check_out' => Carbon::now(),
                'work_hour' => $request->diff,
            ]);

            return response()->json([
                'status' => 'successs',
                'message' => 'presensi keluar berhasil',
            ], 200);
        } catch (\Throwable $th) {
            return response()->json([
                'status' => 'error',
                'message' => 'presensi keluar gagal',
                'error' => $th->getMessage(),
            ], 400);
        }
    }

    public function today()
    {
        $startDay = Carbon::now('Asia/Jakarta')->startOfDay()->setTimezone('UTC');
        $endDay = Carbon::now('Asia/Jakarta')->endOfDay()->tz('UTC');

        $attendance = Attendance::where('date', ">=", $startDay)
            ->where('date', "<=", $endDay)
            ->where('employee_id', Auth::user()->employee->id)
            ->first();

        $shift = Shift::with('shiftDetails')->where('id', Auth::user()->employee->position->shift_id)->first();

        $dayOfWeek = Carbon::now()->setTimezone('Asia/Jakarta')->dayOfWeek;
        $today = $dayOfWeek === 0 ? 6 : $dayOfWeek - 1;
        $shiftToday = $shift->shiftDetails[$today];

        $attendanceResult = [];

        if ($attendance) {
            $attendanceResult = [
                'id' => $attendance->id,
                'date' => $attendance->date,
                'check_in' => $attendance->check_in,
                'check_out' => $attendance->check_out,
                'work_hour' => $attendance->work_hour,
                'status' => $attendance->status,
                'employee_id' => $attendance->employee_id,
            ];
        }

        return response()->json([
            'status' => 'success',
            'data' => [
                ...$attendanceResult,
                'shift' => $shiftToday,
            ],
        ], 200);
    }

    public function history()
    {
        // get history attendance by employee_id in 7 days and order by date desc
        $attendance = Attendance::where('employee_id', Auth::user()->employee->id)->whereDate('date', '>=', Carbon::now()->subDays(7))->orderBy('date', 'desc')->get();

        return response()->json([
            'status' => 'success',
            'data' => $attendance,
        ], 200);
    }

    public function precheckin()
    {
        $employeeLocation = Auth::user()->employee->location;
        $employeeFaces = Auth::user()->employee->faces;
        $faces = $employeeFaces->map(function ($item) {
            return $item->face_code;
        });

        return response()->json([
            'status' => 'success',
            'data' => [
                'location' => $employeeLocation,
                'faces' => $faces,
            ],
        ], 200);
    }

    public function precheckout()
    {
        $employeeLocation = Auth::user()->employee->location;
        $employeeFaces = Auth::user()->employee->faces;
        $faces = $employeeFaces->map(function ($item) {
            return $item->face_code;
        });

        return response()->json([
            'status' => 'success',
            'data' => [
                'location' => $employeeLocation,
                'faces' => $faces,
            ],
        ], 200);
    }
}
