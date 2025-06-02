import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'barang_form_page.dart';

class BarangListPage extends StatefulWidget {
  const BarangListPage({Key? key}) : super(key: key);

  @override
  State<BarangListPage> createState() => _BarangListPageState();
}

class _BarangListPageState extends State<BarangListPage> {
  final supabase = Supabase.instance.client;
  List<dynamic> barangList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBarang();
  }

  Future<void> fetchBarang() async {
    setState(() => isLoading = true);
    final data = await supabase
        .from('produk_kios')
        .select()
        .order('created_at');
    setState(() {
      barangList = data;
      isLoading = false;
    });
  }

  Future<void> deleteBarang(String id) async {
    await supabase.from('produk_kios').delete().eq('id', id);
    fetchBarang();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Data Barang KIOS WARDA')),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: fetchBarang,
                child: ListView.builder(
                  itemCount: barangList.length,
                  itemBuilder: (context, index) {
                    final barang = barangList[index];
                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        title: Text(barang['nama_barang']),
                        subtitle: Text(
                          '${barang['kategori']} | Stok: ${barang['stok']} | Rp${barang['harga']}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => BarangFormPage(barang: barang),
                                  ),
                                );
                                fetchBarang();
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => deleteBarang(barang['id']),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const BarangFormPage()),
          );
          fetchBarang();
        },
      ),
    );
  }
}
