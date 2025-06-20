import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce_laffa/l10n/locale_provider.dart';
import '../models/product.dart';
import '../screen/product_favorite_screen/provider/favorite_provider.dart';
import '../utility/extensions.dart';
import '../utility/utility_extention.dart';

class ProductGridTile extends StatelessWidget {
  final Product product;
  final int index;
  final bool isPriceOff;

  const ProductGridTile({
    super.key,
    required this.product,
    required this.index,
    required this.isPriceOff,
  });

  @override
  Widget build(BuildContext context) {
    Locale currentLocale = Localizations.localeOf(context);
    var localization = AppLocalizations.of(context);
    String productName;
    int price = (product.price ?? 0).ceil();
    int offerPrice = (product.offerPrice ?? 0).ceil();
    String currencySymbol = "F";

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

    double discountPercentage = context.dataProvider.calculateDiscountPercentage(
      product.price ?? 0,
      product.offerPrice ?? 0,
    );

    bool hasDiscount = (product.offerPrice != null &&
        product.offerPrice != 0 &&
        (product.offerPrice ?? 0) < (product.price ?? 0));

    String discountLabel = currentLocale.languageCode == 'ar' ? 'خصم' : 'OFF';

    return Container(
      height: 320,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Image.network(
                    product.images?.safeElementAt(0)?.url ?? '',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
                if (hasDiscount)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "$discountLabel ${discountPercentage.toInt()}%",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: Consumer<FavoriteProvider>(
                    builder: (context, favoriteProvider, child) {
                      final isFavorite = favoriteProvider.checkIsItemFavorite(product.sId ?? '');
                      return IconButton(
                        icon: Icon(
                          Icons.favorite,
                          color: isFavorite ? Colors.red : Colors.white,
                          size: 22,
                        ),
                        onPressed: () {
                          context.favoriteProvider.updateToFavoriteList(product.sId ?? '');
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (product.status != null && product.status!.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    margin: const EdgeInsets.only(bottom: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(product.status!),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      localization?.translate(product.status!) ?? '',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                Text(
                  productName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      offerPrice != 0
                          ? "$currencySymbol ${NumberFormat('#,###').format(offerPrice)}"
                          : "$currencySymbol ${NumberFormat('#,###').format(price)}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (offerPrice != 0 && offerPrice != price)
                      Text(
                        "$currencySymbol ${NumberFormat('#,###').format(price)}",
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
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
