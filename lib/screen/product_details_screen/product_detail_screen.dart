import 'package:ecommerce_laffa/l10n/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher package
import '../../../../widget/carousel_slider.dart';
import '../../../../widget/page_wrapper.dart';
import '../../models/product.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen(this.product, {super.key});

  void _openWhatsApp(BuildContext context) async {
    const String ownerPhoneNumber = "23562428867";
    //  const String ownerPhoneNumber = "201140700849";

    Locale currentLocale = Localizations.localeOf(context);
    var localization = AppLocalizations.of(context);
    String productName;
    int price = (product.price ?? 0).ceil();
    int offerPrice = (product.offerPrice ?? 0).ceil();
    String currencySymbol = "\F";
    String? productImageUrl = product.images?.isNotEmpty == true ? product.images!.first.url : null;
    switch (currentLocale.languageCode) {
      case 'ar':
        productName = product.nameAr ?? product.nameEn ?? '';
        price = (price / 5).ceil();
        offerPrice = (offerPrice / 5).ceil();
        currencySymbol = "ريال";
        break;
      case 'fr':
        productName = product.nameFr ?? product.nameEn ?? '';
        break;
      default:
        productName = product.nameEn ?? '';
    }

    String finalPrice = offerPrice > 0 ? "$offerPrice $currencySymbol" : "$price $currencySymbol";

    String message = currentLocale.languageCode == 'ar'
        ? "مرحبًا، أود شراء هذا المنتج:\n\n*$productName*\nالسعر: $finalPrice"
        : currentLocale.languageCode == 'fr'
        ? "Bonjour, je voudrais acheter ce produit:\n\n*$productName*\nPrix: $finalPrice"
        : "Hello, I would like to buy this product:\n\n*$productName*\nPrice: $finalPrice";
    if (productImageUrl != null) {
      message += "\n\n$productImageUrl";
    }
    String encodedMessage = Uri.encodeComponent(message);
    String url = "https://wa.me/$ownerPhoneNumber?text=$encodedMessage";
    print("whatsup");
    print(url);
    print("break point");
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Cannot open WhatsApp")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);
    Locale currentLocale = Localizations.localeOf(context);

    // Determine the product name and description based on the current locale
    String productName;
    String productDescription;
    switch (currentLocale.languageCode) {
      case 'ar':
        productName = product.nameAr ?? product.nameEn ?? '';
        productDescription = product.descriptionAr ?? product.descriptionEn ?? '';
        break;
      case 'fr':
        productName = product.nameFr ?? product.nameEn ?? '';
        productDescription = product.descriptionFr ?? product.descriptionEn ?? '';
        break;
      default:
        productName = product.nameEn ?? '';
        productDescription = product.descriptionEn ?? '';
    }

    int price = (product.price ?? 0).ceil();
    int offerPrice = (product.offerPrice ?? 0).ceil();
    String currencySymbol = "F";

    if (currentLocale.languageCode == 'ar') {
      price = (price / 5).ceil();
      offerPrice = (offerPrice / 5).ceil();
      currencySymbol = "ريال";
    }

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
                            offerPrice > 0 ? "$offerPrice $currencySymbol" : "$price $currencySymbol",
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.green),
                          ),
                          const SizedBox(width: 5),
                          Visibility(
                            visible: offerPrice > 0 && offerPrice != price,
                            child: Text(
                              "$price $currencySymbol",
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
                      // WhatsApp Order Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _openWhatsApp(context),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/whatsapp_logo.png',
                                height: 24,
                                width: 24,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 8),
                              Text(localizations.translate('confirm_order'), style: const TextStyle(color: Colors.white)),
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
