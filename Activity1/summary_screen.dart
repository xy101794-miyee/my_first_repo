import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/grocery.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  List<Grocery> groceries = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => isLoading = true);
    final data = await DatabaseHelper.instance.getAllGroceries();
    setState(() {
      groceries = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final totalItems = groceries.length;
    final purchased = groceries.where((g) => g.isPurchased).toList();
    final pending = groceries.where((g) => !g.isPurchased).toList();
    final totalQty = groceries.fold<int>(0, (sum, g) => sum + g.quantity);
    final totalCost =
        groceries.fold<double>(0, (sum, g) => sum + (g.price * g.quantity));
    final purchasedCost =
        purchased.fold<double>(0, (sum, g) => sum + (g.price * g.quantity));
    final pendingCost = totalCost - purchasedCost;

    // Category breakdown
    final Map<String, List<Grocery>> byCategory = {};
    for (final g in groceries) {
      byCategory.putIfAbsent(g.category, () => []).add(g);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('📊 Grocery Summary'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: groceries.isEmpty
          ? const Center(child: Text('No items to summarize'))
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // ---- Top stat cards ----
                  Row(
                    children: [
                      Expanded(
                        child: _statCard(
                          'Total Items',
                          '$totalItems',
                          Icons.list_alt,
                          Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _statCard(
                          'Total Qty',
                          '$totalQty',
                          Icons.numbers,
                          Colors.purple,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _statCard(
                          'Purchased',
                          '${purchased.length}',
                          Icons.check_circle,
                          Colors.green,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _statCard(
                          'Pending',
                          '${pending.length}',
                          Icons.pending_actions,
                          Colors.orange,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ---- Progress bar ----
                  const Text(
                    'Shopping Progress',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value:
                          totalItems == 0 ? 0 : purchased.length / totalItems,
                      minHeight: 14,
                      backgroundColor: Colors.grey.shade300,
                      valueColor: const AlwaysStoppedAnimation(Colors.green),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${((totalItems == 0 ? 0 : purchased.length / totalItems) * 100).toStringAsFixed(0)}% complete',
                    style: const TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 24),

                  // ---- Cost summary ----
                  if (totalCost > 0) ...[
                    const Text(
                      'Cost Summary',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Card(
                      child: Column(
                        children: [
                          _costRow(
                              'Total Estimated',
                              '\$${totalCost.toStringAsFixed(2)}',
                              Colors.black),
                          const Divider(height: 1),
                          _costRow(
                              'Purchased',
                              '\$${purchasedCost.toStringAsFixed(2)}',
                              Colors.green),
                          const Divider(height: 1),
                          _costRow(
                              'Remaining',
                              '\$${pendingCost.toStringAsFixed(2)}',
                              Colors.orange),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // ---- Category breakdown ----
                  const Text(
                    'By Category',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...byCategory.entries.map((entry) {
                    final catItems = entry.value;
                    final catQty =
                        catItems.fold<int>(0, (sum, g) => sum + g.quantity);
                    final catPurchased =
                        catItems.where((g) => g.isPurchased).length;
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _categoryColor(entry.key),
                          child: Text(
                            '${catItems.length}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(entry.key),
                        subtitle: Text(
                            '$catPurchased/${catItems.length} purchased • $catQty units'),
                      ),
                    );
                  }).toList(),

                  const SizedBox(height: 24),

                  // ---- Item list preview ----
                  const Text(
                    'All Items',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...groceries.map((g) => ListTile(
                        dense: true,
                        leading: Icon(
                          g.isPurchased
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color: g.isPurchased ? Colors.green : Colors.grey,
                        ),
                        title: Text(
                          g.name,
                          style: TextStyle(
                            decoration: g.isPurchased
                                ? TextDecoration.lineThrough
                                : null,
                            color: g.isPurchased ? Colors.grey : null,
                          ),
                        ),
                        subtitle: Text('${g.category} • Qty: ${g.quantity}'),
                        trailing: g.price > 0
                            ? Text(
                                '\$${(g.price * g.quantity).toStringAsFixed(2)}')
                            : null,
                      )),
                ],
              ),
            ),
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(label,
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _costRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  Color _categoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'fruits':
        return Colors.orange;
      case 'vegetables':
        return Colors.green;
      case 'dairy':
        return Colors.blue;
      case 'meat':
        return Colors.red;
      case 'bakery':
        return Colors.brown;
      default:
        return Colors.purple;
    }
  }
}
