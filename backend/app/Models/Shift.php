<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Shift extends Model
{
    use HasFactory;

    protected $fillable = [
        'name',
        'max_absence_time',
        'late_tolerance',
    ];

    public function positions()
    {
        return $this->hasMany(Position::class);
    }

    public function shiftDetails()
    {
        return $this->hasMany(ShiftDetail::class);
    }
}
