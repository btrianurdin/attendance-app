@extends('layouts.home-layout', [
    'breadcrumbs' => 'Jam Kerja.Daftar',
])

@section('content')
  <div class="card">
    <div class="card-body">
      <h2 class="card-title">Daftar Jam Kerja</h2>
      <div class="mt-5">
        <a href="{{ route('working-hours.create') }}" class="btn btn-primary">
          <span class="material-symbols-outlined">
            add
          </span>
          Tambah Jam Kerja
        </a>
        <div class="overflow-x-auto mt-5">
          <table class="table table-zebra w-full rounded-lg overflow-hidden [&_th]:!text-center">
            <!-- head -->
            <thead>
              <tr>
                <th></th>
                <th>Nama Shift</th>
                <th>Senin</th>
                <th>Selasa</th>
                <th>Rabu</th>
                <th>Kamis</th>
                <th>Jumat</th>
                <th>Sabtu</th>
                <th>Minggu</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              @foreach ($shiftDetails as $key => $shiftDetail)
                <tr>
                  <td>{{ $loop->index + 1 }}</td>
                  <td>{{ $key }}</td>
                  @foreach ($shiftDetail as $day)
                    <td>
                      <div class="flex items-center gap-2">
                        @if ($day->type === 'WORKDAY')
                          {{ date_format(date_create($day->check_in), 'H:i') }}
                          <span class="material-symbols-outlined text-sm">
                            arrow_right_alt
                          </span>
                          {{ date_format(date_create($day->check_out), 'H:i') }}
                        @else
                          Hari Libur
                        @endif
                      </div>
                    </td>
                  @endforeach
                  <td class="w-[10%]">
                    <a href="{{ route('working-hours.edit', $shiftDetail[0]->shift_id) }}"
                      class="btn btn-info btn-sm p-0 px-3 text-white">
                      Edit
                    </a>
                    <a href="{{ route('working-hours.destroy', $shiftDetail[0]->shift_id) }}"
                      class="btn btn-error btn-sm p-0 px-3 text-white" data-confirm-delete="true">Hapus</a>
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
