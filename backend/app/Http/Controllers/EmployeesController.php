<?php

namespace App\Http\Controllers;

use App\Models\Employee;
use App\Models\Face;
use App\Models\Location;
use App\Models\Position;
use App\Models\Shift;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Storage;
use RealRashid\SweetAlert\Facades\Alert;

class EmployeesController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        // get all employee with user, position, and location, the last join position with division
        $employees = Employee::with('user', 'position', 'location', 'position.division')->get();
        $positions = Position::all();
        return view('pages.employees.index', compact('employees', 'positions'));
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        $positions = Position::all();
        $locations = Location::all();

        return view('pages.employees.create', compact('positions', 'locations'));
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $request->validate([
            'nip' => 'required|numeric|unique:employees,nip',
            'employee_name' => 'required|string',
            'email' => 'required|email|unique:users,email',
            'phone' => 'required|unique:users,phone',
            'password' => 'required|string',
            'position_id' => 'required|exists:positions,id',
            'location_id' => 'required|exists:locations,id',
            'profile_pic' => 'nullable|image|mimes:jpg,jpeg,png|max:2048',
        ], [
            '*.required' => 'Kolom :attribute harus diisi.'
        ], [
            'employee_name' => 'nama lengkap',
            'phone' => 'no. handphone',
            'position_id' => 'jabatan',
            'location_id' => 'lokasi presensi'
        ]);

        $path = null;
        if ($request->file('profile_pic') != null) {
            $path = Storage::putFile('pictures', $request->file('profile_pic'));
        }

        try {
            DB::transaction(function () use ($request, $path) {
                $user = User::create([
                    'name' => $request->employee_name,
                    'email' => $request->email,
                    'phone' => $request->phone,
                    'password' => Hash::make($request->password),
                    'role' => 'employee',
                ]);

                Employee::create([
                    'nip' => $request->nip,
                    'birthdate' => $request->birthdate ?? null,
                    'address' => $request->address ?? null,
                    'position_id' => $request->position_id,
                    'location_id' => $request->location_id,
                    'user_id' => $user->id,
                    'profile_pic' => $path,
                    'status' => 'inactive'
                ]);
            });

            Alert::success('Berhasil menambah karyawan.', 'Sistem berhasil menambah karyawan');
            return redirect()->route('employees.index');
        } catch (\Throwable $th) {
            dd($th);
        }
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $employee = Employee::with('user', 'position', 'location', 'position.division')->findOrFail($id);
        if (function_exists('confirmDelete')) {
            confirmDelete('Hapus Karyawan', 'Apakah anda yakin ingin menghapus karyawan?');
        }
        return view('pages.employees.show', compact('employee'));
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
        $employee = Employee::with('user', 'position', 'location', 'position.division')->findOrFail($id);
        $positions = Position::all();
        $locations = Location::all();

        // function convertImagetoBase64($url)
        // {
        //     $urlParts = pathinfo($url);
        //     $extension = $urlParts['extension'];

        //     $base64 = 'data:image/' . $extension . ';base64,' . base64_encode(file_get_contents($url));
        //     return $base64;
        // }

        // if ($employee->profile_pic != null) {
        //     $employee->profile_pic = convertImagetoBase64(public_path($employee->profile_pic));
        // }

        return view('pages.employees.edit', compact('employee', 'positions', 'locations'));
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        $employee = Employee::findOrFail($id);

        $request->validate([
            'nip' => 'required|numeric|unique:employees,nip,' . $id,
            'employee_name' => 'required|string',
            'email' => 'required|email|unique:users,email,' . $employee->user_id . ',id',
            'phone' => 'required|unique:users,phone,' . $employee->user_id . ',id',
            'password' => 'nullable|string',
            'position_id' => 'required|exists:positions,id',
            'location_id' => 'required|exists:locations,id',
            'profile_pic' => 'nullable|image|mimes:jpg,jpeg,png|max:2048',
        ], [
            '*.required' => 'Kolom :attribute harus diisi.'
        ], [
            'employee_name' => 'nama lengkap',
            'phone' => 'no. handphone',
            'position_id' => 'jabatan',
            'location_id' => 'lokasi presensi'
        ]);

        $path = null;
        if ($request->is_remove == 'false' && $request->file('profile_pic') != null) {
            if ($employee->profile_pic != null) {
                Storage::delete($employee->profile_pic);
            }
            $path = Storage::putFile('pictures', $request->file('profile_pic'));
        }

        if ($request->is_remove == 'true') {
            // remove profile pic from storage if exists and remove from database
            if ($employee->profile_pic != null) {
                Storage::delete($employee->profile_pic);
            }
        }

        try {
            DB::transaction(function () use ($request, $id, $path) {
                $employee = Employee::findOrFail($id);
                $employee->nip = $request->nip;
                $employee->birthdate = $request->birthdate ?? null;
                $employee->address = $request->address ?? null;
                $employee->position_id = $request->position_id;
                $employee->location_id = $request->location_id;
                $employee->profile_pic = $path;
                $employee->save();

                $user = User::findOrFail($employee->user_id);
                $user->name = $request->employee_name;
                $user->email = $request->email;
                $user->phone = $request->phone;
                $user->save();
            });

            Alert::success('Berhasil mengubah karyawan.', 'Sistem berhasil mengubah karyawan');
            return redirect()->route('employees.show', $id);
        } catch (\Throwable $th) {
            Alert::error('Gagal mengubah karyawan.', 'Sistem gagal mengubah karyawan');
            return redirect()->route('employees.edit', $id)->withInput();
        }
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        // remove user & employee by employee id
        $employee = Employee::findOrFail($id);
        $user = User::findOrFail($employee->user_id);
        $employee->delete();
        $user->delete();

        Alert::success('Berhasil menghapus karyawan.', 'Sistem berhasil menghapus karyawan');
        return redirect()->route('employees.index');
    }

    /**
     * Make non-active employee.
     */
    public function nonactive(Request $request, string $id)
    {
        try {
            DB::transaction(function () use ($id) {
                $employee = Employee::findOrFail($id);
                $employee->status = 'inactive';
                $employee->save();

                Face::where('employee_id', $id)->delete();
            });

            Alert::success('Berhasil menonaktifkan karyawan.', 'Sistem berhasil menonaktifkan karyawan');
            return redirect()->route('employees.show', $id);
        } catch (\Throwable $th) {
            dd($th);
            Alert::error('Gagal menonaktifkan karyawan.', 'Sistem gagal menonaktifkan karyawan');
            return redirect()->route('employees.show', $id);
        }
    }
}
