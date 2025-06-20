import 'package:ecommerce_laffa/l10n/locale_provider.dart';
import 'package:ecommerce_laffa/utility/extensions.dart';

import '../../models/category.dart';
import '../../models/sub_category.dart';
import 'provider/product_by_category_provider.dart';
import '../../utility/app_color.dart';
import '../../widget/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widget/horizondal_list.dart';
import '../../widget/product_grid_view.dart';

class ProductByCategoryScreen extends StatelessWidget {
  final Category selectedCategory;

  const ProductByCategoryScreen({super.key, required this.selectedCategory});

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);
    Locale currentLocale = Localizations.localeOf(context);

    // Determine the product name and description based on the current locale
    String selectedCategoryName;
    switch (currentLocale.languageCode) {
      case 'ar':
        selectedCategoryName = selectedCategory.nameAr ?? selectedCategory.nameEn ?? '';
        break;
      case 'fr':
        selectedCategoryName = selectedCategory.nameFr ?? selectedCategory.nameEn ?? '';
        break;
      default:
        selectedCategoryName = selectedCategory.nameEn ?? '';
    }
    Future.delayed(Duration.zero, () {
      context.proByCProvider.filterInitialProductAndSubCategory(selectedCategory);
    });
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              snap: true,
              title: Text(
                "${selectedCategoryName}",
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColor.darkOrange),
              ),
              expandedHeight: 190.0,
              flexibleSpace: LayoutBuilder(
                builder: (context, constraints) {
                  var top = constraints.biggest.height - MediaQuery.of(context).padding.top;
                  return Stack(
                    children: [
                      Positioned(
                        top: top - 145,
                        left: 0,
                        right: 0,
                        child: Column(
                          children: [
                            Consumer<ProductByCategoryProvider>(
                              builder: (context, proByCatProvider, child) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                                  child: HorizontalList(
                                    items: proByCatProvider.subCategories,
                                    itemToString: (SubCategory? val) {
                                      if (val == null) return '';
                                      switch (currentLocale.languageCode) {
                                        case 'ar':
                                          return val.nameAr ?? val.nameEn ?? '';
                                        case 'fr':
                                          return val.nameFr ?? val.nameEn ?? '';
                                        default:
                                          return val.nameEn ?? '';
                                      }
                                    },
                                    selected: proByCatProvider.mySelectedSubCategory,
                                    onSelect: (val) {
                                      if (val != null) {
                                        context.proByCProvider.filterProductBySubCategory(val);
                                      }
                                    },
                                  ),
                                );
                              },
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: CustomDropdown<String>(
                                    hintText: localizations.translate('sortByPrice'),
                                    items: [localizations.translate('lowToHigh'), localizations.translate('highToLow')],
                                    onChanged: (val) {
                                      if (val?.toLowerCase() == 'low to high') {
                                        context.proByCProvider.sortProducts(ascending: true);
                                      } else {
                                        context.proByCProvider.sortProducts(ascending: false);
                                      }
                                    },
                                    displayItem: (val) => val,
                                  ),
                                ),
                                
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverToBoxAdapter(
                child: Consumer<ProductByCategoryProvider>(
                  builder: (context, proByCaProvider, child) {
                    return ProductGridView(
                      items: proByCaProvider.filteredProduct,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
