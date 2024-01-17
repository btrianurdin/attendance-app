<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;

class ScheduleController extends Controller
{
    public function index()
    {
        // get shiftDetails from employee.position.shift.shiftDetails
        $shiftDetails = auth()->user()->employee->position->shift->shiftDetails;

        // day name in indonesian, start at monday
        $dayNames = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];

        // add day names to shiftDetails
        foreach ($shiftDetails as $key => $shiftDetail) {
            $shiftDetail->day_name = $dayNames[$key];
        }

        return response()->json([
            'status' => 'success',
            'data' => $shiftDetails
        ]);
    }
}
