import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'main.dart';

class EditData extends StatefulWidget {
  final List list;
  final int index;
  const EditData({super.key, required this.list, required this.index});

  @override
  _EditDataState createState() => _EditDataState();
}

class _EditDataState extends State<EditData> {
  late TextEditingController controllerNama;
  late TextEditingController controllerTingkatan;
  late TextEditingController controllerTahunMasuk;
  late TextEditingController controllerTahunKeluar;

  void editData() async {
    final url = Uri.parse(
      'https://7620-103-172-196-185.ngrok-free.app/api/api_pendidikan/${widget.list[widget.index]['id']}',
    );

    await http.put(
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
  }

  @override
  void initState() {
    controllerNama = TextEditingController(
      text: widget.list[widget.index]['nama'],
    );
    controllerTingkatan = TextEditingController(
      text: widget.list[widget.index]["tingkatan"].toString(),
    );
    controllerTahunMasuk = TextEditingController(
      text: widget.list[widget.index]["tahun_masuk"].toString(),
    );
    controllerTahunKeluar = TextEditingController(
      text: widget.list[widget.index]["tahun_keluar"].toString(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("EDIT DATA")),
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
                  child: const Text("SIMPAN PERUBAHAN"),
                  onPressed: () {
                    editData();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Home()),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
