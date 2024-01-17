@extends('layouts.home-layout', [
    'breadcrumbs' => 'Jam Kerja.Tambah Data',
])

@php
  $days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
@endphp

@section('content')
  <div class="card">
    <div class="card-body">
      <h2 class="card-title">Tambah Data Jam Kerja</h2>
      <div class="mt-10">
        <form method="post" action="{{ route('working-hours.store') }}">
          @csrf
          <div class="mb-5">
            <label class="form-label">Pilih Shift</label>
            <div class="flex w-1/2 gap-6">
              <div class="w-[60%]">
                <select name="shift_id" id="" class="select @error('shift_id') is-error @enderror">
                  @foreach ($shifts as $shift)
                    <option value="{{ $shift->id }}">{{ $shift->name }}</option>
                  @endforeach
                </select>
                @if (count($shifts) === 0)
                  <div class="validation-error">Tidak ada data data shift, silahkan tambah data shift terlebih dahulu
                  </div>
                @endif
                @error('shift_id')
                  <div class="validation-error">{{ $message }}</div>
                @enderror
              </div>
              @if (count($shifts) === 0)
                <a href="{{ route('shifts.create') }}" class="btn btn-link">Tambah Shift</a>
              @endif
            </div>
          </div>

          <label class="form-label">Tentukan Jadwal</label>
          <table class="table w-full mb-5">
            <thead>
              <tr>
                <th>Hari</th>
                <th>Tipe</th>
                <th>Jam Masuk</th>
                <th>Jam Pulang</th>
              </tr>
            </thead>
            <tbody>
              @foreach ($days as $day)
                <tr>
                  <td>{{ $day }}</td>
                  <td>
                    <select name="type[]" class="select choose-type">
                      <option value="WORKDAY">Hari Kerja</option>
                      <option value="OFFDAY">Hari Libur</option>
                    </select>
                  </td>
                  <td>
                    <input type="time" name="check_in[]" value="08:00" class="text-field">
                  </td>
                  <td>
                    <input type="time" name="check_out[]" value="17:00" class="text-field">
                  </td>
                </tr>
              @endforeach
            </tbody>
          </table>
          <button class="btn btn-primary">Tambah Jam Kerja</button>
        </form>
      </div>
    </div>
  </div>
@endsection

@push('scripts')
  <script>
    $('.choose-type').on('change', function() {
      if ($(this).val() == 'OFFDAY') {
        $(this).parents('tr').find('input[type="time"]').attr('disabled', true).val('');
      } else {
        $(this).parents('tr').find('input[type="time"]').attr('disabled', false);
      }
    })
  </script>
@endpush
