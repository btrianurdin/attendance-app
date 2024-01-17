<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Leave extends Model
{
    use HasFactory;

    protected $fillable = [
        'submission_date',
        'reason',
        'type',
        'status',
        'document',
        'employee_id'
    ];

    public function employee()
    {
        return $this->belongsTo(Employee::class);
    }

    public function leaveDetails()
    {
        return $this->hasMany(LeaveDetail::class);
    }
}
