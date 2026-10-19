import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/payment_service.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final List<Map<String, dynamic>> products = [
    {'name': 'Mechanical Gaming Keyboard', 'price': 1500.00},
    {'name': 'Wireless Ergonomic Mouse', 'price': 850.00},
    {'name': 'USB-C Hub Multiport Adapter', 'price': 600.00},
  ];

  bool isLoading = false;

  Future<void> handleCheckout(String productName, double price) async {
    setState(() {
      isLoading = true;
    });

    try {
      final String? invoiceUrl = await PaymentService.createXenditInvoice(
        productName: productName,
        amount: price,
      );

      if (!mounted) return;

      if (invoiceUrl != null && invoiceUrl.isNotEmpty) {
        final Uri uri = Uri.parse(invoiceUrl);

        if (await canLaunchUrl(uri)) {
          await launchUrl(
            uri,
            mode: LaunchMode.externalApplication,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Hindi mabuksan ang checkout URL.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to generate payment invoice.')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Store'),
      ),
      body: isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Inihahanda ang Xendit Payment Checkout...'),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    title: Text(
                      product['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      '₱${(product['price'] as double).toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    trailing: ElevatedButton(
                      onPressed: () => handleCheckout(
                        product['name'],
                        (product['price'] as double),
                      ),
                      child: const Text('Buy Now'),
                    ),
                  ),
                );
              },
            ),
    );
  }
}