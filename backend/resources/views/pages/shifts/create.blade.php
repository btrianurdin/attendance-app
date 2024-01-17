@extends('layouts.home-layout', [
    'breadcrumbs' => 'Data Shift.Tambah Data',
])

@section('content')
  <div class="card">
    <div class="card-body">
      <h2 class="card-title">Tambah Data Shift</h2>
      <div class="mt-10 w-1/2">
        <form method="post" action="{{ route('shifts.store') }}">
          @csrf
          <div class="mb-5">
            <label class="form-label">Nama Shift</label>
            <input type="text" name="name" placeholder="Masukkan nama shift"
              class="text-field  @error('name') ?? is-error @enderror" value="{{ old('name') }}" />
            @error('name')
              <div class="validation-error">{{ $message }}</div>
            @enderror
          </div>
          <div class="mb-5">
            <label class="form-label">Maksimal Waktu Keterlambatan (menit)</label>
            <div class="relative">
              <input type="text" name="max_absence_time" placeholder="Masukkan maksimal waktu keterlambatan"
                class="text-field is-numeric @error('max_absence_time') ?? is-error @enderror" value="{{ old('max_absence_time') }}" />
              <div class="tooltip tooltip-info absolute top-3 right-3"
                data-tip="Waktu maksimal sistem menerima data presensi pegawai">
                <label class="text-gray-300">
                  <span class="material-symbols-outlined">
                    info
                  </span>
                </label>
              </div>
            </div>
            @error('max_absence_time')
              <div class="validation-error">{{ $message }}</div>
            @enderror
          </div>
          <div class="mb-5">
            <label class="form-label">Toleransi Waktu Terlambat (menit)</label>
            <div class="relative">
              <input type="text" name="late_tolerance" placeholder="Masukkan toleransi waktu terlambat"
                class="text-field is-numeric  @error('late_tolerance') ?? is-error @enderror" value="{{ old('late_tolerance') }}" />
              <div class="tooltip tooltip-info absolute top-3 right-3"
                data-tip="Waktu toleransi sebelum sistem memberikan status terlambat pada pegawai">
                <label class="text-gray-300">
                  <span class="material-symbols-outlined">
                    info
                  </span>
                </label>
              </div>
            </div>
            @error('late_tolerance')
              <div class="validation-error">{{ $message }}</div>
            @enderror
          </div>
          <button class="btn btn-primary">Tambah Shift</button>
        </form>
      </div>
    </div>
  </div>
@endsection
