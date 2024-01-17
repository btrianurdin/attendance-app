@extends('layouts.home-layout', [
    'breadcrumbs' => 'Data Jabatan.Daftar',
])

@section('content')
  <div class="card">
    <div class="card-body">
      <h2 class="card-title">Daftar Jabatan</h2>
      <div class="mt-5">
        <a href="{{ route('positions.create') }}" class="btn btn-primary">
          <span class="material-symbols-outlined">
            add
          </span>
          Tambah Jabatan
        </a>
        <div class="overflow-x-auto mt-5">
          <table class="table table-zebra w-full rounded-lg overflow-hidden">
            <!-- head -->
            <thead>
              <tr>
                <th></th>
                <th>Nama Jabatan</th>
                <th>Divisi</th>
                <th>Shift</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              @foreach ($positions as $position)
                <tr>
                  <td>{{ $loop->index + 1 }}</td>
                  <td>{{ $position->name }}</td>
                  <td>{{ $position->division->name }}</td>
                  <td>{{ $position->shift->name }}</td>
                  <td>
                    <a href="{{ route('positions.edit', $position->id) }}"
                      class="btn btn-info btn-sm p-0 px-3 text-white">
                      Edit
                    </a>
                    <a href="{{ route('positions.destroy', $position->id) }}"
                      class="btn btn-error btn-sm p-0 px-3 text-white" data-confirm-delete="true">Hapus</a>
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
