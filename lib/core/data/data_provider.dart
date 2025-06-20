import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
import '../../../models/category.dart';
import '../../models/api_response.dart';
import '../../models/poster.dart';
import '../../models/product.dart';
import '../../models/sub_category.dart';
// import '../../models/user.dart';
import '../../services/http_services.dart';
// import '../../utility/constants.dart';
import '../../utility/snack_bar_helper.dart';

class DataProvider extends ChangeNotifier {
  HttpService service = HttpService();

  // Loading states
  bool _isLoadingProducts = false;
  bool _isLoadingCategories = false;
  bool _isLoadingSubCategories = false;
  bool _isLoadingPosters = false;

  // Error states
  String? _productsError;
  String? _categoriesError;
  String? _subCategoriesError;
  String? _postersError;

  List<Category> _allCategories = [];
  List<Category> _filteredCategories = [];
  List<Category> get categories => _filteredCategories;

  List<SubCategory> _allSubCategories = [];
  List<SubCategory> _filteredSubCategories = [];

  List<SubCategory> get subCategories => _filteredSubCategories;

  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  List<Product> get products => _filteredProducts;

  List<Poster> _allPosters = [];
  List<Poster> _filteredPosters = [];
  List<Poster> get posters => _filteredPosters;

  // Getters for loading states
  bool get isLoadingProducts => _isLoadingProducts;
  bool get isLoadingCategories => _isLoadingCategories;
  bool get isLoadingSubCategories => _isLoadingSubCategories;
  bool get isLoadingPosters => _isLoadingPosters;

  // Getters for error states
  String? get productsError => _productsError;
  String? get categoriesError => _categoriesError;
  String? get subCategoriesError => _subCategoriesError;
  String? get postersError => _postersError;

  DataProvider() {
    _initializeData();
  }

  Future<void> _initializeData() async {
    await Future.wait([
      getAllProduct(),
      getAllCategories(),
      getAllSubCategories(),
      getAllPosters(),
    ]);
  }

  Future<List<Category>> getAllCategories({bool showSnack = false}) async {
    try {
      _isLoadingCategories = true;
      _categoriesError = null;
      notifyListeners();

      Response response = await service.getItems(endpointUrl: 'categories');
      if (response.isOk) {
        ApiResponse<List<Category>> apiResponse = ApiResponse<List<Category>>.fromJson(
          response.body,
          (json) => (json as List).map((e) => Category.fromJson(e)).toList(),
        );
        _allCategories = apiResponse.data ?? [];
        _filteredCategories = List.from(_allCategories);
        if(showSnack) SnackBarHelper.showSuccessSnackBar(apiResponse.message);
      } else {
        _categoriesError = 'Failed to load categories';
        if(showSnack) SnackBarHelper.showErrorSnackBar(_categoriesError!);
      }
    } catch (e) {
      _categoriesError = e.toString();
      if(showSnack) SnackBarHelper.showErrorSnackBar(_categoriesError!);
    } finally {
      _isLoadingCategories = false;
      notifyListeners();
    }
    return _filteredCategories;
  }

  void filterCategories(String keyword){
    if(keyword.isEmpty){
      _filteredCategories = List.from(_allCategories);
    }else{
      final lowerKeyword = keyword.toLowerCase();
      _filteredCategories = _allCategories.where((category) {return (category.nameEn ?? '').toLowerCase().contains(lowerKeyword);}).toList();
    }
    notifyListeners();
  }

  Future<List<SubCategory>> getAllSubCategories({bool showSnack = false}) async {
    try {
      _isLoadingSubCategories = true;
      _subCategoriesError = null;
      notifyListeners();

      Response response = await service.getItems(endpointUrl: 'subCategories');
      if (response.isOk) {
        ApiResponse<List<SubCategory>> apiResponse = ApiResponse<List<SubCategory>>.fromJson(
          response.body,
          (json) => (json as List).map((e) => SubCategory.fromJson(e)).toList(),
        );
        _allSubCategories = apiResponse.data ?? [];
        _filteredSubCategories = List.from(_allSubCategories);
        if(showSnack) SnackBarHelper.showSuccessSnackBar(apiResponse.message);
      } else {
        _subCategoriesError = 'Failed to load sub-categories';
        if(showSnack) SnackBarHelper.showErrorSnackBar(_subCategoriesError!);
      }
    } catch (e) {
      _subCategoriesError = e.toString();
      if(showSnack) SnackBarHelper.showErrorSnackBar(_subCategoriesError!);
    } finally {
      _isLoadingSubCategories = false;
      notifyListeners();
    }
    return _filteredSubCategories;
  }

