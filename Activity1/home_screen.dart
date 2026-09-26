import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/grocery.dart';
import 'add_edit_screen.dart';
import 'summary_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Grocery> groceries = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGroceries();
  }

  Future<void> _loadGroceries() async {
    setState(() => isLoading = true);
    final data = await DatabaseHelper.instance.getAllGroceries();
    setState(() {
      groceries = data;
      isLoading = false;
    });
  }

  Future<void> _deleteGrocery(int id) async {
    await DatabaseHelper.instance.deleteGrocery(id);
    _loadGroceries();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Item deleted')),
    );
  }

  Future<void> _togglePurchased(Grocery grocery) async {
    await DatabaseHelper.instance
        .togglePurchased(grocery.id!, !grocery.isPurchased);
    _loadGroceries();
  }

  Future<void> _clearPurchased() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear Purchased?'),
        content: const Text('Remove all purchased items from your list?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await DatabaseHelper.instance.deletePurchased();
      _loadGroceries();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Purchased items cleared')),
      );
    }
  }

  Future<void> _navigateToAddEdit({Grocery? grocery}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddEditScreen(grocery: grocery)),
    );
    if (result == true) _loadGroceries();
  }

  void _openSummary() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SummaryScreen()),
    );
    _loadGroceries();
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

  @override
  Widget build(BuildContext context) {
    final pending = groceries.where((g) => !g.isPurchased).toList();
    final purchased = groceries.where((g) => g.isPurchased).toList();
    final hasPurchased = purchased.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('🛒 Grocery List'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            tooltip: 'Summary',
            onPressed: _openSummary,
          ),
          if (hasPurchased)
            IconButton(
              icon: const Icon(Icons.cleaning_services),
              tooltip: 'Clear purchased',
              onPressed: _clearPurchased,
            ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : groceries.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: _loadGroceries,
                  child: ListView(
                    padding: const EdgeInsets.all(8),
                    children: [
                      // Pending section
                      if (pending.isNotEmpty) ...[
                        _sectionHeader(
                            'To Buy (${pending.length})', Colors.orange),
                        ...pending.map((g) => _buildItem(g)),
                      ],

                      // Purchased section
                      if (purchased.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        _sectionHeader(
                            'Purchased (${purchased.length})', Colors.green),
                        ...purchased.map((g) => _buildItem(g)),
                      ],
                    ],
                  ),
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToAddEdit(),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Item'),
      ),
    );
  }

  Widget _sectionHeader(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 18,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(Grocery item) {
    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (_) async {
        return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Delete Item?'),
            content: Text('Remove "${item.name}" from list?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Delete'),
              ),
            ],
          ),
        );
      },
      onDismissed: (_) => _deleteGrocery(item.id!),
      child: Card(
        elevation: item.isPurchased ? 0 : 2,
        color: item.isPurchased ? Colors.grey.shade100 : null,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: ListTile(
          leading: Checkbox(
            value: item.isPurchased,
            activeColor: Colors.green,
            onChanged: (_) => _togglePurchased(item),
          ),
          title: Text(
            item.name,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              decoration: item.isPurchased ? TextDecoration.lineThrough : null,
              color: item.isPurchased ? Colors.grey : null,
            ),
          ),
          subtitle: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _categoryColor(item.category).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  item.category,
                  style: TextStyle(
                    color: _categoryColor(item.category),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text('Qty: ${item.quantity}'),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.edit, color: Colors.blueGrey),
            onPressed: () => _navigateToAddEdit(grocery: item),
          ),
          onTap: () => _navigateToAddEdit(grocery: item),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined,
              size: 100, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          const Text('Your grocery list is empty',
              style: TextStyle(fontSize: 18, color: Colors.grey)),
          const SizedBox(height: 8),
          const Text('Tap "Add Item" to get started',
              style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
