import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'homescreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  bool _obscurePassword = true;
  String _passwordStrength = '';
  Color _strengthColor = Colors.transparent;
  double _strengthValue = 0.0;

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      _showError(e.code);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _checkPasswordStrength(String value) {
    if (value.isEmpty) {
      setState(() {
        _passwordStrength = '';
        _strengthColor = Colors.transparent;
        _strengthValue = 0.0;
      });
      return;
    }

    int strength = 0;
    List<String> criteria = [];

    if (value.length >= 8) {
      strength++;
      criteria.add('✓ Panjang minimal 8 karakter');
    } else {
      criteria.add('× Panjang minimal 8 karakter');
    }

    if (value.contains(RegExp(r'[A-Z]'))) {
      strength++;
      criteria.add('✓ Mengandung huruf besar');
    } else {
      criteria.add('× Mengandung huruf besar');
    }

    if (value.contains(RegExp(r'[0-9]'))) {
      strength++;
      criteria.add('✓ Mengandung angka');
    } else {
      criteria.add('× Mengandung angka');
    }

    if (value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      strength++;
      criteria.add('✓ Mengandung simbol');
    } else {
      criteria.add('× Mengandung simbol');
    }

    setState(() {
      if (strength <= 1) {
        _passwordStrength = 'Lemah';
        _strengthColor = Colors.red;
        _strengthValue = 0.25;
      } else if (strength == 2) {
        _passwordStrength = 'Sedang';
        _strengthColor = Colors.orange;
        _strengthValue = 0.5;
      } else if (strength == 3) {
        _passwordStrength = 'Kuat';
        _strengthColor = Colors.lightGreen;
        _strengthValue = 0.75;
      } else {
        _passwordStrength = 'Sangat Kuat';
        _strengthColor = Colors.green;
        _strengthValue = 1.0;
      }
    });
  }

  void _showError(String code) {
    String message;
    switch (code) {
      case 'invalid-email':
        message = 'Format email tidak valid';
        break;
      case 'user-disabled':
        message = 'Akun dinonaktifkan';
        break;
      case 'user-not-found':
        message = 'Pengguna tidak ditemukan';
        break;
      case 'wrong-password':
        message = 'Password salah';
        break;
      default:
        message = 'Terjadi kesalahan, coba lagi';
    }

    if (kIsWeb) {
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text('Error'),
              content: Text(message),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 40,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const FlutterLogo(size: 100),
                const SizedBox(height: 30),
                const Text(
                  'Latihan Autentikasi',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 40),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email_outlined),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator:
                            (value) =>
                                value!.contains('@')
                                    ? null
                                    : 'Masukkan email yang valid',
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed:
                                () => setState(() {
                                  _obscurePassword = !_obscurePassword;
                                }),
                          ),
                          border: const OutlineInputBorder(),
                        ),
                        obscureText: _obscurePassword,
                        onChanged: _checkPasswordStrength,
                        validator:
                            (value) =>
                                value!.length >= 6
                                    ? null
                                    : 'Minimal 6 karakter',
                      ),
                      const SizedBox(height: 10),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: LinearProgressIndicator(
                                    value: _strengthValue,
                                    backgroundColor: Colors.grey[200],
                                    valueColor: AlwaysStoppedAnimation(
                                      _strengthColor,
                                    ),
                                    minHeight: 8,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  _passwordStrength,
                                  style: TextStyle(
                                    color: _strengthColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 10,
                              runSpacing: 5,
                              children: [
                                _buildCriteriaItem('8+ Karakter'),
                                _buildCriteriaItem('Huruf Besar'),
                                _buildCriteriaItem('Angka'),
                                _buildCriteriaItem('Simbol'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 2,
                          ),
                          child:
                              _isLoading
                                  ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                  : const Text(
                                    'LOGIN',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCriteriaItem(String text) {
    bool isMet = false;
    if (text == '8+ Karakter') {
      isMet = _passwordController.text.length >= 8;
    } else if (text == 'Huruf Besar') {
      isMet = _passwordController.text.contains(RegExp(r'[A-Z]'));
    } else if (text == 'Angka') {
      isMet = _passwordController.text.contains(RegExp(r'[0-9]'));
    } else if (text == 'Simbol') {
      isMet = _passwordController.text.contains(
        RegExp(r'[!@#$%^&*(),.?":{}|<>]'),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isMet ? Icons.check_circle : Icons.circle,
          color: isMet ? Colors.green : Colors.grey,
          size: 14,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            color: isMet ? Colors.green : Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
