import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'detail.dart';
import 'adddata.dart';

class Acara4344 extends StatelessWidget {
  const Acara4344({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Data Pendidikan",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<List<dynamic>> getData() async {
    try {
      final url = Uri.parse(
        "https://7620-103-172-196-185.ngrok-free.app/api/api_pendidikan",
      );
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Force refresh UI setelah operasi CRUD
        if (data is List) return data;
        return []; // Return empty list jika format tidak sesuai
      } else {
        throw Exception('Failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Data Pendidikan")),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddData()),
          );
          setState(() {}); // Refresh data setelah kembali
        },
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
          await Future.delayed(Duration(seconds: 1));
        },
        child: FutureBuilder<List<dynamic>>(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 50),
                    const SizedBox(height: 20),
                    Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => setState(() {}),
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              );
            }

            final data = snapshot.data ?? [];

            if (data.isEmpty) {
              return const Center(
                child: Text(
                  "Tidak ada data pendidikan",
                  style: TextStyle(fontSize: 18),
                ),
              );
            }

            return ItemList(list: data);
          },
        ),
      ),
    );
  }
}

class ItemList extends StatelessWidget {
  final List<dynamic> list;
  const ItemList({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder:
          (context, i) => Container(
            padding: const EdgeInsets.all(10),
            child: GestureDetector(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Detail(list: list, index: i),
                  ),
                );
                // Trigger refresh setelah kembali dari detail
                if (context.mounted) {
                  Navigator.of(
                    context,
                  ).pushReplacement(MaterialPageRoute(builder: (_) => Home()));
                }
              },
              child: Card(
                child: ListTile(
                  leading: const Icon(Icons.school),
                  title: Text(list[i]['nama']?.toString() ?? 'No Name'),
                  subtitle: Text(
                    "Tingkatan: ${list[i]['tingkatan']?.toString() ?? '-'}",
                  ),
                  trailing: Text("ID: ${list[i]['id']}"),
                ),
              ),
            ),
          ),
    );
  }
}
