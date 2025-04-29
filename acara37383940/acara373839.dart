import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'loginscreen.dart';

class Acara373839 extends StatelessWidget {
  const Acara373839({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Perbaikan 1: Tambah tanda kurung tutup untuk Center dan Scaffold
        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(
              child: Text('Error initializing Firebase'),
            ), // <- Tambah ini
          ); // <- Tambah ini
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return LoginScreen();
        }

        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'loginscreen.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
// }

// class Acara373839 extends StatelessWidget {
//   const Acara373839({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: LoginScreen(),
//     );
//   }
// }