  void filterSubCategories(String keyword){
    if(keyword.isEmpty){
      _filteredSubCategories = List.from(_allSubCategories);
    }else{
      final lowerKeyword = keyword.toLowerCase();
      _filteredSubCategories = _allSubCategories.where((subCategory) {return (subCategory.nameEn ?? '').toLowerCase().contains(lowerKeyword);}).toList();
    }
    notifyListeners();
  }

  Future<List<Product>> getAllProduct({bool showSnack = false}) async {
    try {
      _isLoadingProducts = true;
      _productsError = null;
      notifyListeners();

      Response response = await service.getItems(endpointUrl: 'products');
      if(response.isOk) {
        ApiResponse<List<Product>> apiResponse = ApiResponse<List<Product>>.fromJson(
          response.body,
          (json) => (json as List).map((e) => Product.fromJson(e)).toList(),
        );
        _allProducts = apiResponse.data ?? [];
        _filteredProducts = List.from(_allProducts);
        if(showSnack) SnackBarHelper.showSuccessSnackBar(apiResponse.message);
      } else {
        _productsError = 'Failed to load products';
        if(showSnack) SnackBarHelper.showErrorSnackBar(_productsError!);
      }
    } catch (e) {
      _productsError = e.toString();
      if(showSnack) SnackBarHelper.showErrorSnackBar(_productsError!);
    } finally {
      _isLoadingProducts = false;
      notifyListeners();
    }
    return _filteredProducts;
  }
  void filterProduct(String keyword){
    if(keyword.isEmpty){
      _filteredProducts = List.from(_allProducts);
    } else {
      final lowerKeyword = keyword.toLowerCase();
      _filteredProducts = _allProducts.where((product) {
        final productNameContainsKeyword = (product.nameEn?? '').toLowerCase().contains(lowerKeyword);
        final categoryNameContainsKeyword =
            product.proSubCategoryId?.nameEn?.toLowerCase().contains(lowerKeyword) ?? false;
        final subcategoryNameContainsKeyword =
            product.proSubCategoryId?.nameEn?.toLowerCase().contains(lowerKeyword) ?? false;

        return productNameContainsKeyword || categoryNameContainsKeyword || subcategoryNameContainsKeyword;
      }).toList();
    }
    notifyListeners();
  }

  Future<List<Poster>> getAllPosters({bool showSnack = false}) async {
    try {
      _isLoadingPosters = true;
      _postersError = null;
      notifyListeners();

      Response response = await service.getItems(endpointUrl: 'posters');
      if (response.isOk) {
        ApiResponse<List<Poster>> apiResponse = ApiResponse<List<Poster>>.fromJson(
          response.body,
          (json) => (json as List).map((e) => Poster.fromJson(e)).toList(),
        );
        _allPosters = apiResponse.data ?? [];
        _filteredPosters = List.from(_allPosters);
        if(showSnack) SnackBarHelper.showSuccessSnackBar(apiResponse.message);
      } else {
        _postersError = 'Failed to load posters';
        if(showSnack) SnackBarHelper.showErrorSnackBar(_postersError!);
      }
    } catch (e) {
      _postersError = e.toString();
      if(showSnack) SnackBarHelper.showErrorSnackBar(_postersError!);
    } finally {
      _isLoadingPosters = false;
      notifyListeners();
    }
    return _filteredPosters;
  }
  
  double calculateDiscountPercentage(num originalPrice, num? discountedPrice) {
    if (originalPrice <= 0) {
      throw ArgumentError('Original price must be greater than zero.');
    }

    //? Ensure discountedPrice is not null; if it is, default to the original price (no discount)
    num finalDiscountedPrice = discountedPrice ?? originalPrice;

    if (finalDiscountedPrice > originalPrice) {
     return originalPrice.toDouble();
    }

    double discount = ((originalPrice - finalDiscountedPrice) / originalPrice) * 100;

    //? Return the discount percentage as an integer
    return discount;
  }
}
