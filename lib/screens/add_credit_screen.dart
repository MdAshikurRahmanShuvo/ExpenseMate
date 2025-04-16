import 'package:flutter/material.dart';

class CreditPage extends StatefulWidget {
  const CreditPage({super.key});

  @override
  State<CreditPage> createState() => _CreditPageState();
}

class _CreditPageState extends State<CreditPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Credit')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Enter Text'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Enter Amount'),
            ),
            const SizedBox(height: 20),
            IconButton(
              icon: const Icon(
                Icons.check_circle,
                size: 40,
                color: Colors.green,
              ),
              onPressed: () {
                String title = titleController.text.trim();
                double amount = double.tryParse(amountController.text) ?? 0;

                if (title.isEmpty || amount <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please enter valid title and amount"),
                    ),
                  );
                  return;
                }

                Navigator.pop(context, {'title': title, 'amount': amount});
              },
            ),
          ],
        ),
      ),
    );
  }
}
