@extends('layouts.home-layout', [
    'breadcrumbs' => 'Data Presensi.Tambah Data Presensi',
])

@push('styles')
  <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
  <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
  <style>
    .select2-container .select2-dropdown.select2-dropdown--below {
      margin-top: 4px !important;
      border: 1px solid rgb(209, 213, 219) !important;
    }

    .select2-container .select2-dropdown.select2-dropdown--above {
      margin-top: -8px !important;
      border: 1px solid rgb(209, 213, 219) !important;
    }
  </style>
@endpush

@section('content')
  <div class="card">
    <div class="card-body">
      <h2 class="card-title">Tambah Data Presensi</h2>
      <div class="mt-10 w-1/2">
        <form method="post" action="{{ route('attendances.store') }}">
          @csrf
          <div class="mb-5">
            <label class="form-label">Pilih Karyawan</label>
            <select name="employee_id" class="select select-employee @error('employee_id') is-error @enderror">>
              <option value="" selected>Silahkan pilih karyawan</option>
              @foreach ($employees as $employee)
                <option value="{{ $employee->id }}" @selected(old('employee_id') == $employee->id)>{{ $employee->user->name }}</option>
              @endforeach
            </select>
            @error('employee_id')
              <div class="validation-error">{{ $message }}</div>
            @enderror
          </div>
          <div class="mb-5">
            <label class="form-label">Tanggal</label>
            <input type="date" name="date" class="text-field  @error('date') ?? is-error @enderror"
              value="{{ old('date') }}"  />
            @error('date')
              <div class="validation-error">{{ $message }}</div>
            @enderror
          </div>
          <div class="mb-5">
            <label class="form-label">Jam Masuk</label>
            <input type="time" name="check_in" class="text-field  @error('check_in') ?? is-error @enderror"
              value="{{ old('check_in') }}" />
            @error('check_in')
              <div class="validation-error">{{ $message }}</div>
            @enderror
          </div>
          <div class="mb-5">
            <label class="form-label">Jam Pulang</label>
            <input type="time" name="check_out" class="text-field  @error('check_out') ?? is-error @enderror"
              value="{{ old('check_out') }}" />
            @error('check_out')
              <div class="validation-error">{{ $message }}</div>
            @enderror
          </div>
          <div class="mb-5">
            <label class="form-label">Status Presensi</label>
            <select name="status" class="select @error('status') is-error @enderror">>
              <option value="" selected>Silahkan status presensi</option>
              <option value="PRESENT" @selected(old('status') === 'PRESENT')>Hadir</option>
              <option value="LATE" @selected(old('status') === 'LATE')>Terlambat</option>
              <option value="LEAVE" @selected(old('status') === 'LEAVE')>Izin</option>
              <option value="SICK_LEAVE" @selected(old('status') === 'SICK_LEAVE')>Sakit</option>
              <option value="ANNUAL_LEAVE" @selected(old('status') === 'ANNUAL_LEAVE')>Cuti</option>
            </select>
            @error('status')
              <div class="validation-error">{{ $message }}</div>
            @enderror
          </div>
          <button class="btn btn-primary">Tambah Data Presensi</button>
        </form>
      </div>
    </div>
  </div>
@endsection

@push('scripts')
  <script>
    $('.select-employee').select2();
  </script>
@endpush
