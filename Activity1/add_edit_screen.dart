import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/grocery.dart';

class AddEditScreen extends StatefulWidget {
  final Grocery? grocery;
  const AddEditScreen({super.key, this.grocery});

  @override
  State<AddEditScreen> createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _quantityController;
  late TextEditingController _priceController;
  String _selectedCategory = 'Fruits';
  bool _isPurchased = false;

  final List<String> _categories = [
    'Fruits',
    'Vegetables',
    'Dairy',
    'Meat',
    'Bakery',
    'Other',
  ];

  bool get isEditing => widget.grocery != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.grocery?.name ?? '');
    _quantityController =
        TextEditingController(text: widget.grocery?.quantity.toString() ?? '1');
    _priceController = TextEditingController(
        text: widget.grocery != null && widget.grocery!.price > 0
            ? widget.grocery!.price.toString()
            : '');
    if (widget.grocery != null) {
      _selectedCategory = widget.grocery!.category;
      _isPurchased = widget.grocery!.isPurchased;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final grocery = Grocery(
      id: widget.grocery?.id,
      name: _nameController.text.trim(),
      quantity: int.parse(_quantityController.text.trim()),
      category: _selectedCategory,
      isPurchased: _isPurchased,
      price: double.tryParse(_priceController.text.trim()) ?? 0.0,
    );

    if (isEditing) {
      await DatabaseHelper.instance.updateGrocery(grocery);
    } else {
      await DatabaseHelper.instance.insertGrocery(grocery);
    }

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Item' : 'Add Item'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Item Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.shopping_basket),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter item name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Quantity',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.numbers),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Required';
                        }
                        final qty = int.tryParse(value);
                        if (qty == null || qty <= 0) return 'Invalid';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Price (optional)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.attach_money),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return null;
                        }
                        final p = double.tryParse(value);
                        if (p == null || p < 0) return 'Invalid';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                items: _categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedCategory = value);
                  }
                },
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                title: const Text('Mark as Purchased'),
                subtitle: Text(_isPurchased
                    ? 'This item has been bought'
                    : 'Still need to buy this item'),
                value: _isPurchased,
                activeColor: Colors.green,
                onChanged: (v) => setState(() => _isPurchased = v),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _save,
                icon: Icon(isEditing ? Icons.save : Icons.add),
                label: Text(isEditing ? 'Update Item' : 'Add Item'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
