import 'package:flutter/material.dart';
import 'home_page.dart';
import 'StockPage.dart';
import 'authentification.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SmartGestion',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthenticationPage(),
        '/home': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
        '/stock': (context) => const StockPage(),
        '/invoices': (context) => const InvoicesPage(),
        '/quotes': (context) => const QuotesPage(),
        '/delivery': (context) => const DeliveryPage(),
      },
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text("Login Screen"),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    );
  }
}

class InvoicesPage extends StatelessWidget {
  const InvoicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Invoices Page"),
      ),
      body: Center(
        child: const Text("Invoices Page Content Goes Here"),
      ),
    );
  }
}

class QuotesPage extends StatelessWidget {
  const QuotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quotes Page"),
      ),
      body: Center(
        child: const Text("Quotes Page Content Goes Here"),
      ),
    );
  }
}

class DeliveryPage extends StatelessWidget {
  const DeliveryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Delivery Notes Page"),
      ),
      body: Center(
        child: const Text("Delivery Notes Page Content Goes Here"),
      ),
    );
  }
}