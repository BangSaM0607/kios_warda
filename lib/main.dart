import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'barang_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://lleiuchgukmblykhhduz.supabase.co',
    anonKey:
        'yJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxsZWl1Y2hndWttYmx5a2hoZHV6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc2MjU1MzYsImV4cCI6MjA2MzIwMTUzNn0.TolJDNpew7JVGe2tP9ngx3BHR97LNNvyZNTALE-cDT8',
  );
  runApp(MyApp()); // Initialize Supabase and run the app
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KIOS WARDA', // Application title
      theme: ThemeData(primarySwatch: Colors.green),
      home: BarangListPage(),
    );
  }
}
