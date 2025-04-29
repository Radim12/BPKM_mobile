import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Acara36 extends StatelessWidget {
  const Acara36({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Acara 36 - Rest API Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo, // Warna utama diubah menjadi indigo
        visualDensity: VisualDensity.adaptivePlatformDensity,
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8),
        ),
      ),
      home: const HomePage(),
    );
  }
}

// Halaman utama yang menampilkan daftar dan detail pengguna
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Variabel state untuk menyimpan data
  List<User> users = [];
  User? selectedUser;
  bool isLoading = false;
  String errorMessage = '';

  // Fungsi yang dijalankan saat widget pertama kali dibuat
  @override
  void initState() {
    super.initState();
    fetchUsers(); // Memuat data pengguna saat pertama kali dibuka
  }

  // Fungsi untuk mengambil daftar pengguna dari API
  Future<void> fetchUsers() async {
    setState(() {
      isLoading = true; // Menampilkan indikator loading
      errorMessage = ''; // Reset pesan error
    });

    try {
      final response = await http.get(Uri.parse('https://reqres.in/api/users?page=2'));
      
      if (response.statusCode == 200) {
        // Jika request berhasil, parse data JSON
        final data = jsonDecode(response.body);
        final List<dynamic> userList = data['data'];
        
        setState(() {
          // Konversi data JSON ke list objek User
          users = userList.map((user) => User.fromJson(user)).toList();
        });
      } else {
        throw Exception('Gagal memuat daftar pengguna');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: ${e.toString()}'; // Tampilkan pesan error
      });
    } finally {
      setState(() {
        isLoading = false; // Sembunyikan indikator loading
      });
    }
  }

  // Fungsi untuk mengambil detail pengguna berdasarkan ID
  Future<void> fetchUserDetail(int id) async {
    setState(() {
      isLoading = true;
      errorMessage = '';
      selectedUser = null; // Reset detail pengguna yang dipilih
    });

    try {
      final response = await http.get(Uri.parse('https://reqres.in/api/users/$id'));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        setState(() {
          selectedUser = User.fromJson(data['data']); // Simpan detail pengguna
        });
      } else {
        throw Exception('Gagal memuat detail pengguna');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: ${e.toString()}';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acara 36 - Rest API Demo'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchUsers,
            tooltip: 'Refresh data',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.indigo.shade50,
              Colors.white,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header daftar pengguna
              _buildSectionHeader('Daftar Pengguna', Icons.people),
              
              // Konten daftar pengguna
              if (isLoading && users.isEmpty)
                _buildLoadingIndicator()
              else if (errorMessage.isNotEmpty)
                _buildErrorMessage(errorMessage)
              else
                Expanded(
                  child: _buildUserList(),
                ),
              
              const SizedBox(height: 24),
              
              // Header detail pengguna
              _buildSectionHeader('Detail Pengguna', Icons.person),
              
              // Konten detail pengguna
              if (isLoading && selectedUser == null)
                _buildLoadingIndicator()
              else if (selectedUser != null)
                _buildUserDetailCard(selectedUser!)
              else
                _buildPlaceholderText('Pilih pengguna untuk melihat detail'),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchUsers,
        backgroundColor: Colors.indigo,
        tooltip: 'Refresh',
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }

  // Widget untuk header section dengan icon
  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.indigo),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.indigo,
          ),
        ),
      ],
    );
  }

  // Widget untuk menampilkan daftar pengguna
  Widget _buildUserList() {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return Card(
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => fetchUserDetail(user.id),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Hero(
                    tag: 'avatar_${user.id}',
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(user.avatar),
                      radius: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${user.firstName} ${user.lastName}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          user.email,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Widget untuk menampilkan detail pengguna
  Widget _buildUserDetailCard(User user) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Hero(
              tag: 'avatar_${user.id}',
              child: CircleAvatar(
                backgroundImage: NetworkImage(user.avatar),
                radius: 50,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '${user.firstName} ${user.lastName}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 8),
            _buildDetailRow(Icons.email, user.email),
            const SizedBox(height: 8),
            _buildDetailRow(Icons.person_pin, 'ID: ${user.id}'),
          ],
        ),
      ),
    );
  }

  // Widget untuk baris detail dengan icon
  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Text(text, style: TextStyle(color: Colors.grey.shade700)),
      ],
    );
  }

  // Widget untuk indikator loading
  Widget _buildLoadingIndicator() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.indigo),
        ),
      ),
    );
  }

  // Widget untuk pesan error
  Widget _buildErrorMessage(String message) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.red.shade200),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk placeholder text
  Widget _buildPlaceholderText(String text) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: Colors.grey.shade500,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }
}

// Model data untuk menyimpan informasi pengguna
class User {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String avatar;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.avatar,
  });

  // Factory method untuk mengkonversi JSON ke objek User
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      avatar: json['avatar'],
    );
  }
}