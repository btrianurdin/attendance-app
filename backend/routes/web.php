<?php

use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "web" middleware group. Make something great!
|
*/

// ROUTE GROUP PREFIX --> /auth/....
Route::prefix('auth')->controller(App\Http\Controllers\AuthController::class)->group(function () {
    // ROUTE GROUP /W NAME --> LOGIN
    Route::middleware(['guest'])->group(function () {
        Route::get('/login', 'index')->name('login');
        Route::post('/login', 'authenticate');
    });
    Route::get('/logout', 'logout')->middleware('auth')->name('logout');
});

Route::middleware(['auth', 'role:admin', 'nocache'])->group(function () {
    Route::get('/', [App\Http\Controllers\HomeController::class, 'index'])->name('home');
    Route::resource('shifts', App\Http\Controllers\ShiftsController::class);
    Route::resource('working-hours', App\Http\Controllers\WorkingHoursController::class);
    Route::resource('divisions', App\Http\Controllers\DivisionsController::class);
    Route::resource('locations', App\Http\Controllers\LocationsController::class);
    Route::resource('positions', App\Http\Controllers\PositionsController::class);
    Route::get('/employees/{id}/nonactive', [App\Http\Controllers\EmployeesController::class, 'nonactive'])->name('employees.nonactive');
    Route::resource('employees', App\Http\Controllers\EmployeesController::class);

    Route::resource('attendances', App\Http\Controllers\AttendancesController::class);
    Route::get('/attendances-daily', [App\Http\Controllers\AttendancesController::class, 'daily'])->name('attendances.daily');

    Route::resource('leaves', App\Http\Controllers\LeavesController::class)->except(['create', 'store', 'update', 'show']);
    Route::get('/leaves/{id}/approve', [App\Http\Controllers\LeavesController::class, 'approve'])->name('leaves.approve');
    Route::get('/leaves/{id}/reject', [App\Http\Controllers\LeavesController::class, 'reject'])->name('leaves.reject');

    Route::resource('annual_leaves', App\Http\Controllers\AnnualLeavesController::class)->except(['create', 'store', 'update', 'show']);
    Route::get('/annual_leaves/{id}/approve', [App\Http\Controllers\AnnualLeavesController::class, 'approve'])->name('annual_leaves.approve');
    Route::get('/annual_leaves/{id}/reject', [App\Http\Controllers\AnnualLeavesController::class, 'reject'])->name('annual_leaves.reject');

    Route::get('/settings', [App\Http\Controllers\SettingsController::class, 'index'])->name('settings.index');
    Route::put('/settings/change-password', [App\Http\Controllers\SettingsController::class, 'changePassword'])->name('settings.change-password');

    Route::prefix('ajax')->group(function () {
        Route::get('/attendances/daily', [App\Http\Controllers\AttendancesController::class, 'ajaxDaily'])->name('ajax.attendances.daily');
    });
});
