import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  const EditProductScreen({super.key});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  bool _isLoading = false;
  bool _isInit = true;
  late String productId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      productId = ModalRoute.of(context)!.settings.arguments as String;
      final product = Provider.of<ProductProvider>(context, listen: false)
          .findById(productId);
      _titleController = TextEditingController(text: product.title);
      _priceController = TextEditingController(text: product.price.toString());
      _descriptionController = TextEditingController(text: product.description);
      _isInit = false;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final updatedProduct = Product(
        id: productId,
        title: _titleController.text,
        price: double.parse(_priceController.text),
        description: _descriptionController.text,
      );

      await Provider.of<ProductProvider>(context, listen: false)
          .updateProduct(productId, updatedProduct);

      if (!mounted) return;
  
      Navigator.of(context).pop(true);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${error.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.deepPurpleAccent.shade400,
                Colors.deepPurpleAccent,
                Colors.purpleAccent.shade200,
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: const [0.0, 0.5, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  prefixIcon: Icon(Icons.label),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Enter a title' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  prefixIcon: Icon(Icons.currency_rupee),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Enter a price' : null,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  prefixIcon: Icon(Icons.description),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Enter a description' : null,
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton.icon(
                  icon: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.save, color: Colors.white),
                  label: Text(
                    _isLoading ? 'Updating...' : 'Update Product',
                    style: const TextStyle(color: Colors.white),
                  ),
                  onPressed: _isLoading ? null : _saveForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    minimumSize: const Size(200, 50),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}