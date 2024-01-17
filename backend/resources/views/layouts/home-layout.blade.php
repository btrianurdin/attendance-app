@extends('layouts.layout')

@section('layout-content')
  @php
    $routes = [
        'Dashboard' => [
            [
                'title' => 'Dashboard',
                'icon' => 'grid_view',
                'route' => route('home'),
                'active' => request()->is('/'),
            ],
        ],
        'Data Master' => [
            [
                'title' => 'Data Shift',
                'icon' => 'manage_history',
                'route' => route('shifts.index'),
                'active' => request()->is('shifts*'),
            ],
            [
                'title' => 'Jam Kerja',
                'icon' => 'timelapse',
                'route' => route('working-hours.index'),
                'active' => request()->is('working-hours*'),
            ],
            [
                'title' => 'Lokasi Presensi',
                'icon' => 'share_location',
                'route' => route('locations.index'),
                'active' => request()->is('locations*'),
            ],
            [
                'title' => 'Divisi',
                'icon' => 'group_work',
                'route' => route('divisions.index'),
                'active' => request()->is('divisions*'),
            ],
            [
                'title' => 'Jabatan',
                'icon' => 'clinical_notes',
                'route' => route('positions.index'),
                'active' => request()->is('positions*'),
            ],
        ],
        'Karyawan' => [
            [
                'title' => 'Data Karyawan',
                'icon' => 'people',
                'route' => route('employees.index'),
                'active' => request()->is('employees*'),
            ],
        ],
        'Presensi' => [
            [
                'title' => 'Data Presensi Harian',
                'icon' => 'today',
                'route' => route('attendances.daily'),
                'active' => request()->is('attendances-daily'),
            ],
            [
                'title' => 'Semua Data Presensi',
                'icon' => 'calendar_month',
                'route' => route('attendances.index'),
                'active' => request()->is('attendances*') && !request()->is('attendances-daily'),
            ],
        ],
        'Izin & Cuti' => [
            [
                'title' => 'Pengajuan Izin',
                'icon' => 'chronic',
                'route' => route('leaves.index'),
                'active' => request()->is('leaves*'),
            ],
            [
                'title' => 'Pengajuan Cuti',
                'icon' => 'overview',
                'route' => route('annual_leaves.index'),
                'active' => request()->is('annual_leaves*'),
            ],
        ],
    ];
  @endphp
  <div class="flex">
    <div class="max-h-screen overflow-y-auto w-[320px] flex-shrink-0 bg-primary text-white">
      <div class="h-screen mb-10">
        <div class="text-center p-6 py-10 text-2xl font-semibold">
          PRESENSI ADMIN
        </div>
        <div class="p-6">
          @foreach ($routes as $key => $route)
            <div class="text-base font-medium">{{ $key }}</div>
            <div class="sidebar-menu">
              @foreach ($route as $item)
                <a href="{{ $item['route'] }}" class="sidebar-menu-item {{ $item['active'] ? 'is-active' : '' }}">
                  <span class="material-symbols-outlined">
                    {{ $item['icon'] }}
                  </span>
                  <span class="font-medium text-base">{{ $item['title'] }}</span>
                </a>
              @endforeach
            </div>
          @endforeach
        </div>
      </div>
    </div>

    <div class="w-full max-h-screen overflow-y-auto">
      <div class="p-6 py-5 bg-white sticky top-0 shadow-lg w-full z-40">
        <div class="flex justify-between items-center">
          <div class="text-base breadcrumbs [&_li]:before:!opacity-80">
            <ul>
              @php
                $breadcrumbs = explode('.', $breadcrumbs ?? 'Dashboard');
              @endphp
              @foreach ($breadcrumbs as $item)
                <li>{{ $item }} </li>
              @endforeach
            </ul>
          </div>
          <div class="flex items-center">
            <div class="dropdown dropdown-end">
              <label tabindex="0" class="cursor-pointer m-1">
                <span class="material-symbols-outlined">
                  person
                </span>
              </label>
              <ul tabindex="0" class="dropdown-content menu p-2 shadow bg-base-100 rounded-lg gap-3 w-52">
                <li>
                  <a href="{{ route('settings.index') }}">
                    <span class="material-symbols-outlined">
                      settings
                    </span>
                    Settings
                  </a>
                </li>
                <li>
                  <a href="{{ route('logout') }}">
                    <span class="material-symbols-outlined">
                      exit_to_app
                    </span>
                    Logout
                  </a>
                </li>
              </ul>
            </div>
          </div>
        </div>
      </div>
      <div class="p-6">
        @yield('content')
      </div>
    </div>
  </div>
@endsection

@push('scripts')
  @include('vendor.sweetalert.alert')
  <script>
    $(document).ready(function() {
      $('.is-numeric').on('input', function() {
        var input = $(this).val();
        $(this).val(input.replace(/[^0-9]/g, ''));
      });
    });
  </script>
@endpush
