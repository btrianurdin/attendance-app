<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Leave;
use App\Models\LeaveDetail;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class LeaveController extends Controller
{
    public function common(Request $request)
    {
        $request->validate([
            'dates' => 'required|string',
            'reason' => 'required|string',
            'type' => 'required|string',
            'document' => 'nullable|file|mimes:pdf,png,jpeg,jpg|max:2048',
        ]);

        try {
            $postData = [
                'submission_date' => now(),
                'reason' => $request->reason,
                'type' => $request->type,
                'employee_id' => auth()->user()->employee->id
            ];

            if ($request->hasFile('document')) {
                $file = $request->file('document');
                $fileName = time() . '_' . str_replace(' ', '', $file->getClientOriginalName());
                $file->storeAs('leaves', $fileName);
                $postData['document'] = $fileName;
            }

            DB::transaction(function () use ($postData, $request) {
                $leave = Leave::create($postData);

                $dates = explode(',', $request->dates);

                $dates = array_map(function ($date) use ($leave) {
                    $date = $date . ' 00:00:00';
                    return [
                        'leave_id' => $leave->id,
                        'date' => Carbon::createFromFormat('Y-m-d H:i:s', $date, 'Asia/Jakarta')->tz('UTC')->format('Y-m-d H:i:s'),
                        'created_at' => now(),
                        'updated_at' => now()
                    ];
                }, $dates);

                LeaveDetail::insert($dates);
            });

            return response()->json([
                'status' => 'success',
                'message' => 'Leave request has been sent'
            ], 200);
        } catch (\Throwable $th) {
            return response()->json([
                'status' => 'error',
                'message' => $th->getMessage()
            ], 400);
        }
    }

    public function commonShow()
    {
        $leaves = Leave::with('leaveDetails')
            ->where('employee_id', auth()->user()->employee->id)
            ->where('type', '!=', 'ANNUAL_LEAVE')
            ->orderBy('submission_date', 'desc')
            ->get();

        return response()->json([
            'status' => 'success',
            'data' => $leaves
        ], 200);
    }

    public function annual(Request $request)
    {
        $request->validate([
            'dates' => 'required|string',
        ]);

        try {
            $postData = [
                'submission_date' => now(),
                'type' => 'ANNUAL_LEAVE',
                'employee_id' => auth()->user()->employee->id
            ];

            DB::transaction(function () use ($postData, $request) {
                $leave = Leave::create($postData);

                $dates = explode(',', $request->dates);

                $dates = array_map(function ($date) use ($leave) {
                    $date = $date . ' 00:00:00';
                    return [
                        'leave_id' => $leave->id,
                        'date' => Carbon::createFromFormat('Y-m-d H:i:s', $date, 'Asia/Jakarta')->tz('UTC')->format('Y-m-d H:i:s'),
                        'created_at' => now(),
                        'updated_at' => now()
                    ];
                }, $dates);

                LeaveDetail::insert($dates);
            });

            return response()->json([
                'status' => 'success',
                'message' => 'Leave request has been sent'
            ], 200);
        } catch (\Throwable $th) {
            return response()->json([
                'status' => 'error',
                'message' => $th->getMessage()
            ], 400);
        }
    }

    public function annualShow()
    {
        $leaves = Leave::with('leaveDetails')
            ->where('employee_id', auth()->user()->employee->id)
            ->where('type', 'ANNUAL_LEAVE')
            ->orderBy('submission_date', 'desc')
            ->get();

        return response()->json([
            'status' => 'success',
            'data' => $leaves
        ], 200);
    }
}
