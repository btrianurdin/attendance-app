@extends('layouts.home-layout', [
    'breadcrumbs' => 'Data Karyawan.Tambah Data',
])

@php
  $createData = [
      [
          [
              'type' => 'text',
              'name' => 'nip',
              'label' => 'NIP',
              'required' => true,
          ],
          [
              'type' => 'text',
              'name' => 'employee_name',
              'label' => 'Nama Lengkap',
              'required' => true,
          ],
          [
              'type' => 'email',
              'name' => 'email',
              'label' => 'Email',
              'required' => true,
          ],
          [
              'type' => 'text',
              'name' => 'phone',
              'label' => 'No. Handphone',
              'required' => true,
          ],
          [
              'type' => 'password',
              'name' => 'password',
              'label' => 'Password',
              'required' => true,
          ],
      ],
      [
          [
              'type' => 'date',
              'name' => 'birthdate',
              'label' => 'Tanggal Lahir',
              'required' => false,
          ],
          [
              'type' => 'textarea',
              'name' => 'address',
              'label' => 'Alamat Lengkap',
              'required' => false,
          ],
          [
              'type' => 'select',
              'name' => 'position_id',
              'label' => 'Jabatan',
              'select_data' => $positions,
              'required' => true,
          ],
  
          [
              'type' => 'select',
              'name' => 'location_id',
              'label' => 'Lokasi Presensi',
              'select_data' => $locations,
              'required' => true,
          ],
      ],
  ];
@endphp

@section('content')
  <div class="card">
    <div class="card-body">
      <h2 class="card-title">Tambah Data Karyawan</h2>
      <div class="mt-10">
        <form method="post" action="{{ route('employees.store') }}" enctype="multipart/form-data">
          @csrf
          <div class="w-[300px] mx-auto mb-10">
            <div
              class="upload-photo overflow-hidden w-full h-[300px] flex items-center border border-gray-300 rounded-lg justify-center relative
              group">
              <img src="" class="relative z-10 w-full h-full object-cover object-center hidden" />
              <div class="absolute flex flex-col items-center">
                <span class="material-symbols-outlined">
                  upload
                </span>
                Unggah Foto
              </div>
              <input type="file" name="profile_pic" class="w-full h-full opacity-0" />
              <div
                class="img-remove hidden absolute shadow-lg z-20 w-10 h-10 items-center justify-center rounded-full bg-white cursor-pointer">
                <span class="material-symbols-outlined">
                  delete
                </span>
              </div>
            </div>
            <span class="text-xs text-warning">Ekstensi yang diizinkan: png, jpg, jpeg</span>
            @error('profile_pic')
              <div class="validation-error">{{ $message }}</div>
            @enderror
          </div>
          <div class="grid grid-cols-2 gap-8">
            @foreach ($createData as $items)
              <div>
                @foreach ($items as $item)
                  <div class="mb-5">
                    <label class="form-label">{{ $item['type'] === 'select' ? 'Pilih' : '' }} {{ $item['label'] }}
                      {{ !$item['required'] ? '(opsional)' : '' }}</label>

                    @if (!in_array($item['type'], ['textarea', 'select']))
                      <input type="{{ $item['type'] }}" name="{{ $item['name'] }}"
                        placeholder="Masukkan {{ strtolower($item['label']) }}"
                        class="text-field  @error($item['name']) ?? is-error @enderror"
                        value="{{ old($item['name']) }}" />
                      @error($item['name'])
                        <div class="validation-error">{{ $message }}</div>
                      @enderror
                    @elseif ($item['type'] === 'textarea')
                      <textarea name="{{ $item['name'] }}" rows="5" placeholder="Masukkan {{ strtolower($item['label']) }}"
                        class="text-field  @error($item['name']) ?? is-error @enderror" value="{{ old($item['name']) }}"></textarea>
                      @error($item['name'])
                        <div class="validation-error">{{ $message }}</div>
                      @enderror
                    @elseif ($item['type'] === 'select')
                      <select name="{{ $item['name'] }}" class="select @error($item['name']) is-error @enderror">>
                        <option value="" selected>Silahkan pilih {{ strtolower($item['label']) }}</option>
                        @foreach ($item['select_data'] as $data)
                          <option value="{{ $data->id }}" @selected(old($item['name']) == $data->id)>{{ $data->name }}
                          </option>
                        @endforeach
                      </select>
                      @error($item['name'])
                        <div class="validation-error">{{ $message }}</div>
                      @enderror
                    @endif
                  </div>
                @endforeach
              </div>
            @endforeach
          </div>
          <button class="btn btn-primary">Tambah Karyawan</button>
        </form>
      </div>
    </div>
  </div>
@endsection

@push('scripts')
  <script>
    $('[name=nip]').addClass("is-numeric");

    // function base64toFile(dataurl) {
    //   let arr = dataurl.split(',');
    //   let mime = arr[0].match(/:(.*?);/)[1];
    //   let bstr = atob(arr[1]);
    //   let n = bstr.length;
    //   let u8arr = new Uint8Array(n);

    //   while (n--) {
    //     u8arr[n] = bstr.charCodeAt(n);
    //   }

    //   return new File([u8arr], 'profile_pic', {
    //     type: mime
    //   });
    // }

    // function FileListItems(files) {
    //   var b = new ClipboardEvent("").clipboardData || new DataTransfer()
    //   for (var i = 0, len = files.length; i < len; i++) b.items.add(files[i])
    //   return b.files
    // }

    // if ($('[name=profile_pic_base64]').val() !== '') {
    //   $('.upload-photo > img').removeClass('hidden');
    //   $('.upload-photo > img').attr('src', $('[name=profile_pic_base64]').val());
    //   $('.upload-photo > .img-remove').addClass('group-hover:flex');
    //   const file = base64toFile($('[name=profile_pic_base64]').val())
    //   $('.upload-photo > input[type=file]').prop('files', FileListItems([file]));
    // }

    $('.upload-photo > input[type=file]').on('change', function() {
      let reader = new FileReader();
      let file = this.files[0];

      reader.onload = (event) => {
        // $(this).siblings('input[name=profile_pic_base64]').val(event.target.result);
        $(this).siblings('img').removeClass('hidden');
        $(this).siblings('img').attr('src', event.target.result);
        $(this).siblings('.img-remove').addClass('group-hover:flex');
      }
      reader.readAsDataURL(file);
    });

    $('.img-remove').on('click', function() {
      // $(this).siblings('input[name=profile_pic_base64]').val('');
      $(this).siblings('input[name=profile_pic]').val('');
      $(this).siblings('img').attr('src', '');
      $(this).siblings('img').addClass('hidden');
      $(this).removeClass('group-hover:flex');
    })
  </script>
@endpush
