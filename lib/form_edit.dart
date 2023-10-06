import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uts_raudhotin/list_data.dart';
import 'package:uts_raudhotin/side_menu.dart';

class EditData extends StatefulWidget {
  final int id;
  final String namaBarang;
  final int jumlah;
  final double harga;

  const EditData({
    Key? key,
    required this.id,
    required this.namaBarang,
    required this.jumlah,
    required this.harga,
  }) : super(key: key);

  @override
  _EditDataState createState() => _EditDataState();
}

class _EditDataState extends State<EditData> {
  TextEditingController namaBarangController = TextEditingController();
  TextEditingController jumlahController = TextEditingController();
  TextEditingController hargaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    namaBarangController.text = widget.namaBarang;
    jumlahController.text = widget.jumlah.toString();
    hargaController.text = widget.harga.toString();
  }

  Future updateData(
      int id, String namaBarang, int jumlah, double harga) async {
    String url = Platform.isAndroid
        ? 'http://10.98.5.229/uts_api/index.php'
        : 'http://localhost/uts_api/index.php';

    Map<String, String> headers = {'Content-Type': 'application/json'};
    String jsonBody =
        '{"id":"$id","nama_barang":"$namaBarang","jumlah":$jumlah,"harga":$harga}';

    var response = await http.put(
      Uri.parse(url),
      headers: headers,
      body: jsonBody,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to Edit data');
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
        title: const Text('Edit Data Belanja'),
      ),
      drawer: const SideMenu(),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buatInput(namaBarangController, 'Masukkan Nama Barang'),
            _buatInput(jumlahController, 'Masukkan Jumlah'),
            _buatInput(hargaController, 'Masukkan Harga'),
            ElevatedButton(
              onPressed: () {
                String namaBarang = namaBarangController.text;
                int jumlah = int.tryParse(jumlahController.text) ?? 0;
                double harga = double.tryParse(hargaController.text) ?? 0.0;

                updateData(widget.id, namaBarang, jumlah, harga).then((result) {
                  if (result['pesan'] == 'berhasil') {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Data berhasil diedit'),
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
              child: const Text('Edit Data Belanja'),
            ),
          ],
        ),
      ),
    );
  }
}
