import '../../product_by_category_screen/product_by_category_screen.dart';
import '../../../utility/animation/open_container_wrapper.dart';
import 'package:flutter/material.dart';
import '../../../models/category.dart';
import '../../../l10n/locale_provider.dart';

class CategorySelector extends StatefulWidget {
  final List<Category> categories;

  const CategorySelector({
    super.key,
    required this.categories,
  });

  @override
  _CategorySelectorState createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  late Locale currentLocale;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    currentLocale = Localizations.localeOf(context);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60, // Reduced height for a more compact layout
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: widget.categories.length,
        itemBuilder: (context, index) {
          final category = widget.categories[index];


          // Determine the category name based on the current locale
          String categoryName = currentLocale.languageCode == 'ar'
                          ? category.nameAr ?? ''
                          : currentLocale.languageCode == 'fr'
                              ? category.nameFr ?? ''
                              : category.nameEn ?? '';
          

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            child: OpenContainerWrapper(
              nextScreen: ProductByCategoryScreen(selectedCategory: widget.categories[index]),
              child: Container(
                width: 94, // Adjusted width for better text fitting
                height: 50, // Adjusted height for better text fitting
                margin: const EdgeInsets.symmetric(horizontal: 6),
                padding: const EdgeInsets.symmetric(vertical: 1),
                decoration: BoxDecoration(
                  color: category.isSelected ? const Color(0xFFf16b26) : const Color(0xFFE5E6E8),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      categoryName,
                      style: TextStyle(
                        color: category.isSelected ? Colors.white : Colors.black,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      softWrap: true,
                      textAlign: TextAlign.center, // Center align text for better appearance
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}