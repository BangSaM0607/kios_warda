import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BarangFormPage extends StatefulWidget {
  final Map<String, dynamic>? barang;

  const BarangFormPage({Key? key, this.barang}) : super(key: key);

  @override
  State<BarangFormPage> createState() => _BarangFormPageState();
}

class _BarangFormPageState extends State<BarangFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _kategoriController = TextEditingController();
  final TextEditingController _stokController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();

  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    if (widget.barang != null) {
      _namaController.text = widget.barang!['nama_barang'];
      _kategoriController.text = widget.barang!['kategori'];
      _stokController.text = widget.barang!['stok'].toString();
      _hargaController.text = widget.barang!['harga'].toString();
    }
  }

  Future<void> simpanBarang() async {
    final nama = _namaController.text.trim();
    final kategori = _kategoriController.text.trim();
    final stok = int.tryParse(_stokController.text.trim()) ?? 0;
    final harga = double.tryParse(_hargaController.text.trim()) ?? 0.0;

    if (widget.barang == null) {
      // Tambah barang baru
      await supabase.from('produk_kios').insert({
        'nama_barang': nama,
        'kategori': kategori,
        'stok': stok,
        'harga': harga,
      });
    } else {
      // Update barang
      await supabase
          .from('produk_kios')
          .update({
            'nama_barang': nama,
            'kategori': kategori,
            'stok': stok,
            'harga': harga,
          })
          .eq('id', widget.barang!['id']);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.barang != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Barang' : 'Tambah Barang')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(labelText: 'Nama Barang'),
                validator: (val) => val!.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: _kategoriController,
                decoration: const InputDecoration(labelText: 'Kategori'),
                validator: (val) => val!.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: _stokController,
                decoration: const InputDecoration(labelText: 'Stok'),
                keyboardType: TextInputType.number,
                validator: (val) => val!.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: _hargaController,
                decoration: const InputDecoration(labelText: 'Harga'),
                keyboardType: TextInputType.number,
                validator: (val) => val!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    simpanBarang();
                  }
                },
                child: Text(isEdit ? 'Update' : 'Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
