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

  // Sentinel "All" entry - matched by this fixed id, never a real Mongo _id.
  static const String _allSubCategoryId = '__all__';
  SubCategory _buildAllSubCategory() => SubCategory(sId: _allSubCategoryId, nameAr: 'الكل', nameEn: 'All');

  filterInitialProductAndSubCategory(Category selectedCategory) {
    final allSubCategory = _buildAllSubCategory();
    mySelectedSubCategory = allSubCategory;
    mySelectedCategory = selectedCategory;
    subCategories =
        _dataProvider.subCategories.where((element) => element.categoryId?.sId == selectedCategory.sId).toList();
    subCategories.insert(0, allSubCategory);
    filteredProduct =
        _dataProvider.products.where((element) => element.proCategoryId?.sId == selectedCategory.sId).toList();
    notifyListeners();
  }

  filterProductBySubCategory(SubCategory subCategory) {
    mySelectedSubCategory = subCategory;
    if (subCategory.sId == _allSubCategoryId) {
      filteredProduct =
          _dataProvider.products.where((element) => element.proCategoryId?.sId == mySelectedCategory?.sId).toList();
    }
    else{
      filteredProduct =
          _dataProvider.products.where((element) => element.proSubCategoryId?.sId == subCategory.sId).toList();
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
