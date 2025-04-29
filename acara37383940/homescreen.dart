import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'loginscreen.dart';

class HomeScreen extends StatelessWidget {
  final List<String> countries = [
    "Tokyo",
    "Berlin",
    "Roma",
    "Monas",
    "Paris",
    "London",
    "New York",
  ];

 // const HomeScreen({super.key});

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final userEmail = auth.currentUser?.email ?? 'User';

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications),
                    onPressed: () {},
                    tooltip: 'Notifications',
                  ),
                  IconButton(
                    icon: const Icon(Icons.extension),
                    onPressed: () {},
                    tooltip: 'Menu',
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Welcome Section
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: "Welcome, \n",
                      style: TextStyle(color: Colors.blue, fontSize: 24),
                    ),
                    TextSpan(
                      text: userEmail,
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Search Bar - Tambahkan behavior khusus
              Listener(
                onPointerDown: (_) => FocusScope.of(context).unfocus(),
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search, size: 22),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: "Search destinations...",
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Recommended Places Section - Perbaikan ListView
              const Text(
                "Recommended Places",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: countries.length,
                  physics: const ClampingScrollPhysics(), // Tambahkan ini
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Chip(
                        label: Text(countries[index]),
                        backgroundColor: Colors.blue[50],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),

              // Logout Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await _signOut();
                    if (context.mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    }
                  },
                  child: const Text("Logout"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
