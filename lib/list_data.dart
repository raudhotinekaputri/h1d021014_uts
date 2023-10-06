import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:uts_raudhotin/detail_data.dart';
import 'package:uts_raudhotin/form_edit.dart';
import 'package:uts_raudhotin/side_menu.dart';
import 'package:uts_raudhotin/tambah_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ListData extends StatefulWidget {
  const ListData({super.key});
  @override
// ignore: library_private_types_in_public_api
  _ListDataState createState() => _ListDataState();
}

class _ListDataState extends State<ListData> {
    List<Map<String, String>> dataBelanja = [];
  String url = Platform.isAndroid
      ? 'http://10.98.5.229/uts_api/index.php'
      : 'http://localhost/uts_api/index.php';

    Future deleteData(int id) async {
    final response = await http.delete(Uri.parse('$url?id=$id'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to delete data');
    }
  }

 Future<void> fetchData() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200 && response.body != "Data belanja kosong") {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        dataBelanja = List<Map<String, String>>.from(data.map((item) {
          return {
            'id': item['id'] as String,
            'nama_barang': item['nama_barang'] as String,
            'jumlah': item['jumlah'] as String,
            'harga': item['harga'] as String,
          };
        }));
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

   @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Data Belanja'),
      ),
      drawer: const SideMenu(),
      body: Column(
        children: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const TambahData(),
                ),
              );
            },
            child: const Text('Tambah Data Belanja'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: dataBelanja.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(dataBelanja[index]['nama_barang']!),
                  subtitle: Text('Jumlah: ${dataBelanja[index]['jumlah']} - Harga: ${dataBelanja[index]['harga']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.visibility),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailData(
                                int.parse(dataBelanja[index]['id']!),
                                '${dataBelanja[index]['nama_barang']}',
                                int.parse(dataBelanja[index]['jumlah']!),
                                double.parse(dataBelanja[index]['harga']!),
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditData(
                                id: int.parse(dataBelanja[index]['id']!),
                                namaBarang: '${dataBelanja[index]['nama_barang']}',
                                jumlah: int.parse(dataBelanja[index]['jumlah']!),
                                harga: double.parse(dataBelanja[index]['harga']!),
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          deleteData(int.parse(dataBelanja[index]['id']!))
                              .then((result) {
                            if (result['pesan'] == 'berhasil') {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Data berhasil dihapus'),
                                    content: const Text('OK'),
                                    actions: [
                                      TextButton(
                                        child: const Text('OK'),
                                        onPressed: () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => const ListData(),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}