@extends('layouts.home-layout', [
    'breadcrumbs' => 'Data Divisi.Daftar',
])

@section('content')
  <div class="card">
    <div class="card-body">
      <h2 class="card-title">Daftar Divisi</h2>
      <div class="mt-5">
        <a href="{{ route('divisions.create') }}" class="btn btn-primary">
          <span class="material-symbols-outlined">
            add
          </span>
          Tambah Divisi
        </a>
        <div class="overflow-x-auto mt-5">
          <table class="table table-zebra w-full rounded-lg overflow-hidden">
            <!-- head -->
            <thead>
              <tr>
                <th></th>
                <th>Nama Divisi</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              @foreach ($divisions as $division)
                <tr>
                  <td>{{ $loop->index + 1 }}</td>
                  <td>{{ $division->name }}</td>
                  <td>
                    <a href="{{ route('divisions.edit', $division->id) }}"
                      class="btn btn-info btn-sm p-0 px-3 text-white">
                      Edit
                    </a>
                    <a href="{{ route('divisions.destroy', $division->id) }}"
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
