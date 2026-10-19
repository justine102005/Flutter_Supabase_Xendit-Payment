import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';

class PaymentService {
  static Future<String?> createXenditInvoice({
    required String productName,
    required double amount,
  }) async {
    try {
      final response = await Supabase.instance.client.functions.invoke(
        'create-invoice',
        body: {
          'product_name': productName,
          'amount': amount,
        },
      );

      if (response.status == 200) {
        final data = response.data;
        if (data != null && data['invoice_url'] != null) {
          return data['invoice_url'] as String;
        }
      }
      return null;
    } catch (e) {
      print('Error creating invoice: $e');
      return null;
    }
  }
}