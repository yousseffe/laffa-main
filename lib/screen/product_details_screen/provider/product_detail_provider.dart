import 'package:flutter/cupertino.dart';
import '../../../core/data/data_provider.dart';


class ProductDetailProvider extends ChangeNotifier {
  final DataProvider _dataProvider;
  String? selectedVariant;

  ProductDetailProvider(this._dataProvider);

  // void addToCart(Product product){
  //   if(product.proVariantId!.isNotEmpty && selectedVariant == null){
  //     SnackBarHelper.showErrorSnackBar('Please select a variant');
  //     return;
  //   }
  //   double? price = product.offerPrice != product.price ? product.offerPrice : product.price;
  //   flutterCart.addToCart(cartModel: CartModel(
  //       productId: '${product.sId}',
  //       productName: '${product.name}',
  //       productImages: ['${product.images.safeElementAt(0)?.url}'],
  //       variants: [ProductVariant(price: price ?? 0 , color: selectedVariant) ],
  //       productDetails: '${product.description}'));
  //   selectedVariant = null;
  //   SnackBarHelper.showSuccessSnackBar('Item Added');
  //   notifyListeners();
  // }


  void updateUI() {
    notifyListeners();
  }
}
