import '../../../models/category.dart';
import 'package:flutter/cupertino.dart';
import '../../../core/data/data_provider.dart';
import '../../../models/product.dart';
import '../../../models/sub_category.dart';

class ProductByCategoryProvider extends ChangeNotifier {
  final DataProvider _dataProvider;
  Category? mySelectedCategory;
  SubCategory? mySelectedSubCategory;
  List<SubCategory> subCategories = [];
  List<Product> filteredProduct = [];

  ProductByCategoryProvider(this._dataProvider);

  filterInitialProductAndSubCategory(Category selectedCategory) {
    mySelectedSubCategory = SubCategory(nameEn: 'All');
    mySelectedCategory = selectedCategory;
    subCategories =
        _dataProvider.subCategories.where((element) => element.categoryId?.sId == selectedCategory.sId).toList();
    subCategories.insert(0, SubCategory(nameEn: 'All'));
    filteredProduct =
        _dataProvider.products.where((element) => element.proCategoryId?.nameEn == selectedCategory.nameEn).toList();
    notifyListeners();
  }

  filterProductBySubCategory(SubCategory subCategory) {
    mySelectedSubCategory = subCategory;
    if (subCategory.nameEn?.toLowerCase() == 'all') {
      filteredProduct =
          _dataProvider.products.where((element) => element.proCategoryId?.nameEn == mySelectedSubCategory?.nameEn).toList();
    }
    else{
      filteredProduct =
          _dataProvider.products.where((element) => element.proSubCategoryId?.nameEn == subCategory.nameEn).toList();
    }
    notifyListeners();
  }




  void sortProducts({required bool ascending}) {
    filteredProduct.sort((a, b) {
        if (ascending) {
          return a.price!.compareTo(b.price ?? 0);
        } else {
          return b.price!.compareTo(a.price ?? 0);
        }
      }
    );
    notifyListeners();
  }


  void updateUI() {
    notifyListeners();
  }
}
