import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? userEmail; // Untuk menyimpan email user yang login
  String? userName; // Nama user (dari tabel users)
  String? userPhone; // Nomor HP user

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Ambil data saat halaman dibuka
  }

  Future<void> _loadUserData() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user != null) {
      setState(() {
        userEmail = user.email;
      });

      // Ambil data tambahan dari tabel 'users'
      final response =
          await Supabase.instance.client
              .from('users')
              .select()
              .eq('email', user.email!)
              .single(); // Ambil satu baris data user

      setState(() {
        userName = response['name'];
        userPhone = response['phone'];
      });
    }
  }

  Future<void> _logout() async {
    await Supabase.instance.client.auth.signOut(); // Keluar dari akun
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()), // Kembali ke login
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KIOS WARDA - Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout, // Tombol logout
          ),
        ],
      ),
      body:
          userEmail == null
              ? const Center(child: CircularProgressIndicator()) // Loading
              : Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Selamat datang!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text('Nama: $userName'),
                    Text('Email: $userEmail'),
                    Text('Nomor HP: $userPhone'),
                  ],
                ),
              ),
    );
  }
}
