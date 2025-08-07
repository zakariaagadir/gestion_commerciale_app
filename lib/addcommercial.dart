import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // ✅ Add this import

class AddCommercial extends StatefulWidget {
  const AddCommercial({super.key});

  @override
  State<AddCommercial> createState() => _AddCommercialState();
}

class _AddCommercialState extends State<AddCommercial> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _saveCommercial() async {
    final name = _nameController.text.trim();
    final password = _passwordController.text.trim();

    // 👇 Treat 'name' as an email (or adapt this)
    final email = name;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in both fields')),
      );
      return;
    }

    try {
      // ✅ 1. Create user in Firebase Auth
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // ✅ 2. Add extra info to Firestore (optional)
      await FirebaseFirestore.instance
          .collection('commercials')
          .doc(userCredential.user!.uid)
          .set({
        'name': name,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Commercial added successfully!')),
      );

      _nameController.clear();
      _passwordController.clear();
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Auth Error: ${e.message}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Commercial')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Commercial Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                onPressed: _saveCommercial,
                icon: const Icon(Icons.save),
                label: const Text('Save Commercial'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
