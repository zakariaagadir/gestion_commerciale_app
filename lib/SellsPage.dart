import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'product_selection_page.dart';

class SellsPage extends StatefulWidget {
  const SellsPage({super.key});

  @override
  State<SellsPage> createState() => _SellsPageState();
}

class _SellsPageState extends State<SellsPage> {
  List<DocumentSnapshot> selectedProducts = [];
  Map<String, int> quantities = {}; // productId -> quantity

  void _selectProducts() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProductSelectionPage()),
    );

    if (result != null && result is List<String>) {
      List<DocumentSnapshot> products = [];
      for (var productId in result) {
        final snapshot = await FirebaseFirestore.instance
            .collection('productx')
            .doc(productId)
            .get();
        if (snapshot.exists && snapshot.data() != null) {
          products.add(snapshot);
        }
      }

      setState(() {
        selectedProducts = products;
      });
    }
  }

  Future<void> _generateQuotePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Devis', style: pw.TextStyle(fontSize: 24)),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                headers: ['Produit', 'Prix', 'Quantité', 'Total'],
                data: selectedProducts.map((product) {
                  final id = product.id;
                  final name = product['name'] ?? 'Unknown';
                  final price = product['price'] ?? 0.0;
                  final qty = quantities[id] ?? 0;
                  final total = price * qty;
                  return [
                    name,
                    price.toStringAsFixed(2),
                    qty.toString(),
                    total.toStringAsFixed(2)
                  ];
                }).toList(),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Total général: ${selectedProducts.fold<double>(0, (sum, product) {
                  final id = product.id;
                  final price = product['price'] ?? 0.0;
                  final qty = quantities[id] ?? 0;
                  return sum + price * qty;
                }).toStringAsFixed(2)} €',
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  void _confirmSale() async {
    for (var product in selectedProducts) {
      try {
        final id = product.id;
        final name = product['name'] ?? 'Unknown';
        final stock = product['stock'] ?? 0;
        final price = product['price'] ?? 0.0;
        final qty = quantities[id] ?? 0;

        if (qty > 0 && qty <= stock) {
          await FirebaseFirestore.instance.collection('productx').doc(id).update({
            'stock': stock - qty,
          });

          await FirebaseFirestore.instance.collection('sells').add({
            'productId': id,
            'productName': name,
            'quantitySold': qty,
            'price': price,
            'total': qty * price,
            'date': FieldValue.serverTimestamp(),
          });
        }
      } catch (e) {
        debugPrint('Error confirming sale: $e');
      }
    }

    await _generateQuotePdf();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Sale confirmed!")),
      );
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("New Sale")),
      body: Column(
        children: [
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _selectProducts,
            child: const Text("Select Products"),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: selectedProducts.length,
              itemBuilder: (context, index) {
                final product = selectedProducts[index];
                final name = product['name'] ?? 'Unnamed';
                final stock = product['stock'] ?? 0;
                final price = product['price'] ?? 0.0;

                return ListTile(
                  title: Text(name),
                  subtitle: Text("In Stock: $stock | Price: €${price.toStringAsFixed(2)}"),
                  trailing: SizedBox(
                    width: 80,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Qty"),
                      onChanged: (value) {
                        setState(() {
                          quantities[product.id] = int.tryParse(value) ?? 0;
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: _confirmSale,
            child: const Text("Confirm Sale"),
          ),
        ],
      ),
    );
  }
}
