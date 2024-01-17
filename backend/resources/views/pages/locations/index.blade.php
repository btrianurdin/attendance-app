@extends('layouts.home-layout', [
    'breadcrumbs' => 'Data Lokasi.Daftar',
])

@section('content')
  <div class="card">
    <div class="card-body">
      <h2 class="card-title">Daftar Lokasi</h2>
      <div class="mt-5">
        <a href="{{ route('locations.create') }}" class="btn btn-primary">
          <span class="material-symbols-outlined">
            add
          </span>
          Tambah Lokasi
        </a>
        <div class="overflow-x-auto mt-5">
          <table class="table table-zebra w-full rounded-lg overflow-hidden">
            <!-- head -->
            <thead>
              <tr>
                <th></th>
                <th>Nama Lokasi</th>
                <th>Alamat</th>
                <th>Lotitude</th>
                <th>Longitude</th>
                <th>Maks. Radius</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              @foreach ($locations as $location)
                <tr>
                  <td>{{ $loop->index + 1 }}</td>
                  <td>{{ $location->name }}</td>
                  <td>{{ $location->address ?? '-' }}</td>
                  <td>{{ $location->latitude }}</td>
                  <td>{{ $location->longitude }}</td>
                  <td>{{ $location->radius }}</td>
                  <td>
                    <a href="{{ route('locations.edit', $location->id) }}" class="btn btn-info btn-sm p-0 px-3 text-white">
                      Edit
                    </a>
                    <a href="{{ route('locations.destroy', $location->id) }}" class="btn btn-error btn-sm p-0 px-3 text-white"
                      data-confirm-delete="true">Hapus</a>
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
