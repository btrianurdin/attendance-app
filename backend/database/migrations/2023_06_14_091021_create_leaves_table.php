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
        Schema::create('leaves', function (Blueprint $table) {
            $table->id();
            $table->dateTime('submission_date');
            // $table->dateTime('date')->nullable();
            // $table->dateTime('end_date')->nullable();
            $table->enum('type', ['LEAVE', 'SICK_LEAVE', 'ANNUAL_LEAVE']);
            $table->string('reason')->nullable();
            $table->string('document')->nullable();
            $table->enum('status', ['APPROVED', 'REJECTED', 'PENDING'])->default('PENDING');
            $table->foreignId('employee_id')->constrained();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('leaves');
    }
};
