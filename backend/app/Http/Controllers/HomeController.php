<?php

namespace App\Http\Controllers;

use App\Models\Attendance;
use App\Models\Division;
use App\Models\Employee;
use App\Models\Location;
use App\Models\Position;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class HomeController extends Controller
{
    public function index()
    {
        // count total employee, division, posision, and location
        $total_employee = Employee::count();
        $total_division = Division::count();
        $total_position = Position::count();
        $total_location = Location::count();

        // make it to object
        $total = json_decode(json_encode([
            'employee' => $total_employee,
            'division' => $total_division,
            'position' => $total_position,
            'location' => $total_location,
        ]));

        // count total attendance by date now
        $total_attendance = Attendance::whereDate('date', date('Y-m-d'))->count();
        // $total_attendance = Employee::whereHas('attendances', function ($query) {
        //     $query->whereDate('date', date('Y-m-d'));
        // })->count();

        // total attendance by date now and status is LATE
        $total_late = Attendance::whereDate('date', date('Y-m-d'))->where('status', 'LATE')->count();
        // $total_late = Employee::whereHas('attendances', function ($query) {
        //     $query->whereDate('date', date('Y-m-d'))->where('status', 'LATE');
        // })->count();

        // total attendance by date now and status is SICK_LEAVE or LEAVE
        $total_sick_leave = Attendance::whereDate('date', date('Y-m-d'))->where('status', 'SICK_LEAVE')->orWhere('status', 'LEAVE')->count();
        // $total_sick_leave = Employee::whereHas('attendances', function ($query) {
        //     $query->whereDate('date', date('Y-m-d'))->where('status', 'SICK_LEAVE')->orWhere('status', 'LEAVE');
        // })->count();

        // total attendance by date now and status is ANNUAL_LEAVE
        $total_annual_leave = Attendance::whereDate('date', date('Y-m-d'))->where('status', 'ANNUAL_LEAVE')->count();
        // $total_annual_leave = Employee::whereHas('attendances', function ($query) {
        //     $query->whereDate('date', date('Y-m-d'))->where('status', 'ANNUAL_LEAVE');
        // })->count();

        $startDate = Carbon::now()->startOfMonth();
        $endDate = Carbon::now()->endOfMonth();

        $attendanceData = Attendance::select(
            DB::raw('DATE(date) AS day'),
            DB::raw('COUNT(*) AS daily_attendance')
        )
            ->where(function ($query) {
                $query->where('status', 'PRESENT')
                    ->orWhere('status', 'LATE');
            })
            ->whereBetween('date', [$startDate, $endDate])
            ->groupBy('day')
            ->orderBy('day')
            ->get();

        $chartData = [];
        $currentDate = $startDate;

        while (
            $currentDate <= $endDate
        ) {
            $formattedDate = $currentDate->format('Y-m-d');
            $chartData[$formattedDate] = 0;
            $currentDate->addDay();
        }

        foreach ($attendanceData as $data) {
            $day = Carbon::createFromFormat('Y-m-d', $data->day)->format('Y-m-d');
            $chartData[$day] = $data->daily_attendance;
        }


        return view('pages.home', compact('total', 'total_attendance', 'total_late', 'total_sick_leave', 'total_annual_leave', 'chartData'));
    }
}
