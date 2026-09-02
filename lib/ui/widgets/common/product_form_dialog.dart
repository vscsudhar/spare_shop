import 'package:flutter/material.dart';
import 'package:spare_shop/ui/common/app_colors.dart';
import 'package:spare_shop/ui/common/voltspare_models.dart';

/// Product Create / Edit Dialog supporting Stock-Managed vs On-Demand products.
/// Fulfills PHASE 2 requirements:
/// - Maintain Stock toggle (default ON)
/// - When ON: Stock Quantity is required, integer >= 0
/// - When OFF: Stock Quantity hidden/disabled and not mandatory
/// - Saved value: stockManaged = false, stockQuantity = null (never 99999)
class ProductFormDialog extends StatefulWidget {
  final ProductModel? product;
  final Function(Map<String, dynamic> payload) onSave;

  const ProductFormDialog({
    Key? key,
    this.product,
    required this.onSave,
  }) : super(key: key);

  static Future<void> show(
    BuildContext context, {
    ProductModel? product,
    required Function(Map<String, dynamic> payload) onSave,
  }) {
    return showDialog(
      context: context,
      builder: (context) => ProductFormDialog(
        product: product,
        onSave: onSave,
      ),
    );
  }

  @override
  State<ProductFormDialog> createState() => _ProductFormDialogState();
}

class _ProductFormDialogState extends State<ProductFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _mrpController;
  late TextEditingController _stockController;
  late TextEditingController _descriptionController;

  late bool _maintainStock;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    final double? mrp = p != null
        ? ((p.originalPrice != null && p.originalPrice! > 0)
            ? p.originalPrice!
            : p.price)
        : null;

    _nameController = TextEditingController(text: p?.name ?? '');
    _priceController = TextEditingController(
        text: p != null ? p.price.toStringAsFixed(0) : '');
    _mrpController = TextEditingController(
        text: mrp != null ? mrp.toStringAsFixed(0) : '');
    _stockController = TextEditingController(
        text: (p != null && p.stockCount != null) ? p.stockCount.toString() : '10');
    _descriptionController =
        TextEditingController(text: p?.description ?? '');
    _maintainStock = p?.stockManaged ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _mrpController.dispose();
    _stockController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final price = double.tryParse(_priceController.text.trim()) ?? 0.0;
    final mrp = double.tryParse(_mrpController.text.trim()) ?? price;
    final int? stockQuantity =
        _maintainStock ? int.tryParse(_stockController.text.trim()) : null;

    final payload = <String, dynamic>{
      'name': name,
      'price': price,
      'sellingPrice': (price * 100).toInt(),
      'mrp': (mrp * 100).toInt(),
      'description': _descriptionController.text.trim(),
      'stockManaged': _maintainStock,
      'stockQuantity': stockQuantity,
      'currentStock': stockQuantity,
    };

    widget.onSave(payload);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.product != null;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        isEditing ? 'Edit Spare Part' : 'Add New Spare Part',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: kcVoltSpareTextPrimary,
        ),
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Product Name *',
                  border: OutlineInputBorder(),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Product name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Selling Price (₹) *',
                  border: OutlineInputBorder(),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Selling price is required';
                  }
                  final p = double.tryParse(val.trim());
                  if (p == null || p < 0) {
                    return 'Enter a valid positive price';
                  }
                  return null;
                },
                onChanged: (val) {
                  if (_mrpController.text.isEmpty && val.isNotEmpty) {
                    final p = double.tryParse(val);
                    if (p != null) {
                      _mrpController.text = (p * 1.2).toStringAsFixed(0);
                    }
                  }
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _mrpController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'MRP (₹) *',
                  border: OutlineInputBorder(),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'MRP is required';
                  }
                  final p = double.tryParse(val.trim());
                  if (p == null || p < 0) {
                    return 'Enter a valid positive MRP';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Section: Inventory / Availability
              const Text(
                'Inventory / Availability',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: kcVoltSpareTextPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: kcVoltSpareOffWhite,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: kcVoltSpareBorder),
                ),
                child: SwitchListTile(
                  title: const Text(
                    'Maintain Stock',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  subtitle: Text(
                    _maintainStock
                        ? 'Product inventory is tracked with exact quantity.'
                        : 'On-demand product (2 days delivery). Stock is not maintained.',
                    style: const TextStyle(fontSize: 12),
                  ),
                  value: _maintainStock,
                  activeThumbColor: kcVoltSpareEVGreen,
                  onChanged: (val) {
                    setState(() {
                      _maintainStock = val;
                    });
                  },
                ),
              ),
              if (_maintainStock) ...[
                const SizedBox(height: 12),
                TextFormField(
                  controller: _stockController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Stock Quantity *',
                    border: OutlineInputBorder(),
                    helperText: 'Available inventory units (must be >= 0)',
                  ),
                  validator: (val) {
                    if (!_maintainStock) return null;
                    if (val == null || val.trim().isEmpty) {
                      return 'Stock Quantity is required when Maintain Stock is ON';
                    }
                    final qty = int.tryParse(val.trim());
                    if (qty == null || qty < 0) {
                      return 'Enter a valid non-negative integer';
                    }
                    return null;
                  },
                ),
              ],
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel', style: TextStyle(color: kcVoltSpareDark)),
        ),
        ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: kcVoltSpareDark,
            foregroundColor: kcVoltSpareEVGreen,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Text(isEditing ? 'Save Changes' : 'Create Product'),
        ),
      ],
    );
  }
}
