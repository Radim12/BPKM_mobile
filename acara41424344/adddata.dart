// File: adddata.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'main.dart';

class AddData extends StatefulWidget {
  const AddData({super.key});

  @override
  _AddDataState createState() => _AddDataState();
}

class _AddDataState extends State<AddData> {
  TextEditingController controllerNama = TextEditingController();
  TextEditingController controllerTingkatan = TextEditingController();
  TextEditingController controllerTahunMasuk = TextEditingController();
  TextEditingController controllerTahunKeluar = TextEditingController();

  Future<void> addData() async {
    final url = Uri.parse(
      "https://7620-103-172-196-185.ngrok-free.app/api/api_pendidikan/",
    );

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'ngrok-skip-browser-warning': 'true',
        },
        body: {
          "nama": controllerNama.text,
          "tingkatan": controllerTingkatan.text,
          "tahun_masuk": controllerTahunMasuk.text,
          "tahun_keluar": controllerTahunKeluar.text,
        },
      );

      if (response.statusCode == 201) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      } else {
        showErrorDialog(
          'Gagal menambahkan data. Kode error: ${response.statusCode}',
        );
      }
    } catch (e) {
      showErrorDialog('Terjadi kesalahan: ${e.toString()}');
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Error'),
            content: Text(message),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("TAMBAH DATA")),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            Column(
              children: [
                _buildTextField(controllerNama, "Nama"),
                _buildTextField(controllerTingkatan, "Tingkatan"),
                _buildTextField(controllerTahunMasuk, "Tahun Masuk"),
                _buildTextField(controllerTahunKeluar, "Tahun Keluar"),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                  ),
                  child: const Text("TAMBAH DATA"),
                  onPressed: () async {
                    if (_validateForm()) {
                      await addData();
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool _validateForm() {
    if (controllerNama.text.isEmpty ||
        controllerTingkatan.text.isEmpty ||
        controllerTahunMasuk.text.isEmpty ||
        controllerTahunKeluar.text.isEmpty) {
      showErrorDialog('Semua field harus diisi!');
      return false;
    }
    return true;
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: "Masukkan $label",
        border: const OutlineInputBorder(),
      ),
    );
  }
}
