<?php

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Attendance extends Model
{
    use HasFactory;

    protected $fillable = [
        'employee_id',
        'date',
        'check_in',
        'check_out',
        'status',
        'work_hour'
    ];

    public function todayWithEmployee($employee_id)
    {
        $today = Carbon::now()->setTimezone('Asia/Jakarta')->toDateString();
        return $this->whereDate('date', $today)->where('employee_id', $employee_id);
    }

    public function employee()
    {
        return $this->belongsTo(Employee::class);
    }
}
