@extends('layouts.home-layout', [
    'breadcrumbs' => 'Data Divisi.Edit Data',
])

@section('content')
  <div class="card">
    <div class="card-body">
      <h2 class="card-title">Edit Data Divisi</h2>
      <div class="mt-10 w-1/2">
        <form method="post" action="{{ route('divisions.update', $division->id) }}">
          @csrf
          @method('PUT')
          <div class="mb-5">
            <label class="form-label">Nama Divisi</label>
            <input type="text" name="division_name" placeholder="Masukkan nama divisi"
              class="text-field  @error('division_name') ?? is-error @enderror"
              value="{{ old('division_name', $division->name) }}" />
            @error('division_name')
              <div class="validation-error">{{ $message }}</div>
            @enderror
          </div>
          <button class="btn btn-primary">Simpan Perubahan</button>
        </form>
      </div>
    </div>
  </div>
@endsection
