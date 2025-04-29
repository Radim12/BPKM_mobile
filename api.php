<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Backend\ApiPendidikanController;

Route::middleware('auth:api')->get('/user', function (Request $request) {
    return $request->user();
});

Route::group([], function () {
    Route::get('api_pendidikan', [ApiPendidikanController::class, 'getAll']);
    Route::get('api_pendidikan/{id}', [ApiPendidikanController::class, 'getPen']);
    Route::post('api_pendidikan', [ApiPendidikanController::class, 'createPen']);
    Route::put('api_pendidikan/{id}', [ApiPendidikanController::class, 'updatePen']);
    Route::delete('api_pendidikan/{id}', [ApiPendidikanController::class, 'deletePen']);
});

Route::options('api_pendidikan/{any}', function () {
    return response()
        ->header('Access-Control-Allow-Origin', '*')
        ->header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS')
        ->header('Access-Control-Allow-Headers', 'Content-Type, Authorization');
})->where('any', '.*');