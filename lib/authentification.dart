import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isHovered = false;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          SizedBox.expand(
            child: Image.asset('logo/logo.png', fit: BoxFit.cover),
          ),
          // Semi-transparent overlay (optional for better readability)
          Container(color: Colors.black.withOpacity(0.4)),
          // Foreground content
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo and App Name
                  Column(
                    children: [
                      Image.asset('logo/commerX.png', height: 120),
                      const SizedBox(height: 16),
                      const Text(
                        'Agriven',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 60),

                  // Email Field
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: usernameController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: _inputDecoration('Email', Icons.email),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Password Field
                  Container(
                    margin: const EdgeInsets.only(bottom: 30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: _inputDecoration('Password', Icons.lock),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Login Button
                  MouseRegion(
                    onEnter: (_) => setState(() => isHovered = true),
                    onExit: (_) => setState(() => isHovered = false),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isHovered
                                  ? Colors.orange.shade300
                                  : Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _handleLogin,
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.white.withOpacity(0.85),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.deepOrange, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.grey, width: 1),
      ),
    );
  }

  Future<void> _handleLogin() async {
    try {
      // Tentative de connexion avec Firebase Authentication
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: usernameController.text.trim(),
        password: passwordController.text.trim(),
      );
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'user-not-found') {
        // Si l'utilisateur n'est pas trouvé dans Firebase Auth, vérifiez Firestore
        bool userExistsInCommercials = await _checkUserInCommercials();
        if (userExistsInCommercials) {
          errorMessage =
              'User found in commercials collection but not in Firebase Auth.';
        } else {
          errorMessage = 'No user found for that email.';
        }
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided.';
      } else {
        errorMessage = 'An error hello : $e.code';
        print('hie : $e.code');
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An unexpected error occurred.')),
      );
    }
  }

  Future<bool> _checkUserInCommercials() async {
    try {
      // Vérifiez si l'utilisateur existe dans la collection Firestore "commercials"
      final querySnapshot =
          await FirebaseFirestore.instance
              .collection('commercials')
              .where('name', isEqualTo: usernameController.text.trim())
              .where('password', isEqualTo: passwordController.text.trim())
              .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      // Gérer les erreurs de Firestore
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error checking user in commercials collection.'),
        ),
      );
      return false;
    }
  }
}
