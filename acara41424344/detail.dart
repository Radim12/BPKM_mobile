import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'editdata.dart';
import 'main.dart';

class Detail extends StatefulWidget {
  final List list;
  final int index;
  const Detail({super.key, required this.list, required this.index});

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  void deleteData() async {
    final url = Uri.parse(
      'https://7620-103-172-196-185.ngrok-free.app/api/api_pendidikan/${widget.list[widget.index]['id']}',
    );

    await http.delete(
      url,
      headers: {
        'Accept': 'application/json',
        'ngrok-skip-browser-warning': 'true',
      },
    );
  }

  void confirmDelete() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            content: Text("Hapus '${widget.list[widget.index]['nama']}'?"),
            actions: [
              TextButton(
                child: const Text("BATAL"),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: const Text("HAPUS", style: TextStyle(color: Colors.red)),
                onPressed: () {
                  deleteData();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                  );
                },
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.list[widget.index]['nama'])),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Card(
          child: Column(
            children: [
              const SizedBox(height: 30),
              _buildDetailText('Nama: ${widget.list[widget.index]['nama']}'),
              _buildDetailText(
                'Tingkatan: ${widget.list[widget.index]['tingkatan']}',
              ),
              _buildDetailText(
                'Tahun Masuk: ${widget.list[widget.index]['tahun_masuk']}',
              ),
              _buildDetailText(
                'Tahun Keluar: ${widget.list[widget.index]['tahun_keluar']}',
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text("EDIT"),
                    onPressed:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => EditData(
                                  list: widget.list,
                                  index: widget.index,
                                ),
                          ),
                        ),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: confirmDelete,
                    child: const Text("HAPUS"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(text, style: const TextStyle(fontSize: 18)),
    );
  }
}
