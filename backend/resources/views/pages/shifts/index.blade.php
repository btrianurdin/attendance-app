@extends('layouts.home-layout', [
    'breadcrumbs' => 'Data Shift.Daftar',
])

@section('content')
  <div class="card">
    <div class="card-body">
      <h2 class="card-title">Daftar Shift</h2>
      <div class="mt-5">
        <a href="{{ route('shifts.create') }}" class="btn btn-primary">
          <span class="material-symbols-outlined">
            add
          </span>
          Tambah Shift
        </a>
        <div class="overflow-x-auto mt-5">
          <table class="table table-zebra w-full rounded-lg overflow-hidden">
            <!-- head -->
            <thead>
              <tr>
                <th></th>
                <th>Nama Shift</th>
                <th>Maks. Waktu Terlambat</th>
                <th>Loleransi Waktu Presensi</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              @foreach ($shifts as $shift)
                <tr>
                  <td>{{ $loop->index + 1 }}</td>
                  <td>{{ $shift->name }}</td>
                  <td>{{ $shift->max_absence_time }} menit</td>
                  <td>{{ $shift->late_tolerance }} menit</td>
                  <td class="w-[10%]">
                    <a href="{{ route('shifts.edit', $shift->id) }}" class="btn btn-info btn-sm p-0 px-3 text-white">
                      Edit
                    </a>
                    <a href="{{ route('shifts.destroy', $shift->id) }}" class="btn btn-error btn-sm p-0 px-3 text-white"
                      data-confirm-delete="true">Hapus</a>
                  </td>
                </tr>
              @endforeach
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
@endsection
