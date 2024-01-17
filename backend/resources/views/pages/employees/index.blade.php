@extends('layouts.home-layout', [
    'breadcrumbs' => 'Data Karyawan.Daftar',
])

@push('styles')
  <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/jquery.dataTables.min.css">
  <style>
    .dataTables_scroll>.dataTables_scrollBody {
      border-bottom: 0px !important;
    }

    table.dataTable thead th,
    table.dataTable thead td {
      padding: 15px 10px;
    }

    table.dataTable thead th,
    table.dataTable thead td {
      border-bottom: 0px;
      border-bottom-left-radius: 0px !important;
      border-bottom-right-radius: 0px;
    }

    .dataTables_wrapper .dataTables_paginate .paginate_button.current,
    .dataTables_wrapper .dataTables_paginate .paginate_button.current:hover {
      color: white !important;
    }

    .dataTables_paginate .paging_simple_numbers {
      margin-top: 20px;
    }

    #datatable_filter {
      display: none;
    }
  </style>
@endpush

@section('content')
  <div class="card">
    <div class="card-body">
      <h2 class="card-title">Daftar Karyawan</h2>
      <div class="mt-5">
        <div class="flex justify-between">
          <div class="grid grid-cols-2 w-1/2 gap-6">
            <input type="text" class="text-field" id="employeeSearch" placeholder="Cari nama karyawan" />
            <select class="select" id="filterPosition">
              <option value="all">Semua Jabatan</option>
              @foreach ($positions as $position)
                <option value="{{ $position->name }}">{{ $position->name }}</option>
              @endforeach
            </select>
          </div>
          <a href="{{ route('employees.create') }}" class="btn btn-primary">
            <span class="material-symbols-outlined">
              add
            </span>
            Tambah Karyawan
          </a>
        </div>
        <div class="overflow-x-auto mt-5">
          <table id="datatable" class="table table-zebra !w-full">
            <!-- head -->
            <thead>
              <tr>
                <th class="no-sort"></th>
                <th data-searchable="false">Foto</th>
                <th>NIP</th>
                <th>Nama</th>
                <th>Jabatan</th>
                <th data-searchable="false">Lokasi Presensi</th>
                <th>Status</th>
                <th class="no-sort"></th>
              </tr>
            </thead>
            <tbody>
              @foreach ($employees as $employee)
                <tr>
                  <td>{{ $loop->index + 1 }}</td>
                  <td>
                    <img src="{{ asset($employee->profile_pic ?? 'pictures/default-pic.jpg') }}"
                      class="w-[80px] rounded-lg" />
                  </td>
                  <td>{{ $employee->nip }}</td>
                  <td>{{ $employee->user->name }}</td>
                  <td>
                    <div class="flex flex-col gap-2">
                      <span>{{ $employee->position->name }}</span>
                      <span class="text-sm">{{ $employee->position->division->name }}</span>
                    </div>
                  </td>
                  <td>{{ $employee->location->name }}</td>
                  <td>{{ $employee->status }}</td>
                  <td>
                    <a href="{{ route('employees.show', $employee->id) }}"
                      class="btn btn-primary btn-sm p-0 px-3 text-white">
                      Detail
                    </a>
                    <a href="{{ route('employees.edit', $employee->id) }}"
                      class="btn btn-info btn-sm p-0 px-3 text-white">
                      Edit
                    </a>
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

@push('scripts')
  <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
  <script>
    const datatable = $('#datatable').DataTable({
      scrollX: true,
      // searching: false,
      'columnDefs': [{
        'targets': "no-sort",
        /* column index */
        'orderable': false,
        /* true or false */
      }]
    });
    $('#employeeSearch').on('keyup', function() {
      // search tabel by colum 2 or 3
      console.log(this.value);
      datatable.search(this.value).draw();
      $('.dataTables_paginate span .paginate_button').addClass("!btn !btn-primary !text-white")
    });
    $('#filterPosition').on('change', function() {
      if (this.value === 'all')
        datatable.column(4).search('').draw();
      else
        datatable.column(4).search(this.value).draw();
      $('.dataTables_paginate span .paginate_button').addClass("!btn !btn-primary !text-white")
    });
    $('#datatable_length').find('label select[name=datatable_length]').addClass('select');
    $('.dataTables_paginate span .paginate_button').addClass("!btn !btn-primary !text-white")
  </script>
@endpush
