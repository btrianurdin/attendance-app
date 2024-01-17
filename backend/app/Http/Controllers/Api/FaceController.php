<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Face;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;

class FaceController extends Controller
{
    public function index()
    {
        $faces = Auth::user()->employee->faces;

        if ($faces->count() == 0) {
            return response()->json([
                'status' => 'success',
                'message' => 'karyawan belum melakukan aktivasi wajah',
            ], 404);
        }

        $faces = $faces->map(function ($item) {
            return $item->face_code;
        });

        return response()->json([
            'status' => 'success',
            'message' => 'berhasil mengambil data wajah',
            'data' => [
                "faces" => $faces
            ],
        ], 200);
    }

    public function store(Request $request)
    {
        // check if user already has face data
        if (Auth::user()->employee->faces->count() > 0) {
            return response()->json([
                'status' => 'success',
                'message' => 'data wajah sudah di aktivasi',
            ], 400);
        }

        $faces = collect($request->face_code);

        $faceData = $faces->map(function ($item) {
            return [
                'face_code' => json_encode($item),
                'employee_id' => Auth::user()->employee->id,
                'created_at' => now(),
                'updated_at' => now()
            ];
        });

        try {
            // create database transaction to insert data
            DB::transaction(function () use ($faceData) {
                Face::insert($faceData->toArray());

                // update status in employees table
                Auth::user()->employee->update([
                    'status' => 'active'
                ]);
            });

            return response()->json([
                'status' => 'success',
                'message' => 'berhasil aktivasi data wajah',
                'data' => [
                    "faces" => json_encode($faces),
                ]
            ], 200);
        } catch (\Throwable $th) {
            return response()->json([
                'status' => 'success',
                'message' => 'gagal aktivasi data wajah',
                'error' => $th->getMessage(),
            ], 400);
        }
    }
}
