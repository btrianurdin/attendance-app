@extends('layouts.layout')

@section('layout-content')
  <div class="min-h-screen flex items-center justify-center">
    <div class="w-full md:w-[400px] bg-white shadow-lg rounded-lg p-6">
      <h1 class="text-3xl font-semibold text-center">Login</h1>
      <div class="mt-12">
        <form method="POST" action="{{ route('login') }}">
          @if (session('error'))
            <div class="alert alert-error">
              {{ session('error') }}
            </div>
          @endif
          @csrf
          <div class="mb-5">
            <label class="form-label">Email</label>
            <input type="email" name="email" placeholder="Masukkan email"
              class="text-field  @error('email') ?? is-error @enderror" />
            @error('email')
              <div class="validation-error">{{ $message }}</div>
            @enderror
          </div>
          <div class="mb-5">
            <label class="form-label">Password</label>
            <input type="password" name="password" placeholder="Masukkan password"
              class="text-field @error('password') ?? is-error @enderror" />
            @error('password')
              <div class="validation-error">{{ $message }}</div>
            @enderror
          </div>
          <button class="btn btn-primary w-full">Login</button>
        </form>
      </div>
    </div>
  </div>
@endsection
