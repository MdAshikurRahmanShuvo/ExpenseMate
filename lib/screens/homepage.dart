import 'package:flutter/material.dart';
import 'add_credit_screen.dart';
import 'debit_screen.dart';
import 'edit_profile_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double totalCredit = 0.0;
  double totalDebit = 0.0;

  List<Map<String, dynamic>> creditHistory = [];
  List<Map<String, dynamic>> debitHistory = [];

  @override
  Widget build(BuildContext context) {
    double remaining = totalCredit - totalDebit;

    return Scaffold(
      backgroundColor: const Color(0xFF68A5A0),
      appBar: AppBar(
        backgroundColor: const Color(0xFF68A5A0),
        elevation: 0,
        title: const Text('Welcome Shuvo!'),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.menu),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text(
              'Financial Activity',
              style: TextStyle(
                fontSize: 20,
                color: Colors.purple,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    blurRadius: 4,
                    color: Colors.black38,
                    offset: Offset(2, 2),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _infoCard(
                  label: 'Income',
                  amount: '৳ ${totalCredit.toStringAsFixed(2)}',
                  color: const Color(0xFFB7C989),
                ),
                _infoCard(
                  label: 'Expense',
                  amount: '৳ ${totalDebit.toStringAsFixed(2)}',
                  color: const Color(0xFF458554),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 160,
                  width: 300,
                  child: CustomPaint(
                    painter: GaugePainter(),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.red[700],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Remain',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '৳ ${remaining.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        onTap: (index) async {
          if (index == 1) {
            _showAddOptions(context);
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfilePage()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
    );
  }

  void _showAddOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.add_card, color: Colors.green),
              title: const Text('Add Credit'),
              onTap: () async {
                Navigator.pop(context);
                final result = await Navigator.push<Map<String, dynamic>>(
                  context,
                  MaterialPageRoute(builder: (_) => const CreditPage()),
                );
                if (result != null && result['amount'] > 0) {
                  setState(() {
                    totalCredit += result['amount'];
                    creditHistory.add({
                      'description': result['description'],
                      'amount': result['amount'],
                      'date': DateTime.now(),
                    });
                  });
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.money_off, color: Colors.red),
              title: const Text('Add Debit'),
              onTap: () async {
                Navigator.pop(context);
                final result = await Navigator.push<Map<String, dynamic>>(
                  context,
                  MaterialPageRoute(builder: (_) => const DebitPage()),
                );
                if (result != null && result['amount'] > 0) {
                  setState(() {
                    totalDebit += result['amount'];
                    debitHistory.add({
                      'description': result['description'],
                      'amount': result['amount'],
                      'quantity': result['quantity'],
                      'date': result['date'],
                    });
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _infoCard({
    required String label,
    required String amount,
    required Color color,
  }) {
    return Container(
      width: 150,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            amount,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white,
              shadows: [
                Shadow(
                  blurRadius: 1,
                  color: Colors.black26,
                  offset: Offset(1, 1),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GaugePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromCircle(
        center: Offset(size.width / 2, size.height), radius: size.width / 2);
    final startAngle = 3.14;
    final sweepAngle = 3.14;

    final greenPaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 20
      ..style = PaintingStyle.stroke;

    final redPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 20
      ..style = PaintingStyle.stroke;

    canvas.drawArc(rect, startAngle, sweepAngle * 0.7, false, greenPaint);
    canvas.drawArc(rect, startAngle + sweepAngle * 0.7, sweepAngle * 0.3, false, redPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
