import 'package:flutter/material.dart';
import 'main.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SmartGestion Home"),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('logo/logo.png'), // Path to your background image
            fit: BoxFit.cover, // Ensure the image covers the entire screen
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // Company Logo and Name
              Container(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Column(
                  children: [
                    Center(
                      child: Image.asset('logo/commerX.png', height: 150), // Logo image
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.count(
                  crossAxisCount: 2, // Two options per row
                  crossAxisSpacing: 20, // Space between columns
                  mainAxisSpacing: 20, // Space between rows
                  shrinkWrap: true, // Makes GridView fit to the content
                  physics: NeverScrollableScrollPhysics(), // Disable GridView scrolling
                  childAspectRatio: 1.5, // Adjust button size ratio
                  children: [
                    _buildOptionCard(context, 'Go to Login', '/login', Icons.login),
                    _buildOptionCard(context, 'Go to Stock Management', '/stock', Icons.store),
                    _buildOptionCard(context, 'Go to Invoices', '/invoices', Icons.account_balance_wallet),
                    _buildOptionCard(context, 'Go to Quotes', '/quotes', Icons.note_add),
                    _buildOptionCard(context, 'Go to Delivery Notes', '/delivery', Icons.delivery_dining),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to build each option card with an icon and title for better UX
  Widget _buildOptionCard(BuildContext context, String text, String route, IconData icon) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Card(
        elevation: 8, // Adds elevation to make the card appear raised from the screen
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Rounded corners
        ),
        color: Colors.white.withOpacity(0.8), // Semi-transparent white background
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Icon Section
            Icon(
              icon,
              size: 40,
              color: Colors.deepPurple,
            ),
            // Space between icon and title
            const SizedBox(height: 10),
            // Title Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
