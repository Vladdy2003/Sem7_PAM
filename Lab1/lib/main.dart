import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator de reducere',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const DiscountCalculatorPage(),
    );
  }
}

class DiscountCalculatorPage extends StatefulWidget {
  const DiscountCalculatorPage({super.key});

  @override
  State<DiscountCalculatorPage> createState() =>
      _DiscountCalculatorPageState();
}

class _DiscountCalculatorPageState extends State<DiscountCalculatorPage> {
  // Controller pentru pretul initial
  final TextEditingController _priceController = TextEditingController();

  // Controller pentru campul combinat (text editabil + dropdown) de reducere
  final TextEditingController _discountController = TextEditingController();

  // Optiuni predefinite pentru procentul reducerii
  final List<double> _discountOptions = [5, 10, 15, 20, 25, 30, 50];

  // Rezultate afisate
  double _discountValue = 0;
  double _finalPrice = 0;
  bool _showResult = false;

  void _calculateDiscount() {
    final double? price = double.tryParse(_priceController.text);
    final double? discountPercent = double.tryParse(_discountController.text);

    if (price == null || discountPercent == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Introduceți prețul și reducerea corect!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _discountValue = price * discountPercent / 100;
      _finalPrice = price - _discountValue;
      _showResult = true;
    });
  }

  void _reset() {
    setState(() {
      _priceController.clear();
      _discountController.clear();
      _discountValue = 0;
      _finalPrice = 0;
      _showResult = false;
    });
  }

  @override
  void dispose() {
    _priceController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator de reducere'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),

            // TextField pentru pretul initial
            TextField(
              controller: _priceController,
              keyboardType:
              const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Preț inițial (lei)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money),
              ),
            ),
            const SizedBox(height: 16),

            // Camp combinat: poti scrie manual SAU alege din lista (dropdown)
            DropdownMenu<double>(
              controller: _discountController,
              width: MediaQuery.of(context).size.width - 40,
              label: const Text('Reducere (%) - scrie sau alege'),
              leadingIcon: const Icon(Icons.percent),
              enableFilter: false,
              requestFocusOnTap: true, // permite scrierea manuala la tap
              inputDecorationTheme: const InputDecorationTheme(
                border: OutlineInputBorder(),
              ),
              // Lista de optiuni predefinite ce apare la click
              dropdownMenuEntries: _discountOptions.map((double value) {
                return DropdownMenuEntry<double>(
                  value: value,
                  label: '$value%',
                );
              }).toList(),
              onSelected: (double? value) {
                if (value != null) {
                  setState(() {
                    _discountController.text = value.toString();
                  });
                }
              },
            ),
            const SizedBox(height: 24),

            // Butonul de calcul
            ElevatedButton(
              onPressed: _calculateDiscount,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                'Calculează',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 10),

            // Buton de resetare
            OutlinedButton(
              onPressed: _reset,
              child: const Text('Resetează'),
            ),

            const SizedBox(height: 30),

            // Rezultatele
            if (_showResult)
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Valoarea reducerii: ${_discountValue.toStringAsFixed(2)} lei',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Preț final: ${_finalPrice.toStringAsFixed(2)} lei',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}