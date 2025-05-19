import 'package:flutter/material.dart'; // Import UI toolkit Flutter
import 'package:supabase_flutter/supabase_flutter.dart'; // Import Supabase SDK untuk Flutter

class RegisterPage extends StatefulWidget {
  // Membuat widget stateful untuk halaman daftar
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState(); // Menghubungkan ke state
}

class _RegisterPageState extends State<RegisterPage> {
  // Controller untuk menangkap input pengguna
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  Future<void> _register() async {
    // Fungsi saat tombol daftar ditekan
    final email = _emailController.text;
    final password = _passwordController.text;
    final name = _nameController.text;
    final phone = _phoneController.text;

    try {
      // 1. Mendaftarkan akun ke Supabase Auth
      final response = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );

      // 2. Jika sukses, tambahkan data ke tabel 'users'
      if (response.user != null) {
        await Supabase.instance.client.from('users').insert({
          'email': email,
          'name': name,
          'phone': phone,
        });

        // 3. Tampilkan pesan berhasil
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Registrasi berhasil')));
        Navigator.pop(context); // Kembali ke halaman login
      }
    } catch (e) {
      // Menampilkan pesan error jika gagal daftar
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Membuat layout halaman
      appBar: AppBar(title: const Text('Daftar Akun')), // Judul AppBar
      body: Padding(
        // Container dengan padding
        padding: const EdgeInsets.all(16),
        child: Column(
          // Layout kolom untuk form
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nama'),
            ),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Nomor HP'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true, // Agar password disembunyikan
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _register,
              child: const Text('DAFTAR'), // Tombol daftar
            ),
          ],
        ),
      ),
    );
  }
}
