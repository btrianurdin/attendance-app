<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\Admin as ApiAdmin;
use App\Http\Controllers\Api as Api;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

/**
 * --------------
 * ADMIN ROUTES
 * --------------
 */

Route::prefix('admin')->group(function () {
    // ADMIN AUTH
    Route::controller(ApiAdmin\AuthController::class)->group(function () {
        Route::post('/register', 'register');
        Route::post('/login', 'login');
        Route::post('/logout', 'logout')->middleware('auth:sanctum');
    });
});

/**
 * --------------
 * USER ROUTES
 * --------------
 */
Route::post('/auth/login', [Api\AuthController::class, 'login']);

Route::middleware('auth:sanctum')->group(function () {
    Route::post('/auth/logout', [Api\AuthController::class, 'logout']);

    Route::get('/attendance', [Api\AttendanceController::class, 'today']);
    Route::get('/attendance/history', [Api\AttendanceController::class, 'history']);

    Route::middleware('presence:in')->group(function () {
        Route::post('/attendance/pre-checkin', [Api\AttendanceController::class, 'precheckin']);
        Route::post('/attendance/checkin', [Api\AttendanceController::class, 'checkin']);
    });

    Route::middleware('presence:out')->group(function () {
        Route::post('/attendance/pre-checkout', [Api\AttendanceController::class, 'precheckout']);
        Route::post('/attendance/checkout', [Api\AttendanceController::class, 'checkout']);
    });

    Route::post('/face', [Api\FaceController::class, 'store']);
    Route::get('/face', [Api\FaceController::class, 'index']);

    Route::put('/profile/password', [Api\ProfileController::class, 'password']);
    Route::resource('profile', Api\ProfileController::class)->only(['index', 'update']);

    Route::post('/leave', [Api\LeaveController::class, 'common']);
    Route::get('/leave', [Api\LeaveController::class, 'commonShow']);
    Route::post('/leave/annual', [Api\LeaveController::class, 'annual']);
    Route::get('/leave/annual', [Api\LeaveController::class, 'annualShow']);

    Route::get('/schedule', [Api\ScheduleController::class, 'index']);
});
