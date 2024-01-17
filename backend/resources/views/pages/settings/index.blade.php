@extends('layouts.home-layout', ['breadcrumbs' => 'Profile.Settings'])

@section('content')
  <div class="card md:w-1/2">
    <div class="card-body">
      <h2 class="card-title">Ganti Password</h2>
      <div class="mt-5">
        <form method="post" action="{{ route('settings.change-password') }}">
          @csrf
          @method('PUT')
          <div class="mb-5">
            <label class="form-label">Password Saat Ini</label>
            <input type="password" name="current_password" placeholder="Masukkan password saat ini"
              class="text-field  @error('current_password') ?? is-error @enderror" />
            @error('current_password')
              <div class="validation-error">{{ $message }}</div>
            @enderror
          </div>
          <div class="mb-5">
            <label class="form-label">Password Baru</label>
            <input type="password" name="new_password" placeholder="Masukkan password baru"
              class="text-field  @error('new_password') ?? is-error @enderror" />
            @error('new_password')
              <div class="validation-error">{{ $message }}</div>
            @enderror
          </div>
          <div class="mb-5">
            <label class="form-label">Konfirmasi Password Baru</label>
            <input type="password" name="new_password_confirmation" placeholder="Konfirmasi password baru"
              class="text-field" />
          </div>
          <button class="btn btn-primary">Ganti Password</button>
        </form>
      </div>
    </div>
  </div>
@endsection
