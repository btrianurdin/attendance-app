<?php

namespace App\Http\Middleware;

use App\Models\Attendance;
use App\Models\Shift;
use Carbon\Carbon;
use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Symfony\Component\HttpFoundation\Response;

class PresenceCheckMiddleware
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next, ...$type): Response
    {
        if ($type[0] === 'in') {
            // get shift include shift detail by employee.position.shift_id
            $shift = Shift::with('shiftDetails')->where('id', Auth::user()->employee->position->shift_id)->first();

            // inside shiftDetails there is day column that give 0 for monday to 6 for sunday, so we can check if today is working day or not
            $dayOfWeek = Carbon::now()->setTimezone('Asia/Jakarta')->dayOfWeek;
            $today = $dayOfWeek === 0 ? 6 : $dayOfWeek - 1;
            $shiftToday = $shift->shiftDetails[$today];

            if ($shiftToday->type == 'OFFDAY') {
                return response()->json([
                    'status' => 'error',
                    'message' => 'tidak ada shift hari ini'
                ], 400);
            }

            // check if user already presence at table attendance
            $startDay = Carbon::now('Asia/Jakarta')->startOfDay()->setTimezone('UTC');
            $endDay = Carbon::now('Asia/Jakarta')->endOfDay()->tz('UTC');

            $attendance = Attendance::where('date', ">=", $startDay)
                ->where('date', "<=", $endDay)
                ->where('employee_id', Auth::user()->employee->id)
                ->first();

            if ($attendance) {
                return response()->json([
                    'status' => 'error',
                    'message' => 'anda sudah presensi hari ini',
                ], 400);
            }

            // using timezone 'Asia/Jakarta', calculate different between shiftDetail.check_in and now
            $checkIn = Carbon::createFromFormat('H:i:s', $shiftToday->check_in, 'Asia/Jakarta');
            $now = Carbon::now('Asia/Jakarta');
            $diff = $checkIn->diffInMinutes($now, false);

            if (env('APP_ENV') === 'production') {
                if ($diff < 0) {
                    return response()->json([
                        'status' => 'error',
                        'message' => 'belum waktunya presensi'
                    ], 400);
                }

                if ($diff > $shift->max_absence_time) {
                    return response()->json([
                        'status' => 'error',
                        'message' => 'sudah melebihi batas presensi',
                    ], 400);
                }
            }

            $isLate = $diff > $shift->late_tolerance ? true : false;

            $request->merge(['is_late' => $isLate]);

            return $next($request);
        } else if ($type[0] === 'out') {
            // check if user already presence at table attendance
            $startDay = Carbon::now('Asia/Jakarta')->startOfDay()->setTimezone('UTC');
            $endDay = Carbon::now('Asia/Jakarta')->endOfDay()->tz('UTC');

            $attendance = Attendance::where('date', ">=", $startDay)
                ->where('date', "<=", $endDay)
                ->where('employee_id', Auth::user()->employee->id)
                ->first();

            if (!$attendance) {
                return response()->json([
                    'status' => 'error',
                    'message' => 'anda belum melakukan presensi masuk',
                ], 400);
            }

            if ($attendance->check_out) {
                return response()->json([
                    'status' => 'error',
                    'message' => 'anda sudah melakukan presensi keluar',
                ], 400);
            }

            $checkIn = Carbon::createFromFormat('H:i:s', $attendance->check_in);
            $now = Carbon::now();
            $diff = $checkIn->diffInHours($now, false);

            $request->merge(['diff' => $diff, 'attendance_id' => $attendance->id]);

            return $next($request);
        }

        return response()->json([
            'status' => 'error',
            'message' => 'bad request',
        ], 400);
    }
}
