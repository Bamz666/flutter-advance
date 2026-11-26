import 'dart:async';

import 'package:eatik_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _modeDaftar = false;
  bool _sedangMengirim = false;
  bool _sembunyikanPassword = true;
  String? _pesanError;

  @override
  void dispose() {
    _namaController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _wajib(String? value) {
    return (value == null || value.trim().isEmpty) ? 'Wajib diisi' : null;
  }

  InputDecoration _dekorasi(String label, IconData ikon, {Widget? suffixIcon}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(ikon),
      suffixIcon: suffixIcon,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  Future<void> _kirim() async {
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) return;

    setState(() {
      _sedangMengirim = true;
      _pesanError = null;
    });

    final auth = ref.read(authProvider.notifier);
    final failure = _modeDaftar
        ? await auth.daftar(
            nama: _namaController.text,
            username: _usernameController.text,
            password: _passwordController.text,
          )
        : await auth.masuk(
            username: _usernameController.text,
            password: _passwordController.text,
          );

    // Bila berhasil, AuthGate mengganti halaman ini dan state sudah dibuang.
    if (!mounted) return;
    setState(() {
      _sedangMengirim = false;
      _pesanError = failure?.message;
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final pesan = _pesanError;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(
                      Icons.restaurant_menu_rounded,
                      size: 48,
                      color: scheme.primary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Eatik',
                      textAlign: TextAlign.center,
                      style: textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _modeDaftar
                          ? 'Buat akun baru'
                          : 'Masuk untuk mengelola menu',
                      textAlign: TextAlign.center,
                      style: textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SegmentedButton<bool>(
                      segments: const [
                        ButtonSegment<bool>(value: false, label: Text('Masuk')),
                        ButtonSegment<bool>(value: true, label: Text('Daftar')),
                      ],
                      selected: {_modeDaftar},
                      onSelectionChanged: _sedangMengirim
                          ? null
                          : (pilihan) => setState(() {
                              _modeDaftar = pilihan.first;
                              _pesanError = null;
                            }),
                    ),
                    const SizedBox(height: 20),
                    if (_modeDaftar) ...[
                      TextFormField(
                        controller: _namaController,
                        textInputAction: TextInputAction.next,
                        decoration: _dekorasi(
                          'Nama lengkap',
                          Icons.badge_outlined,
                        ),
                        validator: _wajib,
                      ),
                      const SizedBox(height: 12),
                    ],
                    TextFormField(
                      controller: _usernameController,
                      textInputAction: TextInputAction.next,
                      autocorrect: false,
                      decoration: _dekorasi(
                        'Username',
                        Icons.person_outline_rounded,
                      ),
                      validator: _wajib,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _sembunyikanPassword,
                      decoration: _dekorasi(
                        'Password',
                        Icons.lock_outline_rounded,
                        suffixIcon: IconButton(
                          onPressed: () => setState(
                            () => _sembunyikanPassword = !_sembunyikanPassword,
                          ),
                          icon: Icon(
                            _sembunyikanPassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                      ),
                      validator: _wajib,
                      onFieldSubmitted: (_) => unawaited(_kirim()),
                    ),
                    if (pesan != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        pesan,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: scheme.error),
                      ),
                    ],
                    const SizedBox(height: 24),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                      ),
                      onPressed: _sedangMengirim
                          ? null
                          : () => unawaited(_kirim()),
                      child: _sedangMengirim
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(_modeDaftar ? 'Daftar' : 'Masuk'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
