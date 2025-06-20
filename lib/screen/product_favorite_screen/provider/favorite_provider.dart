import 'package:ecommerce_laffa/utility/constants.dart';

import '../../../core/data/data_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';
import '../../../models/product.dart';
import '../../../services/http_services.dart';

class FavoriteProvider extends ChangeNotifier {
  final DataProvider _dataProvider;
  final box = GetStorage();
  final HttpService _httpService = HttpService();
  List<Product>  favoriteProduct = [];
  FavoriteProvider(this._dataProvider);

  Future<void> updateToFavoriteList(String productId) async {
    List<dynamic> favoriteList = box.read(FAVORITE_PRODUCT_BOX) ?? [];
    bool isFavorite = favoriteList.contains(productId);

    if (isFavorite) {
      favoriteList.remove(productId);
      await _httpService.updateItem(endpointUrl: 'products/unfavorite', itemId: productId, itemData: {});
    } else {
      favoriteList.add(productId);
      await _httpService.updateItem(endpointUrl: 'products/favorite', itemId: productId, itemData: {});
    }

    box.write(FAVORITE_PRODUCT_BOX, favoriteList);
    loadFavoriteItems();
    notifyListeners();
  }


  bool checkIsItemFavorite(String productId){
    List<dynamic> favorateList = box.read(FAVORITE_PRODUCT_BOX) ?? [];
    bool isExist = favorateList.contains(productId);
    return isExist;
  }


  void loadFavoriteItems(){
    List<dynamic> favorateListIds = box.read(FAVORITE_PRODUCT_BOX) ?? [];
    favoriteProduct = _dataProvider.products.where((product){
      return favorateListIds.contains(product.sId);
    }).toList();
    notifyListeners();
  }

  clearFavoriteList(){
    box.remove(FAVORITE_PRODUCT_BOX);
  }

}
