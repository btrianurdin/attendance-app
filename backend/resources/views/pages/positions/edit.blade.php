@extends('layouts.home-layout', [
    'breadcrumbs' => 'Data Jabatan.Edit Data',
])

@section('content')
  <div class="card">
    <div class="card-body">
      <h2 class="card-title">Edit Data Jabatan</h2>
      <div class="mt-10 w-1/2">
        <form method="post" action="{{ route('positions.update', $position->id) }}">
          @csrf
          @method('PUT')
          <div class="mb-5">
            <label class="form-label">Nama Jabatan</label>
            <input type="text" name="position_name" placeholder="Masukkan nama jabatan"
              class="text-field  @error('position_name') ?? is-error @enderror"
              value="{{ old('position_name', $position->name) }}" />
            @error('position_name')
              <div class="validation-error">{{ $message }}</div>
            @enderror
          </div>
          <div class="mb-5">
            <label class="form-label">Pilih Divisi</label>
            <select name="division_id" class="select @error('division_id') is-error @enderror">>
              <option value="" selected>Silahkan pilih divisi</option>
              @foreach ($divisions as $division)
                <option value="{{ $division->id }}" @selected(old('division_id', $position->division_id) == $division->id)>{{ $division->name }}</option>
              @endforeach
            </select>
            @error('division_id')
              <div class="validation-error">{{ $message }}</div>
            @enderror
          </div>
          <div class="mb-5">
            <label class="form-label">Pilih Shift</label>
            <select name="shift_id" class="select @error('shift_id') is-error @enderror">>
              <option value="" selected>Silahkan pilih shift</option>
              @foreach ($shifts as $shift)
                <option value="{{ $shift->id }}" @selected(old('shift_id', $position->division_id) == $shift->id)>{{ $shift->name }}</option>
              @endforeach
            </select>
            <label for="working-hours-modal" class="text-sm flex items-center pt-2 gap-1 cursor-pointer"
              id="working-hours-visibility">
              <span class="material-symbols-outlined text-base">
                visibility
              </span>
              <p class="underline">Lihat jam kerja</p>
            </label>
            @error('shift_id')
              <div class="validation-error">{{ $message }}</div>
            @enderror
          </div>
          <button class="btn btn-primary">Simpan Perubahan</button>
        </form>
      </div>
    </div>
  </div>

  <input type="checkbox" id="working-hours-modal" class="modal-toggle" />
  <div class="modal">
    <div class="modal-box w-full max-w-5xl">
      <h3 class="font-bold text-lg">Jam Kerja</h3>
      <div class="overflow-x-auto mt-5">
        <table class="table table-zebra w-full bg-gray-300 rounded-lg overflow-hidden [&_th]:!text-center">
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
            @foreach ($workingHours as $key => $shiftDetail)
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
                  <button data-selected-id="{{ $shiftDetail[0]->shift_id }}"
                    class="btn btn-success btn-sm p-0 px-3 text-white">
                    Pilih
                  </button>
                </td>
              </tr>
            @endforeach
          </tbody>
        </table>
      </div>
      <div class="modal-action">
        <label for="working-hours-modal" class="btn">Tutup</label>
      </div>
    </div>
  </div>
@endsection

@push('scripts')
  <script>
    $('[data-selected-id]').on('click', function() {
      console.log($(this).data('selected-id'));
      document.querySelector('[name="shift_id"]').value = $(this).data('selected-id');
      document.querySelector('#working-hours-modal').checked = false;
    })
  </script>
@endpush
