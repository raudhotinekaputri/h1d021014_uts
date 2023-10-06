import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uts_raudhotin/list_data.dart';
import 'package:uts_raudhotin/side_menu.dart';

class TambahData extends StatefulWidget {
  const TambahData({Key? key}) : super(key: key);

  @override
  _TambahDataState createState() => _TambahDataState();
}

class _TambahDataState extends State<TambahData> {
  final namaController = TextEditingController();
  final jumlahController = TextEditingController();
  final hargaController = TextEditingController();

  Future postData(String nama, int jumlah, double harga) async {
    String url = Platform.isAndroid
        ? 'http://10.98.5.229/uts_api/index.php' // Ganti URL sesuai dengan endpoint API belanja
        : 'http://localhost/uts_api/index.php'; // Ganti URL sesuai dengan endpoint API belanja

    Map<String, String> headers = {'Content-Type': 'application/json'};
    String jsonBody = '{"nama_barang":"$nama","jumlah":$jumlah,"harga":$harga}';
    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonBody,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Gagal Menambahkan Data');
    }
  }

  _buatInput(control, String hint) {
    return TextField(
      controller: control,
      decoration: InputDecoration(hintText: hint),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Data Belanja'),
      ),
      drawer: const SideMenu(),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buatInput(namaController, 'Masukkan Nama Barang'),
            _buatInput(jumlahController, 'Masukkan Jumlah'),
            _buatInput(hargaController, 'Masukkan Harga'),
            ElevatedButton(
              onPressed: () {
                String nama = namaController.text;
                int jumlah = int.tryParse(jumlahController.text) ?? 0;
                double harga = double.tryParse(hargaController.text) ?? 0.0;

                postData(nama, jumlah, harga).then((result) {
                  if (result['pesan'] == 'berhasil') {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Data berhasil ditambah'),
                          content: const Text('OK'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ListData(),
                                  ),
                                );
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                  setState(() {});
                });
              },
              child: const Text('Tambah Data Belanja'),
            ),
          ],
        ),
      ),
    );
  }
}
