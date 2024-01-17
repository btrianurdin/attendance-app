@extends('layouts.home-layout', [
    'breadcrumbs' => 'Data Karyawan.Detail Data',
])

@push('styles')
  <link rel="stylesheet" href="//cdn.jsdelivr.net/npm/sweetalert2@11">
@endpush

@section('content')
  <div class="card">
    <div class="card-body">
      <h2 class="card-title">Detail Data Karyawan</h2>
      <div class="mt-5">
        <div class="flex gap-10">
          <div class="flex-shrink-0">
            <img src="{{ asset($employee->profile_pic ?? 'pictures/default-pic.jpg') }}"
              class="rounded-lg w-[300px] h-[300px]" />
          </div>
          <div class="w-full">
            <h2 class="text-3xl uppercase font-medium border-b border-gray-300 pb-3">{{ $employee->user->name }}</h2>
            <div class="pt-5 grid grid-cols-2 gap-x-10 gap-y-5">
              <div class="flex flex-col gap-6">
                <div class="flex justify-between">
                  <span class="font-medium">NIP:</span>
                  <span>{{ $employee->nip }}</span>
                </div>
                <div class="flex justify-between">
                  <span class="font-medium">Email:</span>
                  <span>{{ $employee->user->email }}</span>
                </div>
                <div class="flex justify-between">
                  <span class="font-medium">No. Handphone:</span>
                  <span>{{ $employee->user->phone }}</span>
                </div>
                <div class="flex justify-between">
                  <span class="font-medium">Tanggal Lahir:</span>
                  <span>{{ $employee->birthdate ?? '-' }}</span>
                </div>
                <div class="flex justify-between">
                  <span class="font-medium">Jabatan:</span>
                  <span class="text-right">{{ $employee->position->name }}</span>
                </div>
              </div>
              <div class="flex flex-col gap-6">
                <div class="flex justify-between">
                  <span class="font-medium">Status:</span>
                  <span>{{ $employee->status }}</span>
                </div>
                <div class="flex justify-between">
                  <span class="font-medium">Penempatan:</span>
                  <span>{{ $employee->location->name }}</span>
                </div>
                <div class="flex justify-between">
                  <span class="font-medium">Divisi:</span>
                  <span>{{ $employee->position->division->name }}</span>
                </div>
                <div class="flex justify-between">
                  <span class="font-medium">Alamat:</span>
                  <span>{{ $employee->address ?? '-' }}</span>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="flex justify-end mt-10 gap-5">
          <a href="{{ route('employees.edit', $employee->id) }}" class="btn btn-info text-white w-[130px]">Edit</a>
          @if ($employee->status === 'active')
            <a href="{{ route('employees.nonactive', $employee->id) }}" class="btn btn-warning text-white w-[150px]"
              id="nonactive-btn">Non-aktifkan</a>
          @endif
          <a href="{{ route('employees.destroy', $employee->id) }}" class="btn btn-error text-white w-[130px]"
            data-confirm-delete="true">Hapus</a>
        </div>
      </div>
    </div>
  </div>
@endsection

@push('scripts')
  <script src="//cdn.jsdelivr.net/npm/sweetalert2@11"></script>
  <script>
    $('#nonactive-btn').on('click', (e) => {
      e.preventDefault()
      // implement sweetalert for confirmation before nonactive employee
      Swal.fire({
        title: 'Non-aktifkan data karyawan',
        text: 'Apakah anda yakin ingin menon-aktifkan karyawan ini',
        icon: 'question',
        confirmButtonColor: '#0e766e',
        showCancelButton: true,
        confirmButtonText: 'Ya, non-aktifkan',
        cancelButtonText: 'Batalkan',
      }).then((result) => {
        if (result.isConfirmed) {
          // this event using tag a, so we need to get href attribute and route to that url
          window.location.href = e.target.href;
        }
      })
    })
  </script>
@endpush
