@extends('layouts.home-layout', [
    'breadcrumbs' => 'Pengajuan Izin.Daftar Pengajuan Izin',
])

@push('styles')
  <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/jquery.dataTables.min.css">
  <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" />

  <style>
    .dataTables_scroll>.dataTables_scrollBody {
      border-bottom: 0px !important;
    }

    table.dataTable thead th,
    table.dataTable thead td {
      padding: 15px 10px;
      vertical-align: top !important;
    }

    table.dataTable thead th,
    table.dataTable thead td {
      border-bottom: 0px;
      border-bottom-left-radius: 0px !important;
      border-bottom-right-radius: 0px;
    }

    table.dataTable tbody tr td {
      padding: 16px;
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
      <h2 class="card-title">Data Pengajuan Izin Karyawan</h2>
      <div class="mt-5">
        <div class="flex items-center justify-between">
          <div class="grid grid-cols-3 w-3/4 xl:w-[80%] gap-6">
            <div>
              <label class="inline-block mb-2">Cari Karyawan</label>
              <input type="text" class="text-field" id="employeeSearch" placeholder="Cari nama karyawan" />
            </div>
            <div>
              <label class="inline-block mb-2">Tanggal Pengajuan</label>
              <input type="text" name="daterange" class="text-field" placeholder="Masukkan rentang tanggal"
                value="" />
            </div>
            <div>
              <label class="inline-block mb-2">Status</label>
              <ul class="menu menu-vertical lg:menu-horizontal bg-base-200 rounded-box">
                <li><a class="active" data-status="pending">Pending</a></li>
                <li><a data-status="diterima">Diterima</a></li>
                <li><a data-status="ditolak">Ditolak</a></li>
              </ul>

            </div>
          </div>
        </div>
        <div class="overflow-x-auto mt-5">
          <table id="datatable" class="table !w-full !h-full">
            <!-- head -->
            <thead>
              <tr>
                <th class="no-sort"></th>
                <th>Tanggal</th>
                <th>Karyawan</th>
                <th data-searchable="false">Detail Izin</th>
                <th>Status</th>
                <th class="no-sort">Aksi</th>
              </tr>
            </thead>
            <tbody>
              @foreach ($leaves as $leave)
                <tr>
                  <td class="!align-top">{{ $loop->index + 1 }}</td>
                  <td style="width: 15%" class="!align-top">
                    @php
                      $submission_date = \Carbon\Carbon::createFromFormat('Y-m-d H:i:s', $leave->submission_date)->tz('Asia/Jakarta');
                    @endphp
                    {{ $submission_date->locale('id')->translatedFormat('l, d M Y') }}
                    <span class="hidden">|{{ $submission_date }}</span>
                  </td>
                  <td class="!align-top">{{ $leave->employee->user->name }}</td>
                  <td style="width: 30%" class="!align-top">
                    <table>
                      <tr>
                        <td class="w-[25%]">Alasan</td>
                        <td class="w-[5%]">:</td>
                        <td>{{ $leave->reason }}</td>
                      </tr>
                      @foreach ($leave->leaveDetails as $item)
                        <tr>
                          <td class="w-[25%]">
                            @if ($loop->index === 0)
                              Tanggal
                            @endif
                          </td>
                          <td class="w-[5%]"></td>
                          <td>
                            {{ $loop->index + 1 }}.
                            @php
                              $date = \Carbon\Carbon::createFromFormat('Y-m-d H:i:s', $item->date)->tz('Asia/Jakarta');
                            @endphp
                            {{ $date->locale('id')->translatedFormat('D, d M Y') }}
                          </td>
                        </tr>
                      @endforeach
                      <tr>
                        <td class="w-[25%]">Dokumen</td>
                        <td class="w-[5%]">:</td>
                        <td>
                          @if ($leave->document === null)
                            <span class="text-xs">Tidak ada dokumen</span>
                          @else
                            <a href="{{ asset('/documents' . $leave->document) }}" target="_blank"
                              class="badge badge-primary">Lihat dokumen</a>
                          @endif
                        </td>
                      </tr>
                    </table>
                  </td>
                  <td style="width: 15%" class="!align-top">
                    @if ($leave->status === 'PENDING')
                      <span class="badge badge-warning">Pending</span>
                    @elseif ($leave->status === 'APPROVED')
                      <span class="badge badge-success">Diterima</span>
                    @else
                      <span class="badge badge-error text-white">Ditolak</span>
                    @endif
                  </td>
                  <td class="!align-top">
                    <div class="h-[200px]">
                      <div class="dropdown dropdown-end">
                        <label tabindex="0" class="btn btn-sm p-0 px-3 m-1">Aksi</label>
                        <ul tabindex="0" class="dropdown-content menu p-2 shadow bg-base-100 rounded-box w-52">
                          <li><a href="{{ route('leaves.approve', $leave->id) }}" data-act="approve">Terima</a></li>
                          <li><a href="{{ route('leaves.reject', $leave->id) }}" data-act="reject">Tolak</a></li>
                          <li><a href="{{ route('leaves.destroy', $leave->id) }}" class="text-red-500"
                              data-confirm-delete="true">Hapus</a>
                          </li>
                        </ul>
                      </div>
                    </div>
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
  <script type="text/javascript" src="https://cdn.jsdelivr.net/momentjs/latest/moment.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.4/locale/id.min.js"></script>
  <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js"></script>
  <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/moment-timezone/0.5.33/moment-timezone-with-data.min.js"></script>
  <script>
    $('[data-act]').on('click', function(e) {
      e.preventDefault();

      const act = $(this).attr('data-act');

      Swal.fire({
        title: act === 'approve' ? 'Terima Pengajuan' : 'Tolak Pengajuan',
        text: act === 'approve' ? 'Anda yakin ingin menerima pengajuan ini?' :
          'Anda yakin ingin menolak pengajuan ini?',
        icon: 'question',
        showCancelButton: true,
        confirmButtonColor: '#0f766e',
        cancelButtonColor: '#6e7881',
        confirmButtonText: act === 'approve' ? 'Terima' : 'Tolak',
      }).then((result) => {
        if (result.isConfirmed) {
          window.location.href = $(this).attr('href');
        }
      });
    })

    const datatable = $('#datatable').DataTable({
      scrollX: true,
      scrollY: false,
      // searching: false,
      'columnDefs': [{
        'targets': "no-sort",
        /* column index */
        'orderable': false,
        /* true or false */
      }]
    });

    $.fn.dataTable.ext.search.push(
      function(settings, data, dataIndex, row) {
        const rangePicker = $('input[name="daterange"]');
        const minDate = rangePicker.attr('data-start-date');
        const maxDate = rangePicker.attr('data-end-date');
        const date = data[1].split('|')[1];

        if (minDate && maxDate) {
          return moment(date, 'YYYY-MM-DD').isBetween(minDate, maxDate, null, '[]');
        }
        return true;
      }
    );

    $('#datatable_length').find('label select[name=datatable_length]').addClass('select');
    $('#employeeSearch').on('keyup', function() {
      datatable.column(2).search(this.value).draw();
    });

    $('input[name="daterange"]').daterangepicker({
      opens: 'left',
      autoUpdateInput: false,
      locale: {
        cancelLabel: 'Clear'
      }
    });

    $('input[name="daterange"]').on('apply.daterangepicker', function(ev, picker) {
      $(this).val(`${picker.startDate.format('DD MMM YYYY')} - ${picker.endDate.format('DD MMM YYYY')}`)
      $(this).attr('data-start-date', picker.startDate.format('YYYY-MM-DD'));
      $(this).attr('data-end-date', picker.endDate.format('YYYY-MM-DD'));
      datatable.draw();
    });

    $('input[name="daterange"]').on('cancel.daterangepicker', function(ev, picker) {
      $(this).val('');
      $(this).attr('data-start-date', '');
      $(this).attr('data-end-date', '');
      datatable.draw();
    });

    $('[data-status]').on('click', function() {
      let status = $(this).attr('data-status');
      $('[data-status]').removeClass('active');
      $(this).addClass('active');
      datatable.column(4).search(status).draw();
    });
    datatable.column(4).search('Pending').draw();
  </script>
@endpush
