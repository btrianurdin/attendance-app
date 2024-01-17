<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('attendances', function (Blueprint $table) {
            $table->id();
            $table->date('date');
            $table->time('check_in');
            $table->time('check_out')->nullable();
            $table->smallInteger('work_hour')->nullable();
            $table->enum('status', ['ONTIME', 'LATE']);
            $table->enum('type', ['PRESENT', 'LEAVE', 'SICK_LEAVE', 'ANNUAL_LEAVE']);
            $table->foreignId('employee_id')->constrained();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('attendances');
    }
};
