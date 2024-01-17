@extends('layouts.home-layout', [
    'breadcrumbs' => 'Data Lokasi.Tambah Data',
])

@push('styles')
  <script src='https://api.mapbox.com/mapbox-gl-js/v2.15.0/mapbox-gl.js'></script>
  <link href='https://api.mapbox.com/mapbox-gl-js/v2.15.0/mapbox-gl.css' rel='stylesheet' />
@endpush

@section('content')
  <div class="card">
    <div class="card-body">
      <h2 class="card-title">Tambah Data Lokasi</h2>
      <div class="grid grid-cols-2 mt-10 gap-6">
        <form method="post" action="{{ route('locations.store') }}">
          @csrf
          <div class="mb-5">
            <label class="form-label">Nama Lokasi</label>
            <input type="text" name="location_name" placeholder="Masukkan nama lokasi"
              class="text-field  @error('location_name') ?? is-error @enderror" value="{{ old('location_name') }}" />
            @error('location_name')
              <div class="validation-error">{{ $message }}</div>
            @enderror
          </div>
          <div class="mb-5">
            <label class="form-label">Alamat</label>
            <textarea name="address" class="text-field" cols="30" rows="3" placeholder="Masukkan alamat (opsional)">{{ old('address') }}</textarea>
            @error('address')
              <div class="validation-error">{{ $message }}</div>
            @enderror
          </div>
          <div class="mb-5">
            <label class="form-label">Latitude</label>
            <input type="text" name="latitude" placeholder="Masukkan nama lokasi"
              class="text-field  @error('latitude') ?? is-error @enderror" value="{{ old('latitude') }}" />
            @error('latitude')
              <div class="validation-error">{{ $message }}</div>
            @enderror
          </div>
          <div class="mb-5">
            <label class="form-label">longitude</label>
            <input type="text" name="longitude" placeholder="Masukkan nama lokasi"
              class="text-field  @error('longitude') ?? is-error @enderror" value="{{ old('longitude') }}" />
            @error('longitude')
              <div class="validation-error">{{ $message }}</div>
            @enderror
          </div>
          <div class="mb-5">
            <label class="form-label">Maksimal Radius</label>
            <div class="relative">
              <input type="text" name="radius" placeholder="Masukkan maksimal waktu keterlambatan"
                class="text-field is-numeric @error('radius') ?? is-error @enderror" value="{{ old('radius') }}" />
              <div class="tooltip tooltip-info absolute top-3 right-3" data-tip="Maksimal jarak presensi diizinkan">
                <label class="text-gray-300">
                  <span class="material-symbols-outlined">
                    info
                  </span>
                </label>
              </div>
            </div>
            @error('radius')
              <div class="validation-error">{{ $message }}</div>
            @enderror
          </div>
          <button class="btn btn-primary">Tambah Lokasi</button>
        </form>
        <div class="">
          <div class="alert alert-warning">Silahkan pilih lokasi di bawah</div>
          <div class="relative w-full h-[400px] mb-5 rounded-lg overflow-hidden">
            <div id="map" class="absolute right-0 top-0 w-full h-full"></div>
          </div>
        </div>
      </div>
    </div>
  </div>
@endsection

@push('scripts')
  <script>
    const initialLatitude = parseFloat($('input[name="latitude"]').val() || -7.749304);
    const initialLongitude = parseFloat($('input[name="longitude"]').val() || 110.353355);

    mapboxgl.accessToken = 'pk.eyJ1IjoiYnRzdGFyIiwiYSI6ImNrbmFmajdmdjExcDQydnRhZG40eHdzZzEifQ.-P4F07OAUGvGAaX4bJ9K4g';
    const map = new mapboxgl.Map({
      container: 'map',
      style: 'mapbox://styles/mapbox/streets-v12',
      center: [initialLongitude, initialLatitude],
      zoom: 14
    });

    const initialLatitudeMarker = parseFloat($('input[name="latitude"]').val() || 0.000000);
    const initialLongitudeMarker = parseFloat($('input[name="longitude"]').val() || 0.000000);

    const marker = new mapboxgl.Marker({
        color: '#0f766e'
      })
      .setLngLat([initialLongitudeMarker, initialLatitudeMarker])
      .addTo(map);

    map.on("click", (e) => {
      marker.setLngLat(e.lngLat);
      $('input[name="latitude"]').val(e.lngLat.lat);
      $('input[name="longitude"]').val(e.lngLat.lng);
    })
  </script>
@endpush
