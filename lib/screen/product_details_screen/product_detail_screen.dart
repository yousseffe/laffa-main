import 'package:ecommerce_laffa/l10n/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher package
import 'package:provider/provider.dart';
import 'package:ecommerce_laffa/widget/carousel_slider.dart';
import 'package:ecommerce_laffa/widget/page_wrapper.dart';
import '../../core/data/data_provider.dart';
import '../../core/data/cart_provider.dart';
import '../../core/data/region_provider.dart';
import '../../models/product.dart';
import '../../utility/app_color.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen(this.product, {super.key});

  void _addToCart(BuildContext context) {
    Provider.of<CartProvider>(context, listen: false).addToCart(product);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("تم إضافة المنتج إلى السلة"),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);
    final double deliveryFee = context.watch<RegionProvider>().deliveryFee;

    String productName = product.nameAr ?? product.nameEn ?? '';
    String productDescription = product.descriptionAr ?? product.descriptionEn ?? '';

    double price = (product.price ?? 0) + deliveryFee;
    double offerPrice = product.offerPrice != null && product.offerPrice! > 0
        ? product.offerPrice! + deliveryFee
        : 0;
    const String currencySymbol = "دينار";

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.black),
          ),
        ),
        body: SingleChildScrollView(
          child: PageWrapper(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Centered product image section with margin from top
                Container(
                  padding: const EdgeInsets.only(top: 50),
                  height: height * 0.5,
                  width: width,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                  ),
                  child: Center(
                    child: CarouselSlider(items: product.images ?? []),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product name
                      Text(
                        productName,
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 10),
                      // Product status
                      if (product.status != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _getStatusColor(product.status!).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            localizations.translate(product.status!),
                            style: TextStyle(
                              color: _getStatusColor(product.status!),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      const SizedBox(height: 10),
                      // Product price and offer section
                      Row(
                        children: [
                          Text(
                            offerPrice > 0
                                ? "${NumberFormat('#,##0.##').format(offerPrice)} $currencySymbol"
                                : "${NumberFormat('#,##0.##').format(price)} $currencySymbol",
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.green),
                          ),
                          const SizedBox(width: 5),
                          Visibility(
                            visible: offerPrice > 0 && offerPrice != price,
                            child: Text(
                              "${NumberFormat('#,##0.##').format(price)} $currencySymbol",
                              style: const TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.red,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      // Product description
                      Text(
                        localizations.translate('about'),
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 10),
                      Text(productDescription),
                      const SizedBox(height: 40),
                      // Add to Cart Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () => _addToCart(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.darkOrange,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_shopping_cart,
                                color: Colors.white,
                                size: 24,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "أضف إلى السلة", 
                                style: TextStyle(color: Colors.white, fontSize: 18)
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Color _getStatusColor(String status) {
    switch (status) {
      case 'available':
        return Colors.green;
      case 'available_soon':
        return Colors.blue;
      case 'order_3_days':
      case 'order_week':
      case 'order_10_days':
      case 'order_2_weeks':
        return Colors.orange;
      case 'less_than_3_pieces':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
