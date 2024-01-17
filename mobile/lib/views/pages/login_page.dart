import 'package:flutter/material.dart';
import 'package:presensi_pintar_ta/model/profile_model.dart';
import 'package:presensi_pintar_ta/provider/store_provider.dart';
import 'package:presensi_pintar_ta/provider/stream/auth_stream.dart';
import 'package:presensi_pintar_ta/services/locator/locator.dart';
import 'package:presensi_pintar_ta/utils/theme.dart';
import 'package:presensi_pintar_ta/views/widgets/activation/activation_landing.dart';
import 'package:presensi_pintar_ta/views/widgets/components/button.dart';
import 'package:presensi_pintar_ta/views/widgets/components/text_input.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final form = FormGroup({
    'email': FormControl<String>(value: '', validators: [Validators.required]),
    'password':
        FormControl<String>(value: '', validators: [Validators.required])
  });

  final _authStream = locator<AuthStream>();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<UserStore>().profile;

    if (profile != null) {
      Future.delayed(Duration.zero, () {
        if (profile.status == ProfileStatus.inactive) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const ActivationLanding(),
            ),
            (route) => false,
          );
        } else if (profile.status == ProfileStatus.active) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/layout', (route) => false);
        }
      });
      return const Scaffold();
    }

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(12),
        child: ReactiveForm(
          formGroup: form,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Login',
                style: blackTextStyle.copyWith(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: primaryColor),
              ),
              const SizedBox(height: 30),
              const TextInput(
                controlName: 'email',
                label: 'Email',
              ),
              const SizedBox(height: 15),
              const TextInput(
                controlName: 'password',
                label: 'Password',
                isPassword: true,
              ),
              const SizedBox(height: 20),
              Button(
                isLoading: _isLoading,
                label: 'Login',
                isDisabled: _isLoading,
                onPressed: () async {
                  if (!form.valid) {
                    form.markAllAsTouched();
                    return;
                  }
                  final email = form.control('email').value;
                  final password = form.control('password').value;
                  setState(() {
                    _isLoading = true;
                  });

                  await _authStream.login(email: email, password: password);

                  setState(() {
                    _isLoading = false;
                  });
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
