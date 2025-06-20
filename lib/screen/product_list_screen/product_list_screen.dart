import 'package:ecommerce_laffa/l10n/locale_provider.dart';

import '../../core/data/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'components/custom_app_bar.dart';
import '../../../../widget/product_grid_view.dart';
import 'components/category_selector.dart';
import 'components/poster_section.dart';
import 'package:get_storage/get_storage.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);
    final GetStorage storage = GetStorage();
    String name = storage.read('name') ?? 'User';

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await context.read<DataProvider>().getAllProduct(showSnack: true);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${localizations.translate('welcomeUser')}, $name',
                    style: Theme.of(context).textTheme.displayMedium,
                    textDirection: TextDirection.rtl,
                  ),
                  Text(
                    localizations.translate('getSomeStuff'),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 5),
                  Consumer<DataProvider>(
                    builder: (context, dataProvider, child) {
                      if (dataProvider.postersError != null) {
                        return Center(
                          child: Column(
                            children: [
                              Text(dataProvider.postersError!),
                              ElevatedButton(
                                onPressed: () => dataProvider.getAllPosters(showSnack: true),
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        );
                      }
                      return const PosterSection();
                    },
                  ),
                  const SizedBox(height: 5),
                  Text(
                    localizations.translate('bestCategories'),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 5),
                  Consumer<DataProvider>(
                    builder: (context, dataProvider, child) {
                      if (dataProvider.categoriesError != null) {
                        return Center(
                          child: Column(
                            children: [
                              Text(dataProvider.categoriesError!),
                              ElevatedButton(
                                onPressed: () => dataProvider.getAllCategories(showSnack: true),
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        );
                      }
                      return CategorySelector(
                        categories: dataProvider.categories,
                      );
                    },
                  ),
                  Consumer<DataProvider>(
                    builder: (context, dataProvider, child) {
                      if (dataProvider.productsError != null) {
                        return Center(
                          child: Column(
                            children: [
                              Text(dataProvider.productsError!),
                              ElevatedButton(
                                onPressed: () => dataProvider.getAllProduct(showSnack: true),
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        );
                      }
                      return ProductGridView(
                        items: dataProvider.products,
                        isLoading: dataProvider.isLoadingProducts,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
