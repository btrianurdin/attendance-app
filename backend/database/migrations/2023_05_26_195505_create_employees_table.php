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
        Schema::create('employees', function (Blueprint $table) {
            $table->id();
            $table->char('nip', 16)->unique();
            $table->date('birthdate')->nullable();
            $table->string('profile_pic')->nullable();
            $table->text('address')->nullable();
            $table->enum('status', ['ACTIVE', 'NONACTIVE'])->default('NONACTIVE');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('employees');
    }
};
