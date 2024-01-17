@extends('layouts.home-layout', [
    'breadcrumbs' => 'Data Presensi.Data Harian',
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
      <h2 class="card-title">Data Presensi Harian</h2>
      <div class="mt-5">
        <div class="flex items-center justify-between">
          <div class="grid grid-cols-2 w-3/4 xl:w-1/2 gap-6">
            <div>
              <label class="inline-block mb-2">Cari Karyawan</label>
              <input type="text" class="text-field" id="employeeSearch" placeholder="Cari nama karyawan" />
            </div>
            <div>
              <label class="inline-block mb-2">Tanggal Hari Ini</label>
              <div class="flex gap-3">
                <button class="btn btn-primary date-prev text-center">
                  <span class="material-symbols-outlined">
                    arrow_back_ios_new
                  </span>
                </button>
                <input type="text" name="daterange" class="text-field text-center"
                  placeholder="Masukkan rentang tanggal" />
                <button class="btn btn-primary date-next text-center">
                  <span class="material-symbols-outlined">
                    arrow_forward_ios
                  </span>
                </button>
              </div>
            </div>
          </div>
          <div>
            <a href="{{ route('attendances.create') }}" class="btn btn-primary mt-8" id="filterButton">
              <span class="material-symbols-outlined">
                add
              </span>
              Tambah Data
            </a>
          </div>
        </div>
        <div class="overflow-x-auto mt-5">
          <table id="datatable" class="table table-zebra !w-full">
            <!-- head -->
            <thead>
              <tr>
                <th>Tanggal</th>
                <th>Karyawan</th>
                <th data-searchable="false">Jam Masuk</th>
                <th data-searchable="false">Jam Pulang</th>
                <th data-searchable="false">Total Jam</th>
                <th>Status</th>
                <th data-searchable="false" class="no-sort"></th>
              </tr>
            </thead>
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
    // create is document ready function jquery
    $(document).ready(function() {
      moment.locale('id');

      const momentUtc = (str, format = null) => {
        if (!format) return moment.utc(str).tz('Asia/Jakarta');
        return moment.utc(str, format).tz('Asia/Jakarta');
      }

      const datatable = $('#datatable').DataTable({
        ajax: '{{ route('ajax.attendances.daily') }}',
        processing: true,
        columns: [{
            data: 'date',
            render: function(data, type, row, meta) {
              // format date to locale (indonesia)
              return momentUtc(data).format("DD MMM YYYY");
            }
          },
          {
            data: 'employee.user.name',
            render: function(data, type, row, meta) {
              const route = '{{ route('employees.show', ':id') }}'.replace(':id', row.employee.id);
              return `<a href="${route}" class="underline text-primary">${data}</a>`;
            }
          },
          {
            data: 'check_in',
            render: function(data, type, row, meta) {
              if (!data) return '-';
              return momentUtc(data, 'HH:mm:ss').format("HH:mm:ss");
            }
          },
          {
            data: 'check_out',
            render: function(data, type, row, meta) {
              if (!data) return '-';
              return momentUtc(data, 'HH:mm:ss').format("HH:mm:ss");
            }
          },
          {
            data: 'work_hour',
            render: (data) => data ? `${data} jam` : '-'
          },
          {
            data: 'status',
            render: function(data, type, row, meta) {
              const color = {
                'PRESENT': '!bg-primary',
                'LATE': '!bg-red-500',
              }
              if (!attendanceStatus) return;
              if (color[data]) {
                return `<span class="badge border-0 ${color[data]}">${attendanceStatus[data]}</span>`;
              }
              return `<span class="badge border-0 bg-warning">${attendanceStatus[data]}</span>`;
            }
          },
          {
            data: null,
            render: function(data, type, row, meta) {
              const routeDetail = '{{ route('attendances.show', ':id') }}'.replace(':id', row.id);
              const routeDelete = '{{ route('attendances.destroy', ':id') }}'.replace(':id', row.id);
              return `<a href="${routeDetail}" class="btn btn-primary btn-sm p-0 px-3 text-white">Detail</a>
              <a href="${routeDelete}" class="btn btn-error btn-sm p-0 px-3 text-white" data-confirm-delete="true">Hapus</a>`;
            }
          }
        ],
        scrollX: true,
        'columnDefs': [{
          'targets': "no-sort",
          'orderable': false,
        }]
      });

      $.fn.dataTable.ext.search.push(
        function(settings, data, dataIndex, row) {
          const dateRange = $('input[name="daterange"]').attr('data-date');
          const date = momentUtc(row.date).format('YYYY-MM-DD');

          // convert date to locale (indonesia)
          if (!dateRange) return true;
          if (dateRange === date) return true;
          return false;
        }
      );

      $('#datatable_length').find('label select[name=datatable_length]').addClass('select');
      $('#employeeSearch').on('keyup', function() {
        datatable.search(this.value).draw();
      });

      $('input[name="daterange"]').daterangepicker({
        opens: 'left',
        autoUpdateInput: false,
        singleDatePicker: true,
        autoApply: true,
        opens: 'center',
        startDate: moment(),
      });

      // initial daterange value to today with format DD MMM YYYY
      $('input[name="daterange"]').val(moment().format('DD MMM YYYY'));
      $('input[name="daterange"]').attr('data-date', moment().format('YYYY-MM-DD'));

      $('input[name="daterange"]').on('apply.daterangepicker', function(ev, picker) {
        $(this).val(picker.startDate.format('DD MMM YYYY'));
        $(this).attr('data-date', picker.startDate.format('YYYY-MM-DD'));
        datatable.draw();
      });

      $('.date-prev').on('click', function(e) {
        e.preventDefault();
        const date = $('input[name="daterange"]').attr('data-date');
        const prevDate = moment(date, 'YYYY-MM-DD').subtract(1, 'days').format('YYYY-MM-DD');
        $('input[name="daterange"]').val(moment(prevDate, 'YYYY-MM-DD').format('DD MMM YYYY'));
        $('input[name="daterange"]').attr('data-date', prevDate);
        datatable.draw();
      });

      $('.date-next').on('click', function(e) {
        e.preventDefault();
        const date = $('input[name="daterange"]').attr('data-date');
        const nextDate = moment(date, 'YYYY-MM-DD').add(1, 'days').format('YYYY-MM-DD');
        $('input[name="daterange"]').val(moment(nextDate, 'YYYY-MM-DD').format('DD MMM YYYY'));
        $('input[name="daterange"]').attr('data-date', nextDate);
        datatable.draw();
      });

      setInterval(() => {
        datatable.ajax.reload(null, false);
        console.log('reload');
      }, 3000);
    })
  </script>
@endpush
