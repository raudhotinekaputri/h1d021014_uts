import 'package:flutter/material.dart';
import 'package:uts_raudhotin/side_menu.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Halaman Utama'),
      ),
      drawer: const SideMenu(),
      body: const Center(child: Text('Selamat Datang di Aplikasi Daftar Belanja')),
    );
  }
}