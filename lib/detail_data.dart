import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uts_raudhotin/side_menu.dart';
import 'package:uts_raudhotin/list_data.dart'; // Import ListData

class DetailData extends StatelessWidget {
  final int id;
  final String namaBarang;
  final int jumlah;
  final double harga;

  const DetailData(this.id, this.namaBarang, this.jumlah, this.harga, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Data Belanja'),
        actions: [
          ElevatedButton( // Tambahkan tombol kembali
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ListData(),
                ),
              );
            },
            child: const Text('Kembali'),
          ),
        ],
      ),
      drawer: const SideMenu(),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            Text(
              "ID : $id",
              style: const TextStyle(
                fontSize: 18.0,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              "Nama Barang : $namaBarang",
              style: const TextStyle(
                fontSize: 18.0,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              "Jumlah : $jumlah",
              style: const TextStyle(
                fontSize: 18.0,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              "Harga : $harga",
              style: const TextStyle(
                fontSize: 18.0,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const Text(
              "©Raudhotin Eka Putri H1D021014",
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
