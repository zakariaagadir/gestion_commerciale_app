import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductSelectionPage extends StatefulWidget {
  const ProductSelectionPage({super.key});

  @override
  State<ProductSelectionPage> createState() => _ProductSelectionPageState();
}

class _ProductSelectionPageState extends State<ProductSelectionPage> {
  List<String> selectedProductIds = [];  // Store selected product IDs as strings

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Products")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('productx').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const CircularProgressIndicator();

          final products = snapshot.data!.docs;

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              final name = product['name'];
              final productId = product.id; // Use the product ID as unique identifier

              // Check if the product is selected based on its ID
              final isSelected = selectedProductIds.contains(productId);

              return ListTile(
                title: Text(name),
                trailing: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        selectedProductIds.remove(productId); // Remove if selected
                      } else {
                        selectedProductIds.add(productId); // Add if not selected
                      }
                    });
                  },
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: isSelected ? Colors.green : Colors.grey.shade300,
                    child: isSelected
                        ? const Icon(Icons.circle, color: Colors.white, size: 10) // Small filled dot
                        : const SizedBox.shrink(),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Return selected products based on their IDs (List<String>) to avoid type mismatch
          Navigator.pop(context, selectedProductIds);
        },
        label: const Text("OK"),
        icon: const Icon(Icons.done),
      ),
    );
  }
}
