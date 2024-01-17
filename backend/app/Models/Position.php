<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Position extends Model
{
    use HasFactory;

    protected $fillable = ['name', 'shift_id', 'division_id'];

    public function division()
    {
        return $this->belongsTo(Division::class);
    }

    public function shift()
    {
        return $this->belongsTo(Shift::class);
    }

    public function employees()
    {
        return $this->hasMany(Employee::class);
    }
}
