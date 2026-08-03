import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../core/data/cart_provider.dart';
import '../../utility/app_color.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  void _checkout(BuildContext context, CartProvider cartProvider) async {
    if (cartProvider.items.isEmpty) return;

    final String ownerPhoneNumber = dotenv.env['WHATSAPP_PHONE'] ?? "201140700849";

    String message = "مرحباً، أود إتمام هذا الطلب من سوق الكريمية:\n\n";

    for (var item in cartProvider.items) {
      String productName = item.product.nameAr ?? item.product.nameEn ?? '';
      double price = cartProvider.priceForItem(item);
      message += "▪️ $productName\n";
      message += "الكمية: ${item.quantity} | السعر: ${price} دينار\n";
      message += "الإجمالي: ${cartProvider.totalForItem(item)} دينار\n\n";
    }

    message += "إجمالي الطلب: ${cartProvider.totalCartPrice} دينار\n";

    String encodedMessage = Uri.encodeComponent(message);
    String url = "https://wa.me/$ownerPhoneNumber?text=$encodedMessage";

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      cartProvider.clearCart(); // Clear cart after successful checkout attempt
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("لا يمكن فتح واتساب")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('السلة', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          if (cartProvider.items.isEmpty) {
            return const Center(
              child: Text(
                'السلة فارغة',
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartProvider.items.length,
                  itemBuilder: (context, index) {
                    final cartItem = cartProvider.items[index];
                    final product = cartItem.product;
                    final productName = product.nameAr ?? product.nameEn ?? '';

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey.shade200,
                              ),
                              child: product.images?.isNotEmpty == true
                                  ? Image.network(product.images!.first.url ?? '', fit: BoxFit.cover)
                                  : const Icon(Icons.image, color: Colors.grey),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    productName,
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${cartProvider.priceForItem(cartItem)} دينار',
                                    style: TextStyle(color: AppColor.darkOrange, fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove_circle_outline),
                                        onPressed: () => cartProvider.decreaseQuantity(product),
                                        color: AppColor.darkOrange,
                                      ),
                                      _QuantityField(
                                        key: ValueKey(product.sId),
                                        quantity: cartItem.quantity,
                                        onChanged: (qty) => cartProvider.setQuantity(product, qty),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.add_circle_outline),
                                        onPressed: () => cartProvider.increaseQuantity(product),
                                        color: AppColor.darkOrange,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => cartProvider.removeFromCart(product),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('الإجمالي:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        Text(
                          '${cartProvider.totalCartPrice} دينار',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColor.darkOrange),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => _checkout(context, cartProvider),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.darkOrange,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('إتمام الطلب عبر واتساب', style: TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// Lets the customer tap in and type an exact quantity instead of only using +/-.
class _QuantityField extends StatefulWidget {
  final int quantity;
  final ValueChanged<int> onChanged;

  const _QuantityField({super.key, required this.quantity, required this.onChanged});

  @override
  State<_QuantityField> createState() => _QuantityFieldState();
}

class _QuantityFieldState extends State<_QuantityField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: '${widget.quantity}');
  }

  @override
  void didUpdateWidget(covariant _QuantityField oldWidget) {
    super.didUpdateWidget(oldWidget);
    final currentText = int.tryParse(_controller.text);
    if (currentText != widget.quantity) {
      _controller.text = '${widget.quantity}';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit(String value) {
    final int? parsed = int.tryParse(value.trim());
    if (parsed == null) {
      _controller.text = '${widget.quantity}';
      return;
    }
    widget.onChanged(parsed);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      child: TextField(
        controller: _controller,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        style: const TextStyle(fontSize: 16),
        decoration: const InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 8),
          border: OutlineInputBorder(),
        ),
        onSubmitted: _submit,
        onTapOutside: (_) => _submit(_controller.text),
      ),
    );
  }
}
