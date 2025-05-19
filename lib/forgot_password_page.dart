import 'package:flutter/material.dart'; // UI toolkit
import 'package:supabase_flutter/supabase_flutter.dart'; // Supabase SDK

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController =
      TextEditingController(); // Untuk menangkap email input

  Future<void> _resetPassword() async {
    final email = _emailController.text;

    try {
      // 1. Kirim email reset password melalui Supabase
      await Supabase.instance.client.auth.resetPasswordForEmail(email);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Link reset password dikirim ke email')),
      );
      Navigator.pop(context); // Kembali ke halaman login
    } catch (e) {
      // 2. Tampilkan error jika gagal
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lupa Password')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Masukkan email untuk reset password:'),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _resetPassword,
              child: const Text('KIRIM LINK RESET'),
            ),
          ],
        ),
      ),
    );
  }
}
