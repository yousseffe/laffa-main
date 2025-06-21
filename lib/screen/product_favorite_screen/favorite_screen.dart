import 'package:ecommerce_laffa/l10n/locale_provider.dart';
import 'package:ecommerce_laffa/utility/extensions.dart';

import 'provider/favorite_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../widget/product_grid_view.dart';
import '../../utility/app_color.dart';



class FavoriteScreen extends StatelessWidget {
  // final String language;
  const FavoriteScreen({super.key });

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);
    Future.delayed(Duration.zero, () {
     context.favoriteProvider.loadFavoriteItems();
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.translate('favorites'),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColor.darkOrange),
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.all(20),
          child: Consumer<FavoriteProvider>(
            builder: (context, favoriteProvider, child) {
              return SingleChildScrollView(
                child: ProductGridView(
                  items: favoriteProvider.favoriteProduct,
                ),
              );
            },
          )
      ),
    );
  }
}
