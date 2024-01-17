<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class LeaveDetail extends Model
{
    use HasFactory;

    protected $fillable = [
        'date',
        'leave_id'
    ];

    public function leave()
    {
        return $this->belongsTo(Leave::class);
    }
}
