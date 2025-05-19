import 'package:flutter/material.dart'; // Paket UI Flutter
import 'package:supabase_flutter/supabase_flutter.dart'; // Supabase SDK
import 'home_page.dart'; // Halaman setelah login
import 'register_page.dart'; // Halaman pendaftaran

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState(); // Gunakan state untuk input interaktif
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController(); // Input email
  final _passwordController = TextEditingController(); // Input password

  Future<void> _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      // 1. Autentikasi ke Supabase Auth
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      // 2. Jika berhasil login
      if (response.user != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Login berhasil')));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const HomePage(),
          ), // Arahkan ke HomePage
        );
      }
    } catch (e) {
      // 3. Jika gagal login, tampilkan error
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Login gagal: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _login, child: const Text('LOGIN')),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterPage()),
                );
              },
              child: const Text('Belum punya akun? Daftar'),
            ),
          ],
        ),
      ),
    );
  }
}
