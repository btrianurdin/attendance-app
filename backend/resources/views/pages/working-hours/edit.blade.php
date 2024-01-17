@extends('layouts.home-layout', [
    'breadcrumbs' => 'Jam Kerja.Edit Data',
])

@php
  $days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
@endphp

@section('content')
  <div class="card">
    <div class="card-body">
      <h2 class="card-title">Edit Data Jam Kerja</h2>
      <div class="mt-10">
        <form method="post" action="{{ route('working-hours.update', $shiftDetail[0]->shift_id) }}">
          @csrf
          @method('PUT')
          <div class="mb-5">
            <label class="form-label">Pilih Shift</label>
            <div class="flex w-1/2 gap-6">
              <div class="w-[60%]">
                <select name="shift_id" id="" class="select @error('shift_id') is-error @enderror">
                  <option value="{{ $shiftDetail[0]->shift_id }}">{{ $shiftDetail[0]->name }}</option>
                  @foreach ($shifts as $shift)
                    <option value="{{ $shift->id }}">{{ $shift->name }}</option>
                  @endforeach
                </select>
                @error('shift_id')
                  <div class="validation-error">{{ $message }}</div>
                @enderror
              </div>
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
              @foreach ($shiftDetail as $key => $shift)
                <tr>
                  <td>{{ $days[$shift->day] }}</td>
                  <td>
                    <select name="type[]" class="select choose-type">
                      <option value="WORKDAY" @selected($shift->type === 'WORKDAY')>Hari Kerja</option>
                      <option value="OFFDAY" @selected($shift->type === 'OFFDAY')>Hari Libur</option>
                    </select>
                  </td>
                  <td>
                    <input type="time" name="check_in[]" value="{{ $shift->check_in }}" class="text-field" @disabled($shift->type === 'OFFDAY')>
                  </td>
                  <td>
                    <input type="time" name="check_out[]" value="{{ $shift->check_out }}" class="text-field" @disabled($shift->type === 'OFFDAY')>
                  </td>
                </tr>
              @endforeach
            </tbody>
          </table>
          <button class="btn btn-primary">Simpan Perubahan</button>
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
