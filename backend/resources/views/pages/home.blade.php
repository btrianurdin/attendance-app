@extends('layouts.home-layout')

@section('content')
  <h1 class="my-5 text-xl font-medium">Data Umum</h1>
  <div class="grid grid-cols-4 gap-8">
    <div class="bg-white p-6 flex gap-4 rounded-lg shadow-md items-center">
      <div>
        <span class="material-symbols-outlined text-6xl">
          group
        </span>
      </div>
      <div>
        <h2 class="font-semibold">Jumlah Karyawan</h2>
        <h1 class="font-bold text-2xl mt-2">{{ $total->employee }} <span class="font-normal text-xl">orang</span></h1>
      </div>
    </div>

    <div class="bg-white p-6 flex gap-4 rounded-lg shadow-md items-center">
      <div>
        <span class="material-symbols-outlined text-6xl">
          group_work
        </span>
      </div>
      <div>
        <h2 class="font-semibold">Jumlah Divisi</h2>
        <h1 class="font-bold text-2xl mt-2">{{ $total->division }} <span class="font-normal text-xl">divisi</span></h1>
      </div>
    </div>

    <div class="bg-white p-6 flex gap-4 rounded-lg shadow-md items-center">
      <div>
        <span class="material-symbols-outlined text-6xl">
          clinical_notes
        </span>
      </div>
      <div>
        <h2 class="font-semibold">Jumlah Jabatan</h2>
        <h1 class="font-bold text-2xl mt-2">{{ $total->position }} <span class="font-normal text-xl">posisi</span></h1>
      </div>
    </div>

    <div class="bg-white p-6 flex gap-4 rounded-lg shadow-md items-center">
      <div>
        <span class="material-symbols-outlined text-6xl">
          home_pin
        </span>
      </div>
      <div>
        <h2 class="font-semibold">Kantor/Cabang</h2>
        <h1 class="font-bold text-2xl mt-2">{{ $total->location }} <span class="font-normal text-xl">divisi</span></h1>
      </div>
    </div>
  </div>

  <h1 class="mt-10 text-xl font-medium">Data Presensi Harian</h1>
  <div class="mt-3 mb-5 text-lg"> {{ \Carbon\Carbon::now()->locale('id')->translatedFormat('l, d F Y') }} </div>
  <div class="grid grid-cols-4 gap-8">
    <div class="bg-white p-6 flex gap-4 rounded-lg shadow-md items-center">
      <div>
        <span class="material-symbols-outlined text-6xl">
          today
        </span>
      </div>
      <div>
        <h2 class="font-semibold">Jumlah Kehadiran</h2>
        <h1 class="font-bold text-2xl mt-2">{{ $total_attendance }}</h1>
      </div>
    </div>
    <div class="bg-white p-6 flex gap-4 rounded-lg shadow-md items-center">
      <div>
        <span class="material-symbols-outlined text-6xl">
          event_busy
        </span>
      </div>
      <div>
        <h2 class="font-semibold">Karyawan Terlambat</h2>
        <h1 class="font-bold text-2xl mt-2">{{ $total_late }}</h1>
      </div>
    </div>
    <div class="bg-white p-6 flex gap-4 rounded-lg shadow-md items-center">
      <div>
        <span class="material-symbols-outlined text-6xl">
          free_cancellation
        </span>
      </div>
      <div>
        <h2 class="font-semibold">Karyawan Izin</h2>
        <h1 class="font-bold text-2xl mt-2">{{ $total_sick_leave }}</h1>
      </div>
    </div>
    <div class="bg-white p-6 flex gap-4 rounded-lg shadow-md items-center">
      <div>
        <span class="material-symbols-outlined text-6xl">
          date_range
        </span>
      </div>
      <div>
        <h2 class="font-semibold">Karyawan Cuti</h2>
        <h1 class="font-bold text-2xl mt-2">{{ $total_annual_leave }}</h1>
      </div>
    </div>
  </div>

  <h1 class="mt-10 text-xl font-medium">Grafik Total Kehadiran Bulan Ini</h1>
  <div class="bg-white p-3 mt-4 rounded-md shadow-lg">
    <canvas id="attendanceChart"></canvas>
  </div>
@endsection

@push('scripts')
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
  <script>
    var chartData = @json($chartData);

    var labels = Object.keys(chartData).map((key) => {
      return key.split('-')[2];
    });
    var data = Object.values(chartData);

    console.log(chartData);

    var ctx = document.getElementById('attendanceChart').getContext('2d');
    var attendanceChart = new Chart(ctx, {
      type: 'bar',
      data: {
        labels: labels,
        datasets: [{
          label: 'Total Kehadiran',
          data: data,
          backgroundColor: 'rgba(75, 192, 192, 0.2)',
          borderColor: 'rgba(75, 192, 192, 1)',
          borderWidth: 1
        }]
      },
      options: {
        scales: {
          y: {
            beginAtZero: true,
            precision: 0,
            stepSize: 3,
            scaleLabel: {
              display: true,
              labelString: 'Jumlah Kehadiran'
            },
            title: {
              display: true,
              text: 'Total Kehadiran',
              color: '#000',
              font: {
                size: 18,
                lineHeight: 1.2,
              },
              padding: {
                top: 10,
                left: 0,
                right: 0,
                bottom: 20
              }
            }
          },
          x: {
            title: {
              display: true,
              text: 'Tanggal',
              color: '#000',
              font: {
                size: 18,
                lineHeight: 1.2,
              },
              padding: {
                top: 10,
                left: 0,
                right: 0,
                bottom: 20
              }
            }
          }
        },
      }
    });
  </script>
@endpush
