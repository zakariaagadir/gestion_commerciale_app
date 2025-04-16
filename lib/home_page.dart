import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("SmartGestion Home"),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('logo/logo.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // Company Logo and Name
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Column(
                  children: [
                    Center(
                      child: Image.asset('logo/commerX.png', height: 150),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'SmartGestion',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ],
                ),
              ),

              // Scrollable options - Cards with icons and titles
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 1.2, // Ajusté pour éviter le débordement
                  children: [
                    _buildOptionCard(context, 'Stock Management', '/stock', Icons.store),
                    _buildOptionCard(context, 'Invoices', '/invoices', Icons.account_balance_wallet),
                    _buildOptionCard(context, 'Quotes', '/quotes', Icons.note_add),
                    _buildOptionCard(context, 'Delivery Notes', '/delivery', Icons.delivery_dining),
                  ],
                ),
              ),

              const SizedBox(height: 30),
              const Text(
                '© 2023 SmartGestion. All rights reserved.',
                style: TextStyle(fontSize: 14, color: Colors.white70),
              ),
              const SizedBox(height: 10),
              const Text(
                'Developed by zakaria mounji',
                style: TextStyle(fontSize: 14, color: Colors.white70),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard(BuildContext context, String text, String route, IconData icon) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: Colors.white.withOpacity(0.8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.deepPurple),
              const SizedBox(height: 10),
              Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}