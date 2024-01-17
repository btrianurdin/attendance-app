@extends('layouts.home-layout', [
    'breadcrumbs' => 'Data Presensi.Detail Presensi',
])

@section('content')
  <div class="card mb-6">
    <div class="card-body">
      <h2 class="card-title">Detail Data Presensi</h2>
      <div class="mt-5">
        <div class="mb-7 flex flex-col gap-8">
          <a href="{{ route('attendances.index') }}" class="flex items-center gap-2 text-gray-500">
            <span class="material-symbols-outlined">
              arrow_back
            </span>
            Kembali
          </a>
          <div class="flex items-center gap-10">
            <div>
              Presensi Tanggal
              <h5 class="font-bold text-xl">
                {{ $attendance->read_date }}
              </h5>
            </div>
            <div>
              Status Presensi
              <h5 class="font-bold text-xl text-white text-center">
                @if ($attendance->read_status == 'HADIR')
                  <div class="bg-primary rounded-full py-1 px-3">HADIR</div>
                @elseif($attendance->read_status == 'TERLAMBAT')
                  <div class="bg-red-500 rounded-full py-1 px-3">TERLAMBAT</div>
                @else
                  <div class="bg-warning rounded-full py-1 px-3">{{ $attendance->read_status }}</div>
                @endif
              </h5>
            </div>
          </div>
        </div>
        <div class="flex gap-4 !w-full">
          <img src="{{ asset($attendance->employee->profile_pic ?? 'pictures/default-pic.jpg') }}"
            class="w-[350px] h-[350px] rounded-lg object-cover object-center" />
          <div class="w-full">
            <h6 class="font-semibold border-b border-b-gray-300 pb-4">Data Karyawan</h6>
            <table class="table table-zebra mt-4 !w-full">
              <thead>
                <tr>
                  <td class="w-[20%] !font-normal text-base">Nama</td>
                  <td class="!font-medium text-base">
                    <a href="{{ route('employees.show', $attendance->employee->id) }}" class="underline text-primary">
                      {{ $attendance->employee->user->name }}
                    </a>
                  </td>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td>Jabatan</td>
                  <td>{{ $attendance->employee->position->name }}</td>
                </tr>
                <tr>
                  <td>Divisi</td>
                  <td>{{ $attendance->employee->position->division->name }}</td>
                </tr>
              </tbody>
            </table>
            <h6 class="font-semibold border-b border-b-gray-300 pb-4 mt-4">Data Presensi</h6>
            <table class="table table-zebra mt-4 !rounded-none !w-full">
              <thead>
                <tr>
                  <th>Jam Masuk</th>
                  <th>Jam Pulang</th>
                  <th>Total Jam</th>
                  <th>Lokasi Presensi</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td>{{ $attendance->check_in ?? '-' }}</td>
                  <td>{{ $attendance->check_out ?? '-' }}</td>
                  <td>{{ $attendance->work_hour ? $attendance->work_hour . ' jam' : '-' }}</td>
                  <td>{{ $attendance->employee->location->name }}</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  </div>
@endsection
